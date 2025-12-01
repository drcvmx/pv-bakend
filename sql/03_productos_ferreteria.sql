-- ========================================
-- PASO 4: PRODUCTOS PARA FERRETERÍA
-- Tenant ID: 2853318c-e931-4718-b955-4508168e6953
-- ========================================

-- 4.1 Producto: Tornillo de Cobre
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('2853318c-e931-4718-b955-4508168e6953', 'Tornillo de Cobre', 'Tornillo resistente a la humedad')
RETURNING id;
-- ⚠️ Copia el UUID retornado y úsalo en el siguiente INSERT

-- 4.2 Variantes de Tornillo (Reemplaza COPIAR_ID_TORNILLO con el UUID de arriba)
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('2853318c-e931-4718-b955-4508168e6953', 'COPIAR_ID_TORNILLO', 'Por Unidad', 0.15, 0.05, 'Unidad'),
('2853318c-e931-4718-b955-4508168e6953', 'COPIAR_ID_TORNILLO', 'Por Kilogramo', 25.00, 12.00, 'Kilogramo'),
('2853318c-e931-4718-b955-4508168e6953', 'COPIAR_ID_TORNILLO', 'Caja de 100 unidades', 12.00, 5.00, 'Caja');

-- 4.3 Producto: Pintura Blanca
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('2853318c-e931-4718-b955-4508168e6953', 'Pintura Blanca', 'Pintura látex para interiores')
RETURNING id;
-- ⚠️ Copia el UUID retornado y úsalo en el siguiente INSERT

-- 4.4 Variantes de Pintura (Reemplaza COPIAR_ID_PINTURA con el UUID de arriba)
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('2853318c-e931-4718-b955-4508168e6953', 'COPIAR_ID_PINTURA', 'Bote de 1 Galón', 35.00, 18.00, 'Galón'),
('2853318c-e931-4718-b955-4508168e6953', 'COPIAR_ID_PINTURA', 'Cubeta de 5 Galones', 150.00, 80.00, 'Cubeta');

-- 4.5 Producto: Martillo
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('2853318c-e931-4718-b955-4508168e6953', 'Martillo de Carpintero', 'Martillo profesional con mango de madera')
RETURNING id;
-- ⚠️ Copia el UUID retornado y úsalo en el siguiente INSERT

-- 4.6 Variantes de Martillo (Reemplaza COPIAR_ID_MARTILLO con el UUID de arriba)
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('2853318c-e931-4718-b955-4508168e6953', 'COPIAR_ID_MARTILLO', '16 oz', 18.50, 9.00, 'Unidad'),
('2853318c-e931-4718-b955-4508168e6953', 'COPIAR_ID_MARTILLO', '20 oz', 22.50, 11.00, 'Unidad');
