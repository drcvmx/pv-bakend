-- =====================================================
-- SCRIPT DE NORMALIZACIÓN DE BASE DE DATOS
-- punto_venta_saas - Sistema Multi-Tenant POS
-- =====================================================
-- Fecha: 2025-11-28
-- Propósito: 
--   1. Normalizar tenant_id de VARCHAR a UUID
--   2. Agregar Foreign Keys para tenant_id
--   3. Documentar relación global_products <-> productos
-- =====================================================

-- =====================================================
-- PASO 0: BACKUP Y VERIFICACIÓN
-- =====================================================
-- IMPORTANTE: Ejecutar backup antes de aplicar cambios
-- pg_dump -U postgres -d punto_venta_saas > backup_antes_migracion.sql

-- Verificar datos existentes
DO $$
BEGIN
    RAISE NOTICE '=== VERIFICACIÓN DE DATOS EXISTENTES ===';
    RAISE NOTICE 'Tenants: %', (SELECT COUNT(*) FROM tenants);
    RAISE NOTICE 'Productos: %', (SELECT COUNT(*) FROM productos);
    RAISE NOTICE 'Variantes: %', (SELECT COUNT(*) FROM variantes);
    RAISE NOTICE 'Inventario: %', (SELECT COUNT(*) FROM inventario);
    RAISE NOTICE 'Orders: %', (SELECT COUNT(*) FROM orders);
    RAISE NOTICE 'User Permissions: %', (SELECT COUNT(*) FROM user_tenant_permissions);
END $$;

-- =====================================================
-- PASO 1: AGREGAR COLUMNA global_product_id A productos
-- =====================================================
-- Documentación: Relación entre catálogo global y productos por tenant
-- Cada tienda tiene sus productos, pero puede referenciar datos inmutables
-- del catálogo global (imagen_url, marca, nombre, etc.)

COMMENT ON TABLE global_products IS 
'Catálogo global de productos compartido entre todos los tenants. 
Contiene información inmutable como: nombre, descripción, código de barras, 
marca, categoría, imagen_url. Los productos de cada tenant pueden referenciar 
este catálogo para pre-cargar información al escanear productos.';

COMMENT ON TABLE productos IS 
'Productos específicos de cada tenant. Pueden referenciar global_products 
para heredar información base, pero cada tenant puede personalizar precios, 
variantes, y otros datos específicos de su negocio.';

-- Agregar columna de referencia (opcional, para vincular con catálogo global)
ALTER TABLE productos 
ADD COLUMN IF NOT EXISTS global_product_id UUID,
ADD COLUMN IF NOT EXISTS codigo_barras VARCHAR(50);

-- Crear índice para búsquedas por código de barras
CREATE INDEX IF NOT EXISTS idx_productos_codigo_barras 
ON productos(codigo_barras);

-- Agregar FK opcional (permite NULL para productos personalizados)
ALTER TABLE productos
ADD CONSTRAINT fk_productos_global_product
FOREIGN KEY (global_product_id) 
REFERENCES global_products(id)
ON DELETE SET NULL;

COMMENT ON COLUMN productos.global_product_id IS 
'Referencia opcional al catálogo global. Si está presente, el producto 
hereda información base del catálogo global. NULL indica producto personalizado.';

-- =====================================================
-- PASO 2: CREAR COLUMNAS TEMPORALES tenant_id_uuid
-- =====================================================

-- Tabla: productos
ALTER TABLE productos 
ADD COLUMN IF NOT EXISTS tenant_id_uuid UUID;

-- Tabla: variantes
ALTER TABLE variantes 
ADD COLUMN IF NOT EXISTS tenant_id_uuid UUID;

-- Tabla: inventario
ALTER TABLE inventario 
ADD COLUMN IF NOT EXISTS tenant_id_uuid UUID;

-- Tabla: orders
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS tenant_id_uuid UUID;

-- Tabla: user_tenant_permissions
ALTER TABLE user_tenant_permissions 
ADD COLUMN IF NOT EXISTS tenant_id_uuid UUID;

-- =====================================================
-- PASO 3: MIGRAR DATOS DE VARCHAR A UUID
-- =====================================================

-- Migrar productos
UPDATE productos 
SET tenant_id_uuid = tenant_id::UUID
WHERE tenant_id IS NOT NULL 
  AND tenant_id ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$';

-- Migrar variantes
UPDATE variantes 
SET tenant_id_uuid = tenant_id::UUID
WHERE tenant_id IS NOT NULL 
  AND tenant_id ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$';

-- Migrar inventario
UPDATE inventario 
SET tenant_id_uuid = tenant_id::UUID
WHERE tenant_id IS NOT NULL 
  AND tenant_id ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$';

-- Migrar orders
UPDATE orders 
SET tenant_id_uuid = tenant_id::UUID
WHERE tenant_id IS NOT NULL 
  AND tenant_id ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$';

-- Migrar user_tenant_permissions
UPDATE user_tenant_permissions 
SET tenant_id_uuid = tenant_id::UUID
WHERE tenant_id IS NOT NULL 
  AND tenant_id ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$';

-- =====================================================
-- PASO 4: VERIFICAR MIGRACIÓN
-- =====================================================

DO $$
DECLARE
    v_productos_migrados INT;
    v_variantes_migradas INT;
    v_inventario_migrado INT;
    v_orders_migradas INT;
    v_permissions_migradas INT;
BEGIN
    SELECT COUNT(*) INTO v_productos_migrados FROM productos WHERE tenant_id_uuid IS NOT NULL;
    SELECT COUNT(*) INTO v_variantes_migradas FROM variantes WHERE tenant_id_uuid IS NOT NULL;
    SELECT COUNT(*) INTO v_inventario_migrado FROM inventario WHERE tenant_id_uuid IS NOT NULL;
    SELECT COUNT(*) INTO v_orders_migradas FROM orders WHERE tenant_id_uuid IS NOT NULL;
    SELECT COUNT(*) INTO v_permissions_migradas FROM user_tenant_permissions WHERE tenant_id_uuid IS NOT NULL;
    
    RAISE NOTICE '=== VERIFICACIÓN DE MIGRACIÓN ===';
    RAISE NOTICE 'Productos migrados: %', v_productos_migrados;
    RAISE NOTICE 'Variantes migradas: %', v_variantes_migradas;
    RAISE NOTICE 'Inventario migrado: %', v_inventario_migrado;
    RAISE NOTICE 'Orders migradas: %', v_orders_migradas;
    RAISE NOTICE 'Permissions migradas: %', v_permissions_migradas;
    
    -- Verificar si hay registros que no se migraron
    IF EXISTS (SELECT 1 FROM productos WHERE tenant_id IS NOT NULL AND tenant_id_uuid IS NULL) THEN
        RAISE WARNING 'ATENCIÓN: Hay productos con tenant_id que no se migraron';
    END IF;
    
    IF EXISTS (SELECT 1 FROM variantes WHERE tenant_id IS NOT NULL AND tenant_id_uuid IS NULL) THEN
        RAISE WARNING 'ATENCIÓN: Hay variantes con tenant_id que no se migraron';
    END IF;
END $$;

-- =====================================================
-- PASO 5: ELIMINAR ÍNDICES Y CONSTRAINTS ANTIGUOS
-- =====================================================

-- Productos
DROP INDEX IF EXISTS "IDX_e9a086909b696c7c3299e225dc";

-- Variantes
DROP INDEX IF EXISTS "IDX_8a658f42f1b56fca827f7ade1d";

-- Inventario
DROP INDEX IF EXISTS "IDX_f355e907e4e6a3081fbbd79472";

-- Orders
DROP INDEX IF EXISTS "IDX_527dd6efd5f3402f729c6b3e82";

-- User Permissions
DROP INDEX IF EXISTS "IDX_1e66c3af9666e69d888e8ad090";

-- =====================================================
-- PASO 6: RENOMBRAR COLUMNAS
-- =====================================================

-- Renombrar columnas antiguas a _old (por seguridad)
ALTER TABLE productos RENAME COLUMN tenant_id TO tenant_id_old;
ALTER TABLE variantes RENAME COLUMN tenant_id TO tenant_id_old;
ALTER TABLE inventario RENAME COLUMN tenant_id TO tenant_id_old;
ALTER TABLE orders RENAME COLUMN tenant_id TO tenant_id_old;
ALTER TABLE user_tenant_permissions RENAME COLUMN tenant_id TO tenant_id_old;

-- Renombrar columnas nuevas a tenant_id
ALTER TABLE productos RENAME COLUMN tenant_id_uuid TO tenant_id;
ALTER TABLE variantes RENAME COLUMN tenant_id_uuid TO tenant_id;
ALTER TABLE inventario RENAME COLUMN tenant_id_uuid TO tenant_id;
ALTER TABLE orders RENAME COLUMN tenant_id_uuid TO tenant_id;
ALTER TABLE user_tenant_permissions RENAME COLUMN tenant_id_uuid TO tenant_id;

-- =====================================================
-- PASO 7: AGREGAR CONSTRAINTS NOT NULL
-- =====================================================

-- Hacer tenant_id NOT NULL donde sea requerido
ALTER TABLE productos ALTER COLUMN tenant_id SET NOT NULL;
ALTER TABLE variantes ALTER COLUMN tenant_id SET NOT NULL;
ALTER TABLE inventario ALTER COLUMN tenant_id SET NOT NULL;
ALTER TABLE orders ALTER COLUMN tenant_id SET NOT NULL;
-- user_tenant_permissions puede ser NULL temporalmente

-- =====================================================
-- PASO 8: AGREGAR FOREIGN KEYS
-- =====================================================

-- Productos -> Tenants
ALTER TABLE productos
ADD CONSTRAINT fk_productos_tenant
FOREIGN KEY (tenant_id) 
REFERENCES tenants(id)
ON DELETE CASCADE;

-- Variantes -> Tenants
ALTER TABLE variantes
ADD CONSTRAINT fk_variantes_tenant
FOREIGN KEY (tenant_id) 
REFERENCES tenants(id)
ON DELETE CASCADE;

-- Inventario -> Tenants
ALTER TABLE inventario
ADD CONSTRAINT fk_inventario_tenant
FOREIGN KEY (tenant_id) 
REFERENCES tenants(id)
ON DELETE CASCADE;

-- Orders -> Tenants
ALTER TABLE orders
ADD CONSTRAINT fk_orders_tenant
FOREIGN KEY (tenant_id) 
REFERENCES tenants(id)
ON DELETE CASCADE;

-- User Permissions -> Tenants
ALTER TABLE user_tenant_permissions
ADD CONSTRAINT fk_user_permissions_tenant
FOREIGN KEY (tenant_id) 
REFERENCES tenants(id)
ON DELETE CASCADE;

-- =====================================================
-- PASO 9: RECREAR ÍNDICES OPTIMIZADOS
-- =====================================================

-- Productos: índice compuesto para búsquedas por tenant y nombre
CREATE INDEX idx_productos_tenant_nombre 
ON productos(tenant_id, nombre);

-- Productos: índice para búsquedas por tenant
CREATE INDEX idx_productos_tenant 
ON productos(tenant_id);

-- Variantes: índice compuesto para búsquedas por tenant
CREATE INDEX idx_variantes_tenant_id 
ON variantes(tenant_id, id);

-- Variantes: índice para producto_id (FK)
CREATE INDEX idx_variantes_producto 
ON variantes(producto_id);

-- Inventario: índice único compuesto (previene duplicados)
CREATE UNIQUE INDEX idx_inventario_tenant_variante_sucursal 
ON inventario(tenant_id, variante_id, sucursal_id);

-- Inventario: índice para variante_id (FK)
CREATE INDEX idx_inventario_variante 
ON inventario(variante_id);

-- Orders: índice para tenant_id
CREATE INDEX idx_orders_tenant 
ON orders(tenant_id);

-- Orders: índice para status (consultas frecuentes)
CREATE INDEX idx_orders_status 
ON orders(status);

-- Orders: índice compuesto para reportes
CREATE INDEX idx_orders_tenant_created 
ON orders(tenant_id, created_at DESC);

-- User Permissions: índice único compuesto
CREATE UNIQUE INDEX idx_user_permissions_user_tenant 
ON user_tenant_permissions(user_id, tenant_id);

-- =====================================================
-- PASO 10: AGREGAR COMENTARIOS DE DOCUMENTACIÓN
-- =====================================================

COMMENT ON COLUMN productos.tenant_id IS 
'UUID del tenant propietario del producto. FK a tenants(id). CASCADE on delete.';

COMMENT ON COLUMN variantes.tenant_id IS 
'UUID del tenant propietario de la variante. FK a tenants(id). CASCADE on delete.';

COMMENT ON COLUMN inventario.tenant_id IS 
'UUID del tenant propietario del inventario. FK a tenants(id). CASCADE on delete.';

COMMENT ON COLUMN orders.tenant_id IS 
'UUID del tenant propietario de la orden. FK a tenants(id). CASCADE on delete.';

COMMENT ON COLUMN user_tenant_permissions.tenant_id IS 
'UUID del tenant al que pertenecen los permisos. FK a tenants(id). CASCADE on delete.';

-- =====================================================
-- PASO 11: CREAR VISTA PARA PRODUCTOS CON CATÁLOGO GLOBAL
-- =====================================================

CREATE OR REPLACE VIEW v_productos_completos AS
SELECT 
    p.id,
    p.tenant_id,
    p.nombre,
    p.descripcion,
    p.marca,
    p.categoria,
    p.proveedor,
    p.codigo_barras,
    -- Datos del catálogo global (si existe)
    gp.id as global_product_id,
    COALESCE(p.nombre, gp.nombre) as nombre_display,
    COALESCE(p.descripcion, gp.descripcion) as descripcion_display,
    COALESCE(p.marca, gp.marca) as marca_display,
    COALESCE(p.categoria, gp.categoria) as categoria_display,
    COALESCE(p.imagen_url, gp.imagen_url) as imagen_url_display,
    gp.business_type as tipo_negocio_sugerido
FROM productos p
LEFT JOIN global_products gp ON p.global_product_id = gp.id;

COMMENT ON VIEW v_productos_completos IS 
'Vista que combina productos del tenant con información del catálogo global.
Usa COALESCE para priorizar datos del tenant, pero muestra datos globales si no existen.';

-- =====================================================
-- PASO 12: FUNCIÓN HELPER PARA CREAR PRODUCTO DESDE CATÁLOGO
-- =====================================================

CREATE OR REPLACE FUNCTION crear_producto_desde_catalogo(
    p_tenant_id UUID,
    p_global_product_id UUID,
    p_precio_base NUMERIC DEFAULT NULL
) RETURNS BIGINT AS $$
DECLARE
    v_producto_id BIGINT;
    v_global_product RECORD;
BEGIN
    -- Obtener datos del catálogo global
    SELECT * INTO v_global_product 
    FROM global_products 
    WHERE id = p_global_product_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Producto global % no encontrado', p_global_product_id;
    END IF;
    
    -- Crear producto para el tenant
    INSERT INTO productos (
        tenant_id,
        global_product_id,
        nombre,
        descripcion,
        marca,
        categoria,
        codigo_barras,
        imagen_url
    ) VALUES (
        p_tenant_id,
        p_global_product_id,
        v_global_product.nombre,
        v_global_product.descripcion,
        v_global_product.marca,
        v_global_product.categoria,
        v_global_product.codigo_barras,
        v_global_product.imagen_url
    ) RETURNING id INTO v_producto_id;
    
    -- Crear variante por defecto si se proporciona precio
    IF p_precio_base IS NOT NULL THEN
        INSERT INTO variantes (
            tenant_id,
            producto_id,
            nombre_variante,
            precio,
            unidad_medida,
            codigo_barras
        ) VALUES (
            p_tenant_id,
            v_producto_id,
            'Estándar',
            p_precio_base,
            'Unidad',
            v_global_product.codigo_barras
        );
    END IF;
    
    RETURN v_producto_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION crear_producto_desde_catalogo IS 
'Función helper para crear un producto en el tenant a partir del catálogo global.
Copia automáticamente nombre, descripción, marca, categoría, código de barras e imagen.
Opcionalmente crea una variante por defecto con el precio especificado.';

-- =====================================================
-- PASO 13: VERIFICACIÓN FINAL
-- =====================================================

DO $$
BEGIN
    RAISE NOTICE '=== MIGRACIÓN COMPLETADA ===';
    RAISE NOTICE 'Foreign Keys agregadas:';
    RAISE NOTICE '  - productos.tenant_id -> tenants.id';
    RAISE NOTICE '  - variantes.tenant_id -> tenants.id';
    RAISE NOTICE '  - inventario.tenant_id -> tenants.id';
    RAISE NOTICE '  - orders.tenant_id -> tenants.id';
    RAISE NOTICE '  - user_tenant_permissions.tenant_id -> tenants.id';
    RAISE NOTICE '  - productos.global_product_id -> global_products.id';
    RAISE NOTICE '';
    RAISE NOTICE 'Índices optimizados creados';
    RAISE NOTICE 'Vista v_productos_completos creada';
    RAISE NOTICE 'Función crear_producto_desde_catalogo() creada';
    RAISE NOTICE '';
    RAISE NOTICE 'IMPORTANTE: Las columnas *_old pueden eliminarse después de verificar';
    RAISE NOTICE 'que todo funciona correctamente con: ALTER TABLE xxx DROP COLUMN tenant_id_old;';
END $$;

-- =====================================================
-- PASO 14 (OPCIONAL): ELIMINAR COLUMNAS ANTIGUAS
-- =====================================================
-- DESCOMENTAR SOLO DESPUÉS DE VERIFICAR QUE TODO FUNCIONA

/*
ALTER TABLE productos DROP COLUMN IF EXISTS tenant_id_old;
ALTER TABLE variantes DROP COLUMN IF EXISTS tenant_id_old;
ALTER TABLE inventario DROP COLUMN IF EXISTS tenant_id_old;
ALTER TABLE orders DROP COLUMN IF EXISTS tenant_id_old;
ALTER TABLE user_tenant_permissions DROP COLUMN IF EXISTS tenant_id_old;
*/

-- =====================================================
-- EJEMPLOS DE USO
-- =====================================================

/*
-- Ejemplo 1: Crear producto desde catálogo global
SELECT crear_producto_desde_catalogo(
    '123e4567-e89b-12d3-a456-426614174000'::UUID,  -- tenant_id
    '987fcdeb-51a2-43f7-9abc-123456789def'::UUID,  -- global_product_id
    25.50  -- precio_base
);

-- Ejemplo 2: Consultar productos con información global
SELECT * FROM v_productos_completos 
WHERE tenant_id = '123e4567-e89b-12d3-a456-426614174000'::UUID;

-- Ejemplo 3: Buscar productos por código de barras en catálogo global
SELECT * FROM global_products 
WHERE codigo_barras = '7501234567890';

-- Ejemplo 4: Verificar integridad referencial
SELECT 
    t.nombre as tenant,
    COUNT(p.id) as total_productos,
    COUNT(v.id) as total_variantes,
    COUNT(i.id) as total_inventario
FROM tenants t
LEFT JOIN productos p ON p.tenant_id = t.id
LEFT JOIN variantes v ON v.tenant_id = t.id
LEFT JOIN inventario i ON i.tenant_id = t.id
GROUP BY t.id, t.nombre;
*/

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================
