
DO $$
DECLARE
    v_tenant_id uuid := 'a1b2c3d4-e5f6-7890-1234-567890abcdef'; -- Tienda Don Jose
    v_product_id uuid;
BEGIN
    -- Limpiar productos existentes con estos códigos para evitar duplicados en este script
    DELETE FROM productos WHERE tenant_id = v_tenant_id AND codigo_barras IN (
        '7501000264049', '7500810024546', '7503028643745', '7501000264773', '7501030424536',
        '7501000164370', '7501000148288', '7501000164804', '7501000164880', '7501000164828',
        '7501000192531', '7501000167690', '7501000192463', '7501000167676', '7500478015047',
        '7500478014606', '7501011143753', '7501011127012', '7501011194465', '7501055301824',
        '7501055300605', '7501055301305', '7501441610115', '7501441610122', '7501441610214',
        '7501441620114', '7501441620121', '7501441620213', '7501000625062', '7500478035939',
        '7501000632349', '7501000645062', '750176184798', '750176186329', '750176181039',
        '7501000103735', '7501000105319'
    );

    -- Papas Fritas Sal de Mar
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Papas Fritas Sal de Mar', 'Chips (Barcel)', 'Botanas', 'Barcel', '7501000264049', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000264049' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 18.00, 12.60, 'PZA', '7501000264049', true, NOW());

    -- Papas Fritas Fuego
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Papas Fritas Fuego', 'Chips (Barcel)', 'Botanas', 'Barcel', '7500810024546', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7500810024546' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 19.50, 13.65, 'PZA', '7500810024546', true, NOW());

    -- Papas Fritas Adobadas
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Papas Fritas Adobadas', 'Chips (Barcel)', 'Botanas', 'Barcel', '7503028643745', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7503028643745' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 18.00, 12.60, 'PZA', '7503028643745', true, NOW());

    -- Papas Fritas Jalapeño
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Papas Fritas Jalapeño', 'Chips (Barcel)', 'Botanas', 'Barcel', '7501000264773', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000264773' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 19.50, 13.65, 'PZA', '7501000264773', true, NOW());

    -- Takis Fuego
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Takis Fuego', 'Takis (Barcel)', 'Botanas', 'Barcel', '7501030424536', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501030424536' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 21.00, 14.70, 'PZA', '7501030424536', true, NOW());

    -- Takis Original
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Takis Original', 'Takis (Barcel)', 'Botanas', 'Barcel', '7501000164370', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000164370' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 20.00, 14.00, 'PZA', '7501000164370', true, NOW());

    -- Takis Huakamoles
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Takis Huakamoles', 'Takis (Barcel)', 'Botanas', 'Barcel', '7501000148288', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000148288' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 22.00, 15.40, 'PZA', '7501000148288', true, NOW());

    -- Cacahuates Salados
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Cacahuates Salados', 'Golden Nuts', 'Botanas', 'Golden Nuts', '7501000164804', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000164804' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 17.00, 11.90, 'PZA', '7501000164804', true, NOW());

    -- Cacahuates Japonés
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Cacahuates Japonés', 'Golden Nuts', 'Botanas', 'Golden Nuts', '7501000164880', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000164880' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 25.00, 17.50, 'PZA', '7501000164880', true, NOW());

    -- Pepitas Saladas
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Pepitas Saladas', 'Golden Nuts', 'Botanas', 'Golden Nuts', '7501000164828', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000164828' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 14.00, 9.80, 'PZA', '7501000164828', true, NOW());

    -- Botana Surtida Queso
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Botana Surtida Queso', 'Big Mix (Barcel)', 'Botanas', 'Barcel', '7501000192531', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000192531' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 24.00, 16.80, 'PZA', '7501000192531', true, NOW());

    -- Botana Surtida Clásico
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Botana Surtida Clásico', 'Big Mix (Barcel)', 'Botanas', 'Barcel', '7501000167690', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000167690' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 24.00, 16.80, 'PZA', '7501000167690', true, NOW());

    -- Botana Surtida Fuego
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Botana Surtida Fuego', 'Big Mix (Barcel)', 'Botanas', 'Barcel', '7501000192463', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000192463' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 25.50, 17.85, 'PZA', '7501000192463', true, NOW());

    -- Botana Surtida Party
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Botana Surtida Party', 'Big Mix (Barcel)', 'Botanas', 'Barcel', '7501000167676', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000167676' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 29.00, 20.30, 'PZA', '7501000167676', true, NOW());

    -- Bolitas
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Bolitas', 'Cheetos', 'Botanas', 'Cheetos', '7500478015047', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7500478015047' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 18.00, 12.60, 'PZA', '7500478015047', true, NOW());

    -- Poffs
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Poffs', 'Cheetos', 'Botanas', 'Cheetos', '7500478014606', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7500478014606' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 17.00, 11.90, 'PZA', '7500478014606', true, NOW());

    -- Flamin' Hot
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Flamin'' Hot', 'Cheetos', 'Botanas', 'Cheetos', '7501011143753', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501011143753' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 20.00, 14.00, 'PZA', '7501011143753', true, NOW());

    -- Salsa Verde
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Salsa Verde', 'Tostitos', 'Botanas', 'Tostitos', '7501011127012', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501011127012' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 21.00, 14.70, 'PZA', '7501011127012', true, NOW());

    -- Dip Queso Jalapeño
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Dip Queso Jalapeño', 'Tostitos', 'Salsas', 'Tostitos', '7501011194465', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501011194465' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 38.00, 26.60, 'PZA', '7501011194465', true, NOW());

    -- Refresco Coca-Cola Original (3 L)
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Refresco Coca-Cola Original (3 L)', 'Coca-Cola', 'Bebidas', 'Coca-Cola', '7501055301824', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501055301824' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 45.00, 31.50, 'PZA', '7501055301824', true, NOW());

    -- Refresco Coca-Cola Original (2 L)
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Refresco Coca-Cola Original (2 L)', 'Coca-Cola', 'Bebidas', 'Coca-Cola', '7501055300605', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501055300605' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 35.00, 24.50, 'PZA', '7501055300605', true, NOW());

    -- Refresco Coca-Cola Original (600 ml)
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Refresco Coca-Cola Original (600 ml)', 'Coca-Cola', 'Bebidas', 'Coca-Cola', '7501055301305', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501055301305' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 18.00, 12.60, 'PZA', '7501055301305', true, NOW());

    -- Refresco Jarritos Mandarina (600 ml)
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Refresco Jarritos Mandarina (600 ml)', 'Jarritos', 'Bebidas', 'Jarritos', '7501441610115', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501441610115' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 16.00, 11.20, 'PZA', '7501441610115', true, NOW());

    -- Refresco Jarritos Piña (600 ml)
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Refresco Jarritos Piña (600 ml)', 'Jarritos', 'Bebidas', 'Jarritos', '7501441610122', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501441610122' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 16.00, 11.20, 'PZA', '7501441610122', true, NOW());

    -- Refresco Jarritos Limón (600 ml)
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Refresco Jarritos Limón (600 ml)', 'Jarritos', 'Bebidas', 'Jarritos', '7501441610214', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501441610214' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 16.00, 11.20, 'PZA', '7501441610214', true, NOW());

    -- Refresco Jarritos Mandarina (2 L)
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Refresco Jarritos Mandarina (2 L)', 'Jarritos', 'Bebidas', 'Jarritos', '7501441620114', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501441620114' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 30.00, 21.00, 'PZA', '7501441620114', true, NOW());

    -- Refresco Jarritos Piña (2 L)
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Refresco Jarritos Piña (2 L)', 'Jarritos', 'Bebidas', 'Jarritos', '7501441620121', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501441620121' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 30.00, 21.00, 'PZA', '7501441620121', true, NOW());

    -- Refresco Jarritos Limón (2 L)
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Refresco Jarritos Limón (2 L)', 'Jarritos', 'Bebidas', 'Jarritos', '7501441620213', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501441620213' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 30.00, 21.00, 'PZA', '7501441620213', true, NOW());

    -- Galletas Clásicas (850 g)
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Galletas Clásicas (850 g)', 'Marías Gamesa', 'Galletas', 'Gamesa', '7501000625062', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000625062' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 55.00, 38.50, 'PZA', '7501000625062', true, NOW());

    -- Galletas Azucaradas (450 g)
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Galletas Azucaradas (450 g)', 'Marías Gamesa', 'Galletas', 'Gamesa', '7500478035939', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7500478035939' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 42.00, 29.40, 'PZA', '7500478035939', true, NOW());

    -- Emperador® Vainilla (134 g)
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Emperador® Vainilla (134 g)', 'Gamesa', 'Galletas', 'Gamesa', '7501000632349', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000632349' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 18.00, 12.60, 'PZA', '7501000632349', true, NOW());

    -- Emperador® Limón (134 g)
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Emperador® Limón (134 g)', 'Gamesa', 'Galletas', 'Gamesa', '7501000645062', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000645062' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 18.00, 12.60, 'PZA', '7501000645062', true, NOW());

    -- Barra Quaker® Stila® Manzana/Canela
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Barra Quaker® Stila® Manzana/Canela', 'Quaker®', 'Barras', 'Quaker', '750176184798', (SELECT imagen_url FROM global_products WHERE codigo_barras = '750176184798' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 15.00, 10.50, 'PZA', '750176184798', true, NOW());

    -- Barra Quaker® Stila® Fresa
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Barra Quaker® Stila® Fresa', 'Quaker®', 'Barras', 'Quaker', '750176186329', (SELECT imagen_url FROM global_products WHERE codigo_barras = '750176186329' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 15.00, 10.50, 'PZA', '750176186329', true, NOW());

    -- Avena Quaker® 3 Minutos® bote
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Avena Quaker® 3 Minutos® bote', 'Quaker®', 'Cereales', 'Quaker', '750176181039', (SELECT imagen_url FROM global_products WHERE codigo_barras = '750176181039' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 58.00, 40.60, 'PZA', '750176181039', true, NOW());

    -- Tortillinas® Clásicas (500 g)
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Tortillinas® Clásicas (500 g)', 'Tía Rosa', 'Panadería', 'Tía Rosa', '7501000103735', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000103735' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 45.00, 31.50, 'PZA', '7501000103735', true, NOW());

    -- Tiras Doraditas® (120 g)
    v_product_id := gen_random_uuid();
    INSERT INTO productos (id, tenant_id, nombre, marca, categoria, proveedor, codigo_barras, imagen_url, created_at)
    VALUES (v_product_id, v_tenant_id, 'Tiras Doraditas® (120 g)', 'Tía Rosa', 'Panadería', 'Tía Rosa', '7501000105319', (SELECT imagen_url FROM global_products WHERE codigo_barras = '7501000105319' LIMIT 1), NOW());
    INSERT INTO variantes (id, tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, codigo_barras, track_stock, created_at)
    VALUES (gen_random_uuid(), v_tenant_id, v_product_id, 'Presentación Única', 22.00, 15.40, 'PZA', '7501000105319', true, NOW());

END $$;
