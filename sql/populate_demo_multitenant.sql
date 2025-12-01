-- ========================================
-- DEMO MULTI-TENANT - POBLACIÓN DE BASE DE DATOS
-- ========================================

-- ========================================
-- PASO 1: INSERTAR LOS 3 TENANTS
-- ========================================

INSERT INTO tenants (nombre, tipo_negocio) VALUES
('Tienda de Ropa Demo', 'Tienda'),
('Ferretería El Tornillo', 'Ferreteria'),
('Restaurante El Sazón', 'Restaurante');

-- ========================================
-- PASO 2: OBTENER LOS UUIDs GENERADOS
-- ========================================

SELECT id, nombre, tipo_negocio FROM tenants ORDER BY created_at DESC LIMIT 3;

-- ⚠️ IMPORTANTE: Copia los 3 UUIDs de arriba y guárdalos:
-- ID_TIENDA = [copiar aquí el UUID de 'Tienda de Ropa Demo']
-- ID_FERRETERIA = [copiar aquí el UUID de 'Ferretería El Tornillo']
-- ID_RESTAURANTE = [copiar aquí el UUID de 'Restaurante El Sazón']


-- ========================================
-- PASO 3: INSERTAR PRODUCTOS - TIENDA DE ROPA
-- ========================================

-- 3.1 Producto: Camiseta Clásica
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('ID_TIENDA', 'Camiseta Clásica', 'Camiseta de algodón 100%')
RETURNING id;
-- ⚠️ Guardar el ID retornado como: ID_CAMISETA

-- 3.2 Variantes de Camiseta
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('ID_TIENDA', 'ID_CAMISETA', 'Talla S - Rojo', 19.99, 10.00, 'Unidad'),
('ID_TIENDA', 'ID_CAMISETA', 'Talla M - Azul', 21.99, 10.50, 'Unidad'),
('ID_TIENDA', 'ID_CAMISETA', 'Talla L - Negro', 22.99, 11.00, 'Unidad');

-- 3.3 Producto: Pantalón Casual
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('ID_TIENDA', 'Pantalón Casual', 'Pantalón de mezclilla')
RETURNING id;
-- ⚠️ Guardar el ID retornado como: ID_PANTALON

-- 3.4 Variantes de Pantalón
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('ID_TIENDA', 'ID_PANTALON', 'Talla 30', 45.99, 25.00, 'Unidad'),
('ID_TIENDA', 'ID_PANTALON', 'Talla 32', 45.99, 25.00, 'Unidad'),
('ID_TIENDA', 'ID_PANTALON', 'Talla 34', 47.99, 26.00, 'Unidad');

-- 3.5 Producto: Zapatos Deportivos
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('ID_TIENDA', 'Zapatos Deportivos', 'Zapatos para correr')
RETURNING id;
-- ⚠️ Guardar el ID retornado como: ID_ZAPATOS

-- 3.6 Variantes de Zapatos
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('ID_TIENDA', 'ID_ZAPATOS', 'Talla 8 - Blanco', 89.99, 50.00, 'Par'),
('ID_TIENDA', 'ID_ZAPATOS', 'Talla 9 - Negro', 89.99, 50.00, 'Par'),
('ID_TIENDA', 'ID_ZAPATOS', 'Talla 10 - Azul', 94.99, 52.00, 'Par');


-- ========================================
-- PASO 4: INSERTAR PRODUCTOS - FERRETERÍA
-- ========================================

-- 4.1 Producto: Tornillo de Cobre
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('ID_FERRETERIA', 'Tornillo de Cobre', 'Tornillo resistente a la humedad')
RETURNING id;
-- ⚠️ Guardar el ID retornado como: ID_TORNILLO

-- 4.2 Variantes de Tornillo
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('ID_FERRETERIA', 'ID_TORNILLO', 'Por Unidad', 0.15, 0.05, 'Unidad'),
('ID_FERRETERIA', 'ID_TORNILLO', 'Por Kilogramo', 25.00, 12.00, 'Kilogramo'),
('ID_FERRETERIA', 'ID_TORNILLO', 'Caja de 100 unidades', 12.00, 5.00, 'Caja');

-- 4.3 Producto: Pintura Blanca
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('ID_FERRETERIA', 'Pintura Blanca', 'Pintura látex para interiores')
RETURNING id;
-- ⚠️ Guardar el ID retornado como: ID_PINTURA

-- 4.4 Variantes de Pintura
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('ID_FERRETERIA', 'ID_PINTURA', 'Bote de 1 Galón', 35.00, 18.00, 'Galón'),
('ID_FERRETERIA', 'ID_PINTURA', 'Cubeta de 5 Galones', 150.00, 80.00, 'Cubeta');

-- 4.5 Producto: Martillo
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('ID_FERRETERIA', 'Martillo de Carpintero', 'Martillo profesional con mango de madera')
RETURNING id;
-- ⚠️ Guardar el ID retornado como: ID_MARTILLO

-- 4.6 Variantes de Martillo
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('ID_FERRETERIA', 'ID_MARTILLO', '16 oz', 18.50, 9.00, 'Unidad'),
('ID_FERRETERIA', 'ID_MARTILLO', '20 oz', 22.50, 11.00, 'Unidad');


-- ========================================
-- PASO 5: INSERTAR PRODUCTOS - RESTAURANTE
-- ========================================

-- 5.1 Producto: Hamburguesa Clásica
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('ID_RESTAURANTE', 'Hamburguesa Clásica', 'Hamburguesa con pan artesanal')
RETURNING id;
-- ⚠️ Guardar el ID retornado como: ID_HAMBURGUESA

-- 5.2 Variantes de Hamburguesa
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('ID_RESTAURANTE', 'ID_HAMBURGUESA', 'Sencilla', 10.00, 3.50, 'Plato'),
('ID_RESTAURANTE', 'ID_HAMBURGUESA', 'Con Queso', 12.50, 4.00, 'Plato'),
('ID_RESTAURANTE', 'ID_HAMBURGUESA', 'Doble Carne', 15.00, 5.50, 'Plato');

-- 5.3 Producto: Pizza Margarita
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('ID_RESTAURANTE', 'Pizza Margarita', 'Pizza italiana tradicional')
RETURNING id;
-- ⚠️ Guardar el ID retornado como: ID_PIZZA

-- 5.4 Variantes de Pizza
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('ID_RESTAURANTE', 'ID_PIZZA', 'Personal (8 pulgadas)', 8.50, 3.00, 'Plato'),
('ID_RESTAURANTE', 'ID_PIZZA', 'Mediana (12 pulgadas)', 14.00, 5.00, 'Plato'),
('ID_RESTAURANTE', 'ID_PIZZA', 'Grande (16 pulgadas)', 18.00, 7.00, 'Plato');

-- 5.5 Producto: Refresco
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('ID_RESTAURANTE', 'Refresco', 'Bebidas gaseosas')
RETURNING id;
-- ⚠️ Guardar el ID retornado como: ID_REFRESCO

-- 5.6 Variantes de Refresco
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('ID_RESTAURANTE', 'ID_REFRESCO', 'Coca-Cola 355ml', 2.00, 0.80, 'Unidad'),
('ID_RESTAURANTE', 'ID_REFRESCO', 'Sprite 355ml', 2.00, 0.80, 'Unidad'),
('ID_RESTAURANTE', 'ID_REFRESCO', 'Agua Mineral 500ml', 1.50, 0.50, 'Unidad');

-- 5.7 Producto: Ingrediente Harina (Inventario)
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('ID_RESTAURANTE', 'Harina para Cocina', 'Harina de trigo para preparación')
RETURNING id;
-- ⚠️ Guardar el ID retornado como: ID_HARINA

-- 5.8 Variante de Harina (inventario a granel, track_stock activado)
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock) VALUES
('ID_RESTAURANTE', 'ID_HARINA', 'Inventario a Granel', 0.00, 0.50, 'Kilogramo', TRUE);


-- ========================================
-- PASO 6: CONSULTAS DE VERIFICACIÓN
-- ========================================

-- 6.1 Verificar Tienda de Ropa
SELECT
    t.nombre AS Negocio,
    p.nombre AS Producto_Base,
    v.nombre_variante AS Variante,
    v.precio,
    v.unidad_medida
FROM tenants t
JOIN productos p ON t.id = p.tenant_id
JOIN variantes v ON p.id = v.producto_id
WHERE t.tipo_negocio = 'Tienda'
ORDER BY p.nombre, v.nombre_variante;

-- 6.2 Verificar Ferretería
SELECT
    t.nombre AS Negocio,
    p.nombre AS Producto_Base,
    v.nombre_variante AS Variante,
    v.precio,
    v.unidad_medida
FROM tenants t
JOIN productos p ON t.id = p.tenant_id
JOIN variantes v ON p.id = v.producto_id
WHERE t.tipo_negocio = 'Ferreteria'
ORDER BY p.nombre, v.nombre_variante;

-- 6.3 Verificar Restaurante
SELECT
    t.nombre AS Negocio,
    p.nombre AS Producto_Base,
    v.nombre_variante AS Variante,
    v.precio,
    v.unidad_medida
FROM tenants t
JOIN productos p ON t.id = p.tenant_id
JOIN variantes v ON p.id = v.producto_id
WHERE t.tipo_negocio = 'Restaurante'
ORDER BY p.nombre, v.nombre_variante;

-- 6.4 Contar productos por tenant
SELECT
    t.nombre AS Negocio,
    COUNT(DISTINCT p.id) AS Total_Productos,
    COUNT(v.id) AS Total_Variantes
FROM tenants t
LEFT JOIN productos p ON t.id = p.tenant_id
LEFT JOIN variantes v ON p.id = v.producto_id
GROUP BY t.id, t.nombre
ORDER BY t.nombre;
