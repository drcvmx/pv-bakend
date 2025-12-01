-- =====================================================
-- FIX: TENANT LINKS & CHARACTER ENCODING
-- =====================================================

-- 1. FIX TENANT LINKS
-- Miselania Maria
UPDATE user_tenant_permissions
SET tenant_id = 'b2c3d4e5-f678-9012-3456-7890abcdef12'
WHERE user_id = (SELECT id FROM users WHERE email = 'dueno@miselania.com');

-- Ferretería El Tornillo
UPDATE user_tenant_permissions
SET tenant_id = '2853318c-e931-4718-b955-4508168e6953'
WHERE user_id = (SELECT id FROM users WHERE email = 'dueno@ferreteria.com');

-- Restaurante El Sazón
UPDATE user_tenant_permissions
SET tenant_id = '83cfebd6-0668-43d1-a26f-46f32fdd8944'
WHERE user_id = (SELECT id FROM users WHERE email = 'dueno@restaurante.com');

-- 2. FIX ENCODING (USERS)
-- Fix specific known bad names
UPDATE users SET first_name = 'María' WHERE email = 'dueno@miselania.com';
UPDATE users SET first_name = 'María' WHERE email = 'dueno@ferreteria.com';

-- Generic fix for Users table (if any other exists)
UPDATE users
SET first_name = convert_from(convert_to(first_name, 'LATIN1'), 'UTF8')
WHERE first_name LIKE '%Ã%';

UPDATE users
SET last_name = convert_from(convert_to(last_name, 'LATIN1'), 'UTF8')
WHERE last_name LIKE '%Ã%';

-- 3. FIX ENCODING (TENANTS)
UPDATE tenants
SET nombre = convert_from(convert_to(nombre, 'LATIN1'), 'UTF8')
WHERE nombre LIKE '%Ã%';

-- 4. FIX ENCODING (PRODUCTS & GLOBAL) - Re-applying from fix_double_encoding.sql
UPDATE global_products
SET nombre = convert_from(convert_to(nombre, 'LATIN1'), 'UTF8')
WHERE nombre LIKE '%Ã%';

UPDATE global_products
SET categoria = convert_from(convert_to(categoria, 'LATIN1'), 'UTF8')
WHERE categoria LIKE '%Ã%';

UPDATE productos
SET nombre = convert_from(convert_to(nombre, 'LATIN1'), 'UTF8')
WHERE nombre LIKE '%Ã%';

UPDATE productos
SET categoria = convert_from(convert_to(categoria, 'LATIN1'), 'UTF8')
WHERE categoria LIKE '%Ã%';

UPDATE variantes
SET nombre_variante = convert_from(convert_to(nombre_variante, 'LATIN1'), 'UTF8')
WHERE nombre_variante LIKE '%Ã%';

-- VERIFICATION
SELECT 'Users Fixed' as check, u.email, u.first_name, t.nombre as tenant_name
FROM users u
JOIN user_tenant_permissions p ON u.id = p.user_id
JOIN tenants t ON p.tenant_id = t.id
WHERE u.email IN ('dueno@miselania.com', 'dueno@ferreteria.com', 'dueno@restaurante.com');
