-- ========================================
-- PASO 3: PRODUCTOS PARA TIENDA DE ROPA
-- Tenant ID: a4200c86-3957-440e-9e35-114acf2a9a55
-- ========================================

-- 3.1 Producto: Camiseta Clásica
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('a4200c86-3957-440e-9e35-114acf2a9a55', 'Camiseta Clásica', 'Camiseta de algodón 100%')
RETURNING id;
-- ⚠️ Copia el UUID retornado y úsalo en el siguiente INSERT

-- 3.2 Variantes de Camiseta (Reemplaza COPIAR_ID_CAMISETA con el UUID de arriba)
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('a4200c86-3957-440e-9e35-114acf2a9a55', 'COPIAR_ID_CAMISETA', 'Talla S - Rojo', 19.99, 10.00, 'Unidad'),
('a4200c86-3957-440e-9e35-114acf2a9a55', 'COPIAR_ID_CAMISETA', 'Talla M - Azul', 21.99, 10.50, 'Unidad'),
('a4200c86-3957-440e-9e35-114acf2a9a55', 'COPIAR_ID_CAMISETA', 'Talla L - Negro', 22.99, 11.00, 'Unidad');

-- 3.3 Producto: Pantalón Casual
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('a4200c86-3957-440e-9e35-114acf2a9a55', 'Pantalón Casual', 'Pantalón de mezclilla')
RETURNING id;
-- ⚠️ Copia el UUID retornado y úsalo en el siguiente INSERT

-- 3.4 Variantes de Pantalón (Reemplaza COPIAR_ID_PANTALON con el UUID de arriba)
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('a4200c86-3957-440e-9e35-114acf2a9a55', 'COPIAR_ID_PANTALON', 'Talla 30', 45.99, 25.00, 'Unidad'),
('a4200c86-3957-440e-9e35-114acf2a9a55', 'COPIAR_ID_PANTALON', 'Talla 32', 45.99, 25.00, 'Unidad'),
('a4200c86-3957-440e-9e35-114acf2a9a55', 'COPIAR_ID_PANTALON', 'Talla 34', 47.99, 26.00, 'Unidad');

-- 3.5 Producto: Zapatos Deportivos
INSERT INTO productos (tenant_id, nombre, descripcion) VALUES
('a4200c86-3957-440e-9e35-114acf2a9a55', 'Zapatos Deportivos', 'Zapatos para correr')
RETURNING id;
-- ⚠️ Copia el UUID retornado y úsalo en el siguiente INSERT

-- 3.6 Variantes de Zapatos (Reemplaza COPIAR_ID_ZAPATOS con el UUID de arriba)
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida) VALUES
('a4200c86-3957-440e-9e35-114acf2a9a55', 'COPIAR_ID_ZAPATOS', 'Talla 8 - Blanco', 89.99, 50.00, 'Par'),
('a4200c86-3957-440e-9e35-114acf2a9a55', 'COPIAR_ID_ZAPATOS', 'Talla 9 - Negro', 89.99, 50.00, 'Par'),
('a4200c86-3957-440e-9e35-114acf2a9a55', 'COPIAR_ID_ZAPATOS', 'Talla 10 - Azul', 94.99, 52.00, 'Par');
