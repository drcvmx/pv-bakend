-- Script para poblar inventario de Tienda de Abarrotes y Ferreteria
-- Ejecutar con: psql -U postgres -d punto_venta_saas -f src/scripts/populate_inventory.sql

DO $$
DECLARE
    v_grocery_tenant_id uuid := 'a1b2c3d4-e5f6-7890-1234-567890abcdef'; -- Tienda Don Jose
    v_hardware_tenant_id uuid := '2853318c-e931-4718-b955-4508168e6953'; -- Ferreteria El Tornillo
    v_product_id uuid;
BEGIN
    RAISE NOTICE 'Iniciando poblacion de inventarios...';
    
    -- ============================================================
    -- TIENDA DE ABARROTES: Tienda Don Jose
    -- ============================================================
    RAISE NOTICE 'Poblando Tienda Don Jose (Abarrotes)...';
    
    -- Papas Fritas Sal de Mar
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_grocery_tenant_id, 'Papas Fritas Sal de Mar', 'Chips (Barcel)', 'Botanas', 'Barcel', '7501000264049', 
            (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000264049' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_grocery_tenant_id, v_product_id, 'Presentacion Unica', 18.00, 12.60, 'PZA', '7501000264049', true, NOW());

    -- Papas Fritas Fuego
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_grocery_tenant_id, 'Papas Fritas Fuego', 'Chips (Barcel)', 'Botanas', 'Barcel', '7500810024546',
            (SELECT imagen_url FROM global_products WHERE codigo_barras = '7500810024546' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_grocery_tenant_id, v_product_id, 'Presentacion Unica', 19.50, 13.65, 'PZA', '7500810024546', true, NOW());

    -- Takis Fuego
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_grocery_tenant_id, 'Takis Fuego', 'Takis (Barcel)', 'Botanas', 'Barcel', '7501030424536',
            (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501030424536' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_grocery_tenant_id, v_product_id, 'Presentacion Unica', 21.00, 14.70, 'PZA', '7501030424536', true, NOW());

    -- Coca-Cola 3L
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_grocery_tenant_id, 'Refresco Coca-Cola Original (3 L)', 'Coca-Cola', 'Bebidas', 'Coca-Cola', '7501055301824',
            (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501055301824' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_grocery_tenant_id, v_product_id, 'Presentacion Unica', 45.00, 31.50, 'PZA', '7501055301824', true, NOW());

    -- Avena Quaker 3 Minutos
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_grocery_tenant_id, 'Avena Quaker 3 Minutos bote', 'Quaker', 'Cereales', 'Quaker', '750176181039',
            (SELECT imagen_url FROM global_products WHERE codigo_barras = '750176181039' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_grocery_tenant_id, v_product_id, 'Presentacion Unica', 58.00, 40.60, 'PZA', '750176181039', true, NOW());

    -- Galletas Marias Gamesa
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_grocery_tenant_id, 'Galletas Clasicas (850 g)', 'Marias Gamesa', 'Galletas', 'Gamesa', '7501000625062',
            (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000625062' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_grocery_tenant_id, v_product_id, 'Presentacion Unica', 55.00, 38.50, 'PZA', '7501000625062', true, NOW());

    RAISE NOTICE 'Tienda Don Jose poblada con 6 productos de muestra';

    -- ============================================================
    -- FERRETERIA: Ferreteria El Tornillo
    -- ============================================================
    RAISE NOTICE 'Poblando Ferreteria El Tornillo...';

    -- Arco industrial de aluminio
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Arco industrial de aluminio', 'TRUPER / GENERICO', 'Herramientas de Corte', 'TRUPER', '10251', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 225.00, 157.50, 'PZA', '10251', true, NOW());

    -- Arco junior
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Arco junior', 'TRUPER / GENERICO', 'Herramientas de Corte', 'TRUPER', '10210', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 95.00, 66.50, 'PZA', '10210', true, NOW());

    -- Arco profesional
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Arco profesional', 'TRUPER / GENERICO', 'Herramientas de Corte', 'TRUPER', '10230', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 259.00, 181.30, 'PZA', '10230', true, NOW());

    -- Arnes Truper
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'ARNES TRUPER', 'TRUPER', 'Seguridad', 'TRUPER', '14433', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 625.00, 437.50, 'PZA', '14433', true, NOW());

    -- Barreta de punta
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Barreta de punta', 'TRUPER', 'Herramientas de Demolicion', 'TRUPER', '10759', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 285.00, 199.50, 'PZA', '10759', true, NOW());

    -- Cincel
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Cincel', 'TRUPER', 'Herramientas de Corte', 'TRUPER', '12163', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 157.00, 109.90, 'PZA', '12163', true, NOW());

    -- Cinta de aislar Negro
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Cinta de aislar Negro', 'GENERICO', 'Cintas y Adhesivos', 'GENERICO', '20521', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 45.00, 31.50, 'PZA', '20521', true, NOW());

    -- Cutter con alma metalica
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Cutter con alma metalica', 'TRUPER', 'Herramientas de Corte', 'TRUPER', '16976', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 75.00, 52.50, 'PZA', '16976', true, NOW());

    -- Desarmadores de cruz
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Desarmadores de cruz', 'TRUPER', 'Desarmadores', 'TRUPER', '14062', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 130.00, 91.00, 'PZA', '14062', true, NOW());

    -- Esmeril de banco 6 pulgadas
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Esmeril de banco 6 pulgadas', 'TRUPER', 'Herramientas Electricas', 'TRUPER', '10937', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 2100.00, 1470.00, 'PZA', '10937', true, NOW());

    -- Linterna 20 LED 2 pilas
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Linterna 20 LED 2 pilas', 'TRUPER', 'Iluminacion', 'TRUPER', '10629', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 119.00, 83.30, 'PZA', '10629', true, NOW());

    -- Lentes de seguridad
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Lentes de seguridad', 'TRUPER', 'Seguridad', 'TRUPER', '14252', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 55.00, 38.50, 'PZA', '14252', true, NOW());

    -- Martillos de una
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Martillos de una', 'TRUPER', 'Martillos', 'TRUPER', '16654', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 195.00, 136.50, 'PZA', '16654', true, NOW());

    -- Nivel profesional
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Nivel profesional', 'TRUPER', 'Medicion', 'TRUPER', 'UNT12', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 199.00, 139.30, 'PZA', 'UNT12', true, NOW());

    -- Pala redonda
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Pala redonda', 'TRUPER', 'Herramientas de Jardin', 'TRUPER', '17150', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 279.00, 195.30, 'PZA', '17150', true, NOW());

    -- Zapapicos
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Zapapicos', 'TRUPER', 'Herramientas de Demolicion', 'TRUPER', '18646', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 350.00, 245.00, 'PZA', '18646', true, NOW());

    -- Rodamientos rigidos de bolas
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, created_at)
    VALUES (v_product_id, v_hardware_tenant_id, 'Rodamientos rigidos de bolas', 'GENERICO', 'Rodamientos', 'GENERICO', 'RB9877', NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_hardware_tenant_id, v_product_id, 'Presentacion Unica', 350.00, 245.00, 'PZA', 'RB9877', true, NOW());

    RAISE NOTICE 'Ferreteria El Tornillo poblada con 17 productos de muestra';
    RAISE NOTICE 'Poblacion completada exitosamente!';
    
END $$;
