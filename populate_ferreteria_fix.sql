-- =====================================================
-- CORRECCIÓN Y POBLADO DE FERRETERÍA
-- =====================================================
-- Fecha: 2025-11-29
-- Propósito: Corregir nombre del tenant y poblar productos faltantes
-- =====================================================

-- Asegurar codificación UTF8 para manejar acentos correctamente
SET client_encoding = 'UTF8';

-- 1. Corregir el nombre del tenant (FerreterÝa -> Ferretería)
UPDATE tenants 
SET nombre = 'Ferretería El Tornillo' 
WHERE id = '2853318c-e931-4718-b955-4508168e6953';

-- =====================================================
-- TENANT 2: FERRETERÍA EL TORNILLO
-- =====================================================
-- ID: 2853318c-e931-4718-b955-4508168e6953

DO $$
DECLARE
    v_tenant_id UUID := '2853318c-e931-4718-b955-4508168e6953';
    v_global_product RECORD;
    v_producto_id BIGINT;
    v_contador INT := 0;
BEGIN
    RAISE NOTICE '=== POBLANDO FERRETERÍA EL TORNILLO ===';
    
    -- Producto 1: Arco Industrial Aluminio
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '10251';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 85.00, 'pza', '10251');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 2: Arco Junior
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '10210';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 65.00, 'pza', '10210');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 3: Arco Profesional
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '10230';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 95.00, 'pza', '10230');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 4: Arnés Truper
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '14433';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 450.00, 'pza', '14433');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 5: Barreta de Punta
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '10759';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 180.00, 'pza', '10759');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 6: Barreta
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '10850';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 220.00, 'pza', '10850');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 7: Cincel
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '12163';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 45.00, 'pza', '12163');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 8: Cincel Ladrillero
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '12184';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 55.00, 'pza', '12184');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 9: Cinta Ducto Plata
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '12611';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 75.00, 'pza', '12611');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 10: Cinta de Aislar Negro
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '20521';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 25.00, 'pza', '20521');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 11: Cutter Alma Metálica
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '16976';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 35.00, 'pza', '16976');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 12: Cutter Profesional
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '16977';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 55.00, 'pza', '16977');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 13: Desarmadores Joyero 15pz
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '14205';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 120.00, 'pza', '14205');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 14: Juego 5 Desarmadores
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '14137';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 180.00, 'pza', '14137');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 15: Linterna 20 LED
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '10629';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 95.00, 'pza', '10629');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 16: Lentes de Seguridad
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '14252';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 45.00, 'pza', '14252');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 17: Martillo de Bola
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '16901';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 120.00, 'pza', '16901');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 18: Martillo de Uña
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '16654';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 110.00, 'pza', '16654');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 19: Pala Redonda
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '17150';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 180.00, 'pza', '17150');
        v_contador := v_contador + 1;
    END IF;
    
    -- Producto 20: Pala Cuadrada
    SELECT * INTO v_global_product FROM global_products WHERE codigo_barras = '17161';
    IF FOUND THEN
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_id, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;
        
        INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
        VALUES (v_tenant_id, v_producto_id, 'Estándar', 190.00, 'pza', '17161');
        v_contador := v_contador + 1;
    END IF;
    
    RAISE NOTICE 'Productos agregados a Ferretería El Tornillo: %', v_contador;
END $$;

-- =====================================================
-- VERIFICACIÓN FINAL
-- =====================================================

SELECT 
    t.nombre AS tienda,
    t.tipo_negocio,
    COUNT(DISTINCT p.id) AS total_productos,
    COUNT(DISTINCT v.id) AS total_variantes
FROM tenants t
LEFT JOIN productos p ON p.tenant_id = t.id
LEFT JOIN variantes v ON v.tenant_id = t.id
WHERE t.id IN (
    'a1b2c3d4-e5f6-7890-1234-567890abcdef',  -- Tienda Don Jose
    '2853318c-e931-4718-b955-4508168e6953'   -- Ferretería El Tornillo
)
GROUP BY t.id, t.nombre, t.tipo_negocio
ORDER BY t.nombre;
