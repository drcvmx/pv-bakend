-- =====================================================
-- POBLAR NUEVOS TENANTS CON PRECIOS DE MERCADO VERIFICADOS
-- =====================================================
-- Fecha: 2025-11-29
-- Tenants: Miselania Maria (Abarrotes), API PARA LA INDUSTRIA (Ferretería)
-- Stock: 50 unidades parejo
-- Precios: Basados en investigación de mercado (3 coincidencias por producto clave)
-- =====================================================

DO $$
DECLARE
    v_tenant_maria UUID := 'b2c3d4e5-f678-9012-3456-7890abcdef12';
    v_tenant_api UUID := 'f8e9d7c6-5b4a-3210-9876-fedcba098765';
    v_global_product RECORD;
    v_producto_id BIGINT;
    v_variante_id BIGINT;
    v_count_maria INT := 0;
    v_count_api INT := 0;
BEGIN
    RAISE NOTICE '=== INICIANDO POBLACIÓN DE MISELANIA MARIA (ABARROTES) ===';

    -- ==========================================
    -- 1. MISELANIA MARIA (ABARROTES)
    -- ==========================================

    FOR v_global_product IN 
        SELECT * FROM global_products 
        WHERE categoria IN ('Botanas', 'Bebidas', 'Galletas', 'Cereales')
    LOOP
        -- Insertar Producto
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_maria, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;

        -- Determinar Precio de Mercado (Verificado en Google)
        DECLARE
            v_precio DECIMAL(10,2);
        BEGIN
            -- PRECIOS ESPECÍFICOS VERIFICADOS
            IF v_global_product.codigo_barras = '7501055301824' THEN v_precio := 51.00; -- Coca-Cola 3L (Promedio Aurrera/Aki/Carnemart)
            ELSIF v_global_product.codigo_barras = '7501000625062' THEN v_precio := 75.00; -- Marías Gamesa 850g (Promedio mercado)
            
            -- LÓGICA GENERAL AJUSTADA
            ELSIF v_global_product.categoria = 'Bebidas' THEN
                IF v_global_product.nombre ILIKE '%3L%' THEN v_precio := 51.00;
                ELSIF v_global_product.nombre ILIKE '%2L%' THEN v_precio := 35.00;
                ELSIF v_global_product.nombre ILIKE '%600ml%' THEN v_precio := 20.00;
                ELSE v_precio := 28.00; END IF;
            ELSIF v_global_product.categoria = 'Botanas' THEN
                IF v_global_product.nombre ILIKE '%Dip%' THEN v_precio := 45.00;
                ELSIF v_global_product.nombre ILIKE '%Surtida%' THEN v_precio := 30.00;
                ELSIF v_global_product.nombre ILIKE '%Cacahuates%' OR v_global_product.nombre ILIKE '%Pepitas%' THEN v_precio := 18.00;
                ELSE v_precio := 22.00; END IF;
            ELSIF v_global_product.categoria = 'Galletas' THEN
                IF v_global_product.nombre ILIKE '%850g%' THEN v_precio := 75.00; -- Ajustado por investigación
                ELSIF v_global_product.nombre ILIKE '%450g%' THEN v_precio := 45.00;
                ELSE v_precio := 22.00; END IF;
            ELSIF v_global_product.categoria = 'Cereales' THEN
                IF v_global_product.nombre ILIKE '%Avena%' THEN v_precio := 32.00;
                ELSE v_precio := 15.00; END IF;
            ELSE
                v_precio := 25.00;
            END IF;

            -- Insertar Variante
            INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
            VALUES (v_tenant_maria, v_producto_id, 'Estándar', v_precio, 'pza', v_global_product.codigo_barras)
            RETURNING id INTO v_variante_id;

            -- Insertar Inventario (50 unidades)
            INSERT INTO inventario (tenant_id, variante_id, sucursal_id, cantidad, ubicacion)
            VALUES (v_tenant_maria, v_variante_id, 1, 50.00, 'Piso de Venta');
            
            v_count_maria := v_count_maria + 1;
        END;
    END LOOP;

    RAISE NOTICE 'Productos agregados a Miselania Maria: %', v_count_maria;

    RAISE NOTICE '=== INICIANDO POBLACIÓN DE API PARA LA INDUSTRIA (FERRETERÍA) ===';

    -- ==========================================
    -- 2. API PARA LA INDUSTRIA (FERRETERÍA)
    -- ==========================================

    FOR v_global_product IN 
        SELECT * FROM global_products 
        WHERE categoria NOT IN ('Botanas', 'Bebidas', 'Galletas', 'Cereales')
    LOOP
        -- Insertar Producto
        INSERT INTO productos (tenant_id, global_product_id, nombre, descripcion, marca, categoria, codigo_barras, imagen_url)
        VALUES (v_tenant_api, v_global_product.id, v_global_product.nombre, v_global_product.descripcion, 
                v_global_product.marca, v_global_product.categoria, v_global_product.codigo_barras, v_global_product.imagen_url)
        RETURNING id INTO v_producto_id;

        -- Determinar Precio de Mercado (Verificado en Google)
        DECLARE
            v_precio DECIMAL(10,2);
        BEGIN
            -- PRECIOS ESPECÍFICOS VERIFICADOS
            IF v_global_product.codigo_barras = '10937' THEN v_precio := 1750.00; -- Esmeril Banco 6" (Promedio Ferrebaratillo/Ferreayotla)
            ELSIF v_global_product.codigo_barras = '14433' THEN v_precio := 670.00; -- Arnés Truper (Promedio Calzada/Alcorsa)
            ELSIF v_global_product.codigo_barras = '17150' THEN v_precio := 259.00; -- Pala Redonda (Precio exacto mercado)
            
            -- LÓGICA GENERAL AJUSTADA
            ELSIF v_global_product.categoria = 'Herramientas Eléctricas' THEN v_precio := 1750.00;
            ELSIF v_global_product.categoria = 'Seguridad' THEN 
                IF v_global_product.nombre ILIKE '%Arnés%' THEN v_precio := 670.00;
                ELSE v_precio := 75.00; END IF;
            ELSIF v_global_product.categoria = 'Medición' THEN 
                IF v_global_product.nombre ILIKE '%Nivel%' THEN v_precio := 200.00;
                ELSIF v_global_product.nombre ILIKE '%Cinta%' THEN v_precio := 140.00;
                ELSE v_precio := 280.00; END IF;
            ELSIF v_global_product.categoria = 'Herramientas de Jardín' THEN v_precio := 260.00; -- Ajustado por Pala
            ELSIF v_global_product.categoria = 'Martillos y Marros' THEN v_precio := 160.00;
            ELSIF v_global_product.categoria = 'Llaves' THEN v_precio := 95.00;
            ELSIF v_global_product.categoria = 'Desarmadores' THEN 
                IF v_global_product.nombre ILIKE '%Juego%' THEN v_precio := 230.00;
                ELSE v_precio := 55.00; END IF;
            ELSIF v_global_product.categoria = 'Cintas y Adhesivos' THEN 
                IF v_global_product.nombre ILIKE '%Ducto%' THEN v_precio := 95.00;
                ELSE v_precio := 40.00; END IF;
            ELSIF v_global_product.categoria = 'Rodamientos' THEN v_precio := 140.00;
            ELSIF v_global_product.categoria = 'Roscado' THEN v_precio := 480.00;
            ELSIF v_global_product.categoria = 'Iluminación' THEN v_precio := 125.00;
            ELSE v_precio := 70.00;
            END IF;

            -- Insertar Variante
            INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, unidad_medida, codigo_barras)
            VALUES (v_tenant_api, v_producto_id, 'Estándar', v_precio, 'pza', v_global_product.codigo_barras)
            RETURNING id INTO v_variante_id;

            -- Insertar Inventario (50 unidades)
            INSERT INTO inventario (tenant_id, variante_id, sucursal_id, cantidad, ubicacion)
            VALUES (v_tenant_api, v_variante_id, 1, 50.00, 'Almacén Principal');
            
            v_count_api := v_count_api + 1;
        END;
    END LOOP;

    RAISE NOTICE 'Productos agregados a API PARA LA INDUSTRIA: %', v_count_api;
    RAISE NOTICE '=== PROCESO COMPLETADO EXITOSAMENTE ===';
END $$;
