-- =====================================================
-- SCRIPT PARA CREAR TABLA order_items
-- Fecha: 2025-11-29
-- =====================================================

-- 1. Crear la tabla order_items
CREATE TABLE IF NOT EXISTS order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    variant_id BIGINT, -- Cambiado a BIGINT para coincidir con variantes.id
    product_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_order_items_variant FOREIGN KEY (variant_id) REFERENCES variantes(id) ON DELETE SET NULL
);

-- 2. Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_variant ON order_items(variant_id);

-- 3. Comentarios
COMMENT ON TABLE order_items IS 'Detalle de productos vendidos en cada orden.';
COMMENT ON COLUMN order_items.price IS 'Precio unitario del producto al momento de la venta.';
COMMENT ON COLUMN order_items.subtotal IS 'Precio * Cantidad.';
