-- =====================================================
-- POBLAR INVENTARIO FALTANTE
-- =====================================================
-- Fecha: 2025-11-29
-- Propósito: Insertar registros de inventario para variantes que no tienen stock
-- Default: 20 unidades por producto
-- =====================================================

DO $$
DECLARE
    v_tenant_don_jose UUID := 'a1b2c3d4-e5f6-7890-1234-567890abcdef';
    v_tenant_ferreteria UUID := '2853318c-e931-4718-b955-4508168e6953';
    v_count INT := 0;
BEGIN
    RAISE NOTICE '=== INICIANDO POBLACIÓN DE INVENTARIO ===';

    -- Insertar inventario para variantes que no tienen registro en la tabla inventario
    -- Se aplica solo a los tenants específicos para evitar afectar otros datos
    
    WITH inserted AS (
        INSERT INTO inventario (tenant_id, variante_id, sucursal_id, cantidad, ubicacion)
        SELECT 
            v.tenant_id,
            v.id,
            1, -- Sucursal Principal (ID 1 por defecto)
            20.00, -- Cantidad por defecto
            'Bodega General' -- Ubicación por defecto
        FROM variantes v
        WHERE v.tenant_id IN (v_tenant_don_jose, v_tenant_ferreteria)
        AND NOT EXISTS (
            SELECT 1 
            FROM inventario i 
            WHERE i.variante_id = v.id
        )
        RETURNING id
    )
    SELECT COUNT(*) INTO v_count FROM inserted;

    RAISE NOTICE 'Se han creado % registros de inventario.', v_count;
    RAISE NOTICE '=== POBLACIÓN FINALIZADA ===';
END $$;
