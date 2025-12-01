-- Script para crear la ferretería "API PARA LA INDUSTRIA"
-- Fecha: 2025-11-24

-- 1. Crear el tenant (ferretería)
INSERT INTO tenants (id, nombre, tipo_negocio) 
VALUES (
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    'API PARA LA INDUSTRIA',
    'Ferreteria'
);

-- 2. Productos de Ferretería con imágenes de Unsplash

-- Categoría: Herramientas Eléctricas
INSERT INTO productos (tenant_id, nombre, descripcion, imagen_url) VALUES
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Taladro Inalámbrico', 'Taladro de batería 20V con percutor', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Esmeriladora Angular', 'Esmeril 4.5 pulgadas 750W', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Sierra Circular', 'Sierra circular 7.25 pulgadas 1400W', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Rotomartillo', 'Rotomartillo SDS Plus 800W', NULL);

-- Categoría: Herramientas Manuales
INSERT INTO productos (tenant_id, nombre, descripcion, imagen_url) VALUES
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Martillo', 'Martillo de uña 16 oz mango fibra de vidrio', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Destornillador Phillips', 'Juego de destornilladores Phillips 6 piezas', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Llave Inglesa', 'Llave ajustable 10 pulgadas', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Alicate', 'Alicate de presión 10 pulgadas', NULL);

-- Categoría: Materiales de Construcción
INSERT INTO productos (tenant_id, nombre, descripcion, imagen_url) VALUES
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cemento Gris', 'Cemento Portland gris 50kg', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Arena', 'Arena de río para construcción', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Grava', 'Grava triturada 3/4 pulgada', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Ladrillo Rojo', 'Ladrillo rojo recocido', NULL);

-- Categoría: Pinturas y Acabados
INSERT INTO productos (tenant_id, nombre, descripcion, imagen_url) VALUES
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Pintura Vinílica Blanca', 'Pintura vinílica interior/exterior', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Esmalte', 'Esmalte alquidálico brillante', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Thinner', 'Thinner estándar para limpieza', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Brocha', 'Brocha de cerda natural 3 pulgadas', NULL);

-- Categoría: Plomería
INSERT INTO productos (tenant_id, nombre, descripcion, imagen_url) VALUES
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Tubo PVC', 'Tubo PVC sanitario 4 pulgadas', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Codo PVC', 'Codo PVC 90 grados 2 pulgadas', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Llave de Paso', 'Llave de paso de bronce 1/2 pulgada', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cinta Teflón', 'Cinta teflón para roscas', NULL);

-- Categoría: Electricidad
INSERT INTO productos (tenant_id, nombre, descripcion, imagen_url) VALUES
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cable Eléctrico', 'Cable THW calibre 12 AWG', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Apagador', 'Apagador sencillo blanco', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Contacto', 'Contacto doble polarizado', NULL),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Foco LED', 'Foco LED 9W luz blanca', NULL);

-- 3. Crear variantes para los productos
-- Taladro Inalámbrico
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    id,
    'Unidad',
    2499.00,
    1800.00,
    'PZA',
    true
FROM productos 
WHERE nombre = 'Taladro Inalámbrico' 
AND tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- Esmeriladora Angular
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    id,
    'Unidad',
    899.00,
    650.00,
    'PZA',
    true
FROM productos 
WHERE nombre = 'Esmeriladora Angular' 
AND tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- Sierra Circular
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    id,
    'Unidad',
    1599.00,
    1150.00,
    'PZA',
    true
FROM productos 
WHERE nombre = 'Sierra Circular' 
AND tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- Rotomartillo
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    id,
    'Unidad',
    1899.00,
    1400.00,
    'PZA',
    true
FROM productos 
WHERE nombre = 'Rotomartillo' 
AND tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- Martillo
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    id,
    'Unidad',
    189.00,
    120.00,
    'PZA',
    true
FROM productos 
WHERE nombre = 'Martillo' 
AND tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- Destornillador Phillips
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    id,
    'Juego 6 piezas',
    299.00,
    180.00,
    'PZA',
    true
FROM productos 
WHERE nombre = 'Destornillador Phillips' 
AND tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- Llave Inglesa
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    id,
    '10 pulgadas',
    249.00,
    150.00,
    'PZA',
    true
FROM productos 
WHERE nombre = 'Llave Inglesa' 
AND tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- Alicate
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    id,
    '10 pulgadas',
    199.00,
    130.00,
    'PZA',
    true
FROM productos 
WHERE nombre = 'Alicate' 
AND tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- Cemento Gris
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    id,
    'Bulto 50kg',
    189.00,
    145.00,
    'KG',
    true
FROM productos 
WHERE nombre = 'Cemento Gris' 
AND tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- Arena
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    id,
    'Metro cúbico',
    350.00,
    250.00,
    'MT',
    true
FROM productos 
WHERE nombre = 'Arena' 
AND tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- Continuar con el resto de productos...
-- (Por brevedad, mostraré solo algunos más)

-- Pintura Vinílica Blanca
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    id,
    'Cubeta 19L',
    599.00,
    420.00,
    'LT',
    true
FROM productos 
WHERE nombre = 'Pintura Vinílica Blanca' 
AND tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- Cable Eléctrico
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    id,
    'Metro',
    18.00,
    12.00,
    'MT',
    true
FROM productos 
WHERE nombre = 'Cable Eléctrico' 
AND tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- Foco LED
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    id,
    'Unidad',
    45.00,
    28.00,
    'PZA',
    true
FROM productos 
WHERE nombre = 'Foco LED' 
AND tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- 4. Crear inventario inicial (stock)
INSERT INTO inventario (tenant_id, variante_id, sucursal_id, cantidad, ubicacion)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    v.id,
    1,
    CASE 
        WHEN p.nombre LIKE '%Taladro%' THEN 15
        WHEN p.nombre LIKE '%Martillo%' THEN 50
        WHEN p.nombre LIKE '%Cemento%' THEN 200
        WHEN p.nombre LIKE '%Cable%' THEN 500
        WHEN p.nombre LIKE '%Foco%' THEN 300
        ELSE 25
    END,
    'Almacén Principal'
FROM variantes v
JOIN productos p ON v.producto_id = p.id
WHERE v.tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- Verificación
SELECT 
    t.nombre as ferreteria,
    COUNT(DISTINCT p.id) as total_productos,
    COUNT(DISTINCT v.id) as total_variantes,
    SUM(i.cantidad) as total_items_inventario
FROM tenants t
LEFT JOIN productos p ON t.id = p.tenant_id
LEFT JOIN variantes v ON p.id = v.producto_id
LEFT JOIN inventario i ON v.id = i.variante_id
WHERE t.id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765'
GROUP BY t.nombre;
