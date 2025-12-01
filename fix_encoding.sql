-- =====================================================
-- CORRECCIÓN DE CODIFICACIÓN DE CARACTERES (MOJIBAKE)
-- =====================================================
-- Fecha: 2025-11-29
-- Propósito: Corregir caracteres corruptos (doble codificación UTF-8 interpretada como Win1252/CP850)
-- Tablas afectadas: global_products, productos, variantes
-- =====================================================

DO $$
DECLARE
    v_count INT := 0;
BEGIN
    RAISE NOTICE '=== INICIANDO CORRECCIÓN DE CARACTERES ===';

    -- Patrones identificados:
    -- ├â┬│ -> ó
    -- ├â┬í -> á
    -- ├â┬▒ -> ñ
    -- ├â┬® -> é
    -- ├â┬¡ -> í
    -- ├â┬║ -> ú
    -- Ã³ -> ó (Variante común)
    -- Ã± -> ñ (Variante común)
    -- Ã¡ -> á (Variante común)
    
    -- Función auxiliar para limpiar una columna
    -- Nota: Se hace update directo por simplicidad en este bloque

    -- 1. GLOBAL_PRODUCTS
    UPDATE global_products
    SET nombre = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        nombre, 
        '├â┬│', 'ó'),
        '├â┬í', 'á'),
        '├â┬▒', 'ñ'),
        '├â┬®', 'é'),
        '├â┬¡', 'í'),
        '├â┬║', 'ú'),
        categoria = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        categoria, 
        '├â┬│', 'ó'),
        '├â┬í', 'á'),
        '├â┬▒', 'ñ'),
        '├â┬®', 'é'),
        '├â┬¡', 'í'),
        '├â┬║', 'ú');
        
    -- Segunda pasada para otros patrones comunes de UTF-8 mal interpretado (Latin1)
    UPDATE global_products
    SET nombre = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        nombre, 
        'Ã³', 'ó'),
        'Ã¡', 'á'),
        'Ã±', 'ñ'),
        'Ã©', 'é'),
        'Ãed', 'í'),
        'Ãº', 'ú'),
        categoria = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        categoria, 
        'Ã³', 'ó'),
        'Ã¡', 'á'),
        'Ã±', 'ñ'),
        'Ã©', 'é'),
        'Ãed', 'í'),
        'Ãº', 'ú');

    -- 2. PRODUCTOS (Tenants)
    UPDATE productos
    SET nombre = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        nombre, 
        '├â┬│', 'ó'),
        '├â┬í', 'á'),
        '├â┬▒', 'ñ'),
        '├â┬®', 'é'),
        '├â┬¡', 'í'),
        '├â┬║', 'ú'),
        categoria = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        categoria, 
        '├â┬│', 'ó'),
        '├â┬í', 'á'),
        '├â┬▒', 'ñ'),
        '├â┬®', 'é'),
        '├â┬¡', 'í'),
        '├â┬║', 'ú');

    UPDATE productos
    SET nombre = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        nombre, 
        'Ã³', 'ó'),
        'Ã¡', 'á'),
        'Ã±', 'ñ'),
        'Ã©', 'é'),
        'Ãed', 'í'),
        'Ãº', 'ú'),
        categoria = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        categoria, 
        'Ã³', 'ó'),
        'Ã¡', 'á'),
        'Ã±', 'ñ'),
        'Ã©', 'é'),
        'Ãed', 'í'),
        'Ãº', 'ú');

    -- 3. VARIANTES
    UPDATE variantes
    SET nombre_variante = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        nombre_variante, 
        '├â┬│', 'ó'),
        '├â┬í', 'á'),
        '├â┬▒', 'ñ'),
        '├â┬®', 'é'),
        '├â┬¡', 'í'),
        '├â┬║', 'ú');

    UPDATE variantes
    SET nombre_variante = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        nombre_variante, 
        'Ã³', 'ó'),
        'Ã¡', 'á'),
        'Ã±', 'ñ'),
        'Ã©', 'é'),
        'Ãed', 'í'),
        'Ãº', 'ú');

    RAISE NOTICE '=== CORRECCIÓN COMPLETADA ===';
END $$;
