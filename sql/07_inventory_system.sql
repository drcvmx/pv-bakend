-- ========================================
-- SISTEMA DE INVENTARIO SIMPLE
-- Para: Abarrotes, Ferretería, Restaurante
-- ========================================

-- ========================================
-- 1. AGREGAR CÓDIGOS DE IDENTIFICACIÓN A VARIANTES
-- ========================================

-- Agregar columnas para diferentes tipos de código
ALTER TABLE public.variantes 
ADD COLUMN IF NOT EXISTS codigo_barras VARCHAR(50);

ALTER TABLE public.variantes 
ADD COLUMN IF NOT EXISTS codigo_qr VARCHAR(100);

ALTER TABLE public.variantes 
ADD COLUMN IF NOT EXISTS tipo_codigo VARCHAR(20) DEFAULT 'BARRAS';
-- Valores: 'BARRAS' (tienda/ferretería), 'QR' (restaurante), 'AMBOS'

-- Índices para búsqueda rápida
CREATE INDEX IF NOT EXISTS idx_variante_barcode 
ON public.variantes(tenant_id, codigo_barras);

CREATE INDEX IF NOT EXISTS idx_variante_qr 
ON public.variantes(tenant_id, codigo_qr);

-- Constraints de unicidad
DO $$
BEGIN
    -- Código de barras único por tenant
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'unique_barcode_per_tenant'
    ) THEN
        ALTER TABLE public.variantes 
        ADD CONSTRAINT unique_barcode_per_tenant 
        UNIQUE NULLS NOT DISTINCT (tenant_id, codigo_barras);
    END IF;
    
    -- Código QR único por tenant
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'unique_qr_per_tenant'
    ) THEN
        ALTER TABLE public.variantes 
        ADD CONSTRAINT unique_qr_per_tenant 
        UNIQUE NULLS NOT DISTINCT (tenant_id, codigo_qr);
    END IF;
    
    -- Tipo de código debe ser válido
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'variantes_tipo_codigo_check'
    ) THEN
        ALTER TABLE public.variantes 
        ADD CONSTRAINT variantes_tipo_codigo_check 
        CHECK (tipo_codigo IN ('BARRAS', 'QR', 'AMBOS'));
    END IF;
END $$;

-- ========================================
-- 2. SESIONES DE INVENTARIO
-- ========================================

CREATE TABLE IF NOT EXISTS public.inventario_sesiones (
    id SERIAL PRIMARY KEY,
    tenant_id UUID NOT NULL,
    sucursal_id INTEGER,
    usuario_nombre VARCHAR(255), -- Nombre del usuario que hace el inventario
    fecha_inicio TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    fecha_cierre TIMESTAMP WITHOUT TIME ZONE,
    estado VARCHAR(20) DEFAULT 'ACTIVA', -- 'ACTIVA', 'CERRADA', 'CANCELADA'
    tipo VARCHAR(50) DEFAULT 'CONTEO_FISICO', -- 'CONTEO_FISICO', 'ENTRADA_MERCANCIA', 'AJUSTE'
    notas TEXT,
    
    CONSTRAINT inventario_sesiones_pkey PRIMARY KEY (id),
    CONSTRAINT inventario_sesiones_tenant_fkey FOREIGN KEY (tenant_id) 
        REFERENCES public.tenants(id) ON DELETE CASCADE,
    CONSTRAINT inventario_sesiones_estado_check CHECK (estado IN ('ACTIVA', 'CERRADA', 'CANCELADA')),
    CONSTRAINT inventario_sesiones_tipo_check CHECK (tipo IN ('CONTEO_FISICO', 'ENTRADA_MERCANCIA', 'AJUSTE'))
);

CREATE INDEX IF NOT EXISTS idx_inventario_sesiones_tenant 
ON public.inventario_sesiones(tenant_id, estado);

-- ========================================
-- 3. CONTEOS DE INVENTARIO
-- ========================================

CREATE TABLE IF NOT EXISTS public.inventario_conteos (
    id SERIAL PRIMARY KEY,
    tenant_id UUID NOT NULL,
    sesion_id INTEGER NOT NULL,
    variante_id BIGINT NOT NULL,
    codigo_barras VARCHAR(50), -- El código que se escaneó
    cantidad_fisica NUMERIC(10,4) NOT NULL, -- Cantidad contada físicamente
    cantidad_sistema NUMERIC(10,4), -- Cantidad que decía el sistema antes
    diferencia NUMERIC(10,4), -- Diferencia (física - sistema)
    ubicacion VARCHAR(255), -- "Estante A3", "Bodega 2", etc.
    fecha_conteo TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    notas TEXT,
    
    CONSTRAINT inventario_conteos_pkey PRIMARY KEY (id),
    CONSTRAINT inventario_conteos_tenant_fkey FOREIGN KEY (tenant_id) 
        REFERENCES public.tenants(id) ON DELETE CASCADE,
    CONSTRAINT inventario_conteos_sesion_fkey FOREIGN KEY (sesion_id) 
        REFERENCES public.inventario_sesiones(id) ON DELETE CASCADE,
    CONSTRAINT inventario_conteos_variante_fkey FOREIGN KEY (variante_id) 
        REFERENCES public.variantes(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_inventario_conteos_sesion 
ON public.inventario_conteos(sesion_id);

CREATE INDEX IF NOT EXISTS idx_inventario_conteos_variante 
ON public.inventario_conteos(tenant_id, variante_id);

-- ========================================
-- 4. ACTUALIZAR TABLA INVENTARIO EXISTENTE
-- ========================================

-- Agregar campos de auditoría
ALTER TABLE public.inventario 
ADD COLUMN IF NOT EXISTS fecha_actualizacion TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW();

ALTER TABLE public.inventario 
ADD COLUMN IF NOT EXISTS usuario_actualizacion VARCHAR(255);

-- Índice compuesto para búsquedas rápidas
CREATE INDEX IF NOT EXISTS idx_inventario_tenant_variante 
ON public.inventario(tenant_id, variante_id, sucursal_id);

-- ========================================
-- 5. POBLAR CÓDIGOS DE EJEMPLO
-- ========================================

-- ABARROTES Don Pepe - Códigos de BARRAS (productos comerciales)
UPDATE public.variantes 
SET codigo_barras = '7501234567890', tipo_codigo = 'BARRAS'
WHERE tenant_id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11' 
AND id = (
    SELECT v.id FROM variantes v
    JOIN productos p ON v.producto_id = p.id
    WHERE p.nombre = 'Coca Cola' AND v.nombre_variante = '600ml'
    LIMIT 1
);

UPDATE public.variantes 
SET codigo_barras = '7501234567891', tipo_codigo = 'BARRAS'
WHERE tenant_id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11' 
AND id = (
    SELECT v.id FROM variantes v
    JOIN productos p ON v.producto_id = p.id
    WHERE p.nombre = 'Coca Cola' AND v.nombre_variante = '2L'
    LIMIT 1
);

-- FERRETERÍA El Tornillo - Códigos de BARRAS (productos comerciales)
UPDATE public.variantes 
SET codigo_barras = '8901234567890', tipo_codigo = 'BARRAS'
WHERE tenant_id = '2853318c-e931-4718-b955-4508168e6953' 
AND id = (
    SELECT v.id FROM variantes v
    JOIN productos p ON v.producto_id = p.id
    WHERE p.tenant_id = '2853318c-e931-4718-b955-4508168e6953'
    LIMIT 1
);

-- RESTAURANTE El Sazón - Códigos QR (platillos propios)
-- Generar códigos QR únicos para platillos
UPDATE public.variantes 
SET codigo_qr = 'QR-HAMBURGUESA-CLASICA', tipo_codigo = 'QR'
WHERE tenant_id = '83cfebd6-0668-43d1-a26f-46f32fdd8944' 
AND id = (
    SELECT v.id FROM variantes v
    JOIN productos p ON v.producto_id = p.id
    WHERE p.nombre ILIKE '%Hamburguesa%' AND p.tenant_id = '83cfebd6-0668-43d1-a26f-46f32fdd8944'
    LIMIT 1
);

UPDATE public.variantes 
SET codigo_qr = 'QR-TACOS-PASTOR', tipo_codigo = 'QR'
WHERE tenant_id = '83cfebd6-0668-43d1-a26f-46f32fdd8944' 
AND id = (
    SELECT v.id FROM variantes v
    JOIN productos p ON v.producto_id = p.id
    WHERE p.nombre ILIKE '%Tacos%' AND p.tenant_id = '83cfebd6-0668-43d1-a26f-46f32fdd8944'
    LIMIT 1
);

-- ========================================
-- 6. SESIÓN DE INVENTARIO DE EJEMPLO
-- ========================================

-- Crear una sesión de ejemplo para Abarrotes Don Pepe
INSERT INTO public.inventario_sesiones 
    (tenant_id, sucursal_id, usuario_nombre, tipo, notas)
VALUES (
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    1,
    'Juan Pérez',
    'CONTEO_FISICO',
    'Inventario de ejemplo - Sucursal principal'
);

-- ========================================
-- 7. VISTAS ÚTILES
-- ========================================

-- Vista para ver stock actual por producto
CREATE OR REPLACE VIEW v_stock_actual AS
SELECT 
    t.nombre AS tenant_nombre,
    p.nombre AS producto_nombre,
    v.nombre_variante,
    v.codigo_barras,
    v.precio,
    v.unidad_medida,
    COALESCE(SUM(i.cantidad), 0) AS stock_total,
    COUNT(DISTINCT i.sucursal_id) AS sucursales_con_stock
FROM variantes v
JOIN productos p ON v.producto_id = p.id
JOIN tenants t ON v.tenant_id = t.id
LEFT JOIN inventario i ON v.id = i.variante_id
GROUP BY t.nombre, p.nombre, v.nombre_variante, v.codigo_barras, v.precio, v.unidad_medida;

-- Vista para ver sesiones de inventario activas
CREATE OR REPLACE VIEW v_sesiones_activas AS
SELECT 
    t.nombre AS tenant_nombre,
    s.id AS sesion_id,
    s.usuario_nombre,
    s.tipo,
    s.fecha_inicio,
    COUNT(c.id) AS productos_contados
FROM inventario_sesiones s
JOIN tenants t ON s.tenant_id = t.id
LEFT JOIN inventario_conteos c ON s.id = c.sesion_id
WHERE s.estado = 'ACTIVA'
GROUP BY t.nombre, s.id, s.usuario_nombre, s.tipo, s.fecha_inicio;

-- ========================================
-- 8. FUNCIÓN PARA CERRAR SESIÓN DE INVENTARIO
-- ========================================

CREATE OR REPLACE FUNCTION cerrar_sesion_inventario(p_sesion_id INTEGER)
RETURNS TABLE(
    productos_actualizados INTEGER,
    diferencias_encontradas INTEGER
) AS $$
DECLARE
    v_tenant_id UUID;
    v_productos_actualizados INTEGER := 0;
    v_diferencias INTEGER := 0;
BEGIN
    -- Obtener tenant_id de la sesión
    SELECT tenant_id INTO v_tenant_id
    FROM inventario_sesiones
    WHERE id = p_sesion_id AND estado = 'ACTIVA';
    
    IF v_tenant_id IS NULL THEN
        RAISE EXCEPTION 'Sesión no encontrada o ya está cerrada';
    END IF;
    
    -- Actualizar stock en tabla inventario basado en los conteos
    -- (Aquí iría la lógica de actualización cuando implementemos inventario completo)
    
    -- Contar productos con diferencias
    SELECT COUNT(*) INTO v_diferencias
    FROM inventario_conteos
    WHERE sesion_id = p_sesion_id AND ABS(diferencia) > 0.01;
    
    -- Marcar sesión como cerrada
    UPDATE inventario_sesiones
    SET estado = 'CERRADA', fecha_cierre = NOW()
    WHERE id = p_sesion_id;
    
    RETURN QUERY SELECT v_productos_actualizados, v_diferencias;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- 9. VERIFICACIÓN
-- ========================================

-- Ver variantes con códigos (barras o QR)
SELECT 
    t.nombre AS tenant,
    p.nombre AS producto,
    v.nombre_variante,
    v.tipo_codigo,
    v.codigo_barras,
    v.codigo_qr,
    v.precio
FROM variantes v
JOIN productos p ON v.producto_id = p.id
JOIN tenants t ON v.tenant_id = t.id
WHERE v.codigo_barras IS NOT NULL OR v.codigo_qr IS NOT NULL
ORDER BY t.nombre, p.nombre;

-- Ver sesiones de inventario
SELECT 
    id,
    usuario_nombre,
    tipo,
    estado,
    fecha_inicio,
    notas
FROM inventario_sesiones
ORDER BY fecha_inicio DESC;

-- Ver estadísticas de stock (usando la vista)
SELECT * FROM v_stock_actual
LIMIT 10;
