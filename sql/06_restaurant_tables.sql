-- ========================================
-- TABLA: restaurant_tables
-- Configuración de mesas para restaurantes multi-tenant
-- ========================================

-- Crear la tabla
CREATE TABLE IF NOT EXISTS public.restaurant_tables (
    id UUID DEFAULT uuid_generate_v4() NOT NULL,
    tenant_id UUID NOT NULL,
    table_number INTEGER NOT NULL,
    seats INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'available',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    
    CONSTRAINT restaurant_tables_pkey PRIMARY KEY (id),
    CONSTRAINT restaurant_tables_tenant_id_fkey FOREIGN KEY (tenant_id) 
        REFERENCES public.tenants(id) ON DELETE CASCADE,
    CONSTRAINT restaurant_tables_unique_number UNIQUE (tenant_id, table_number),
    CONSTRAINT restaurant_tables_seats_check CHECK (seats > 0 AND seats <= 20),
    CONSTRAINT restaurant_tables_status_check CHECK (status IN ('available', 'occupied', 'reserved'))
);

-- Crear índice para búsquedas por tenant
CREATE INDEX IF NOT EXISTS idx_restaurant_tables_tenant 
    ON public.restaurant_tables(tenant_id);

-- Crear índice para búsquedas por estado
CREATE INDEX IF NOT EXISTS idx_restaurant_tables_status 
    ON public.restaurant_tables(tenant_id, status);

-- ========================================
-- DATOS DE EJEMPLO: Restaurante El Sazón
-- ========================================

-- UUID del tenant "Restaurante El Sazón"
-- 83cfebd6-0668-43d1-a26f-46f32fdd8944

-- Insertar mesas de ejemplo
INSERT INTO public.restaurant_tables (tenant_id, table_number, seats, status) VALUES
-- 3 mesas de 2 personas
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 1, 2, 'available'),
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 2, 2, 'available'),
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 3, 2, 'available'),

-- 4 mesas de 4 personas
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 4, 4, 'available'),
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 5, 4, 'occupied'),
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 6, 4, 'available'),
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 7, 4, 'available'),

-- 2 mesas de 6 personas
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 8, 6, 'available'),
('83cfebd6-0668-43d1-a26f-46f32fdd8944', 9, 6, 'reserved');

-- ========================================
-- VERIFICACIÓN
-- ========================================

-- Ver todas las mesas del restaurante
SELECT 
    table_number AS "Mesa #",
    seats AS "Capacidad",
    status AS "Estado",
    created_at AS "Creada"
FROM public.restaurant_tables
WHERE tenant_id = '83cfebd6-0668-43d1-a26f-46f32fdd8944'
ORDER BY table_number;

-- Contar mesas por estado
SELECT 
    status AS "Estado",
    COUNT(*) AS "Cantidad"
FROM public.restaurant_tables
WHERE tenant_id = '83cfebd6-0668-43d1-a26f-46f32fdd8944'
GROUP BY status;

-- Capacidad total
SELECT 
    COUNT(*) AS "Total Mesas",
    SUM(seats) AS "Capacidad Total"
FROM public.restaurant_tables
WHERE tenant_id = '83cfebd6-0668-43d1-a26f-46f32fdd8944';
