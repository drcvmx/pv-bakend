-- ========================================
-- PASO 5: PRODUCTOS PARA RESTAURANTE
-- Tenant ID: 83cfebd6-0668-43d1-a26f-46f32fdd8944
-- ========================================

-- 5.1 Producto: Hamburguesa Clásica
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 'Hamburguesa Clásica', 'Hamburguesa con pan artesanal')
RETURNING id;
-- ⚠️ Copia el UUID retornado y úsalo en el siguiente INSERT

-- 5.2 Variantes de Hamburguesa (Reemplaza COPIAR_ID_HAMBURGUESA con el UUID de arriba)
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 'COPIAR_ID_HAMBURGUESA', 'Sencilla', 10.00, 3.50, 'Plato'),
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 'COPIAR_ID_HAMBURGUESA', 'Con Queso', 12.50, 4.00, 'Plato'),
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 'COPIAR_ID_HAMBURGUESA', 'Doble Carne', 15.00, 5.50, 'Plato');

-- 5.3 Producto: Pizza Margarita
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 'Pizza Margarita', 'Pizza italiana tradicional')
RETURNING id;
-- ⚠️ Copia el UUID retornado y úsalo en el siguiente INSERT

-- 5.4 Variantes de Pizza (Reemplaza COPIAR_ID_PIZZA con el UUID de arriba)
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 'COPIAR_ID_PIZZA', 'Personal (8 pulgadas)', 8.50, 3.00, 'Plato'),
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 'COPIAR_ID_PIZZA', 'Mediana (12 pulgadas)', 14.00, 5.00, 'Plato'),
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 'COPIAR_ID_PIZZA', 'Grande (16 pulgadas)', 18.00, 7.00, 'Plato');

-- 5.5 Producto: Refresco
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 'Refresco', 'Bebidas gaseosas')
RETURNING id;
-- ⚠️ Copia el UUID retornado y úsalo en el siguiente INSERT

-- 5.6 Variantes de Refresco (Reemplaza COPIAR_ID_REFRESCO con el UUID de arriba)
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 'COPIAR_ID_REFRESCO', 'Coca-Cola 355ml', 2.00, 0.80, 'Unidad'),
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 'COPIAR_ID_REFRESCO', 'Sprite 355ml', 2.00, 0.80, 'Unidad'),
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 'COPIAR_ID_REFRESCO', 'Agua Mineral 500ml', 1.50, 0.50, 'Unidad');

-- 5.7 Producto: Ingrediente Harina (Inventario)
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 'Harina para Cocina', 'Harina de trigo para preparación')
RETURNING id;
-- ⚠️ Copia el UUID retornado y úsalo en el siguiente INSERT

-- 5.8 Variante de Harina (Reemplaza COPIAR_ID_HARINA con el UUID de arriba)
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock) VALUES
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 'COPIAR_ID_HARINA', 'Inventario a Granel', 0.00, 0.50, 'Kilogramo', TRUE);
