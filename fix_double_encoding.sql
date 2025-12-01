-- =====================================================
-- CORRECCIÓN DE DOBLE CODIFICACIÓN (SOLO REGISTROS DAÑADOS)
-- =====================================================
-- Fecha: 2025-11-29
-- Propósito: Corregir registros que tienen doble codificación UTF-8 (ej: 'MarÃ­as')
-- Nota: 'Lim├│n' y otros NO se tocan porque son correctos (solo es error de visualización en terminal)
-- =====================================================

DO $$
DECLARE
    v_count INT := 0;
BEGIN
    RAISE NOTICE '=== INICIANDO REPARACIÓN DE DOBLE CODIFICACIÓN ===';

    -- 1. GLOBAL_PRODUCTS
    -- Solo corregimos los que contienen 'Ã' (C3 83), que es el primer byte de la doble codificación
    -- Esto arreglará 'MarÃ­as', 'JardÃ­n', etc.
    
    UPDATE global_products
    SET nombre = convert_from(convert_to(nombre, 'LATIN1'), 'UTF8')
    WHERE nombre LIKE '%Ã%';

    UPDATE global_products
    SET categoria = convert_from(convert_to(categoria, 'LATIN1'), 'UTF8')
    WHERE categoria LIKE '%Ã%';

    -- 2. PRODUCTOS (Tenants)
    UPDATE productos
    SET nombre = convert_from(convert_to(nombre, 'LATIN1'), 'UTF8')
    WHERE nombre LIKE '%Ã%';

    UPDATE productos
    SET categoria = convert_from(convert_to(categoria, 'LATIN1'), 'UTF8')
    WHERE categoria LIKE '%Ã%';

    -- 3. VARIANTES
    UPDATE variantes
    SET nombre_variante = convert_from(convert_to(nombre_variante, 'LATIN1'), 'UTF8')
    WHERE nombre_variante LIKE '%Ã%';

    RAISE NOTICE '=== REPARACIÓN COMPLETADA ===';
END $$;
