-- =====================================================
-- Script de Corrección: Asociar Usuarios con Tenants Reales
-- Fecha: 26 de Noviembre de 2025
-- =====================================================

-- Limpiar asociaciones incorrectas previas
DELETE FROM user_tenant_permissions;

-- =====================================================
-- 1. Asociar dueno@ferreteria.com con Ferretería El Tornillo
-- =====================================================
INSERT INTO user_tenant_permissions (user_id, tenant_id, role_in_tenant, permissions)
SELECT 
    u.id,
    t.id,
    'admin',
    '["*"]'::jsonb
FROM users u, tenants t
WHERE u.email = 'dueno@ferreteria.com'
  AND t.id = '2853318c-e931-4718-b955-4508168e6953'
ON CONFLICT (user_id, tenant_id) DO NOTHING;

-- Actualizar owner
UPDATE tenants 
SET owner_user_id = (SELECT id FROM users WHERE email = 'dueno@ferreteria.com')
WHERE id = '2853318c-e931-4718-b955-4508168e6953';

-- =====================================================
-- 2. Asociar dueno@restaurante.com con Restaurante El Sazón
-- =====================================================
INSERT INTO user_tenant_permissions (user_id, tenant_id, role_in_tenant, permissions)
SELECT 
    u.id,
    t.id,
    'admin',
    '["*"]'::jsonb
FROM users u, tenants t
WHERE u.email = 'dueno@restaurante.com'
  AND t.id = '83cfebd6-0668-43d1-a26f-46f32fdd8944'
ON CONFLICT (user_id, tenant_id) DO NOTHING;

-- Actualizar owner
UPDATE tenants 
SET owner_user_id = (SELECT id FROM users WHERE email = 'dueno@restaurante.com')
WHERE id = '83cfebd6-0668-43d1-a26f-46f32fdd8944';

-- =====================================================
-- 3. Asociar dueno@abarrotes.com con Tienda Don Jose
-- =====================================================
INSERT INTO user_tenant_permissions (user_id, tenant_id, role_in_tenant, permissions)
SELECT 
    u.id,
    t.id,
    'admin',
    '["*"]'::jsonb
FROM users u, tenants t
WHERE u.email = 'dueno@abarrotes.com'
  AND t.id = 'a1b2c3d4-e5f6-7890-1234-567890abcdef'
ON CONFLICT (user_id, tenant_id) DO NOTHING;

-- Actualizar owner
UPDATE tenants 
SET owner_user_id = (SELECT id FROM users WHERE email = 'dueno@abarrotes.com')
WHERE id = 'a1b2c3d4-e5f6-7890-1234-567890abcdef';

-- =====================================================
-- 4. Asociar cajero@abarrotes.com con Tienda Don Jose
-- =====================================================
INSERT INTO user_tenant_permissions (user_id, tenant_id, role_in_tenant, permissions)
SELECT 
    u.id,
    t.id,
    'cashier',
    '["products.read", "sales.create", "inventory.count"]'::jsonb
FROM users u, tenants t
WHERE u.email = 'cajero@abarrotes.com'
  AND t.id = 'a1b2c3d4-e5f6-7890-1234-567890abcdef'
ON CONFLICT (user_id, tenant_id) DO NOTHING;

-- =====================================================
-- Verificación
-- =====================================================
-- Descomentar para verificar:
SELECT 
    u.email, 
    u.role as rol_global, 
    t.nombre as negocio, 
    utp.role_in_tenant as rol_en_tenant 
FROM users u 
LEFT JOIN user_tenant_permissions utp ON u.id = utp.user_id 
LEFT JOIN tenants t ON utp.tenant_id = t.id 
ORDER BY u.role, u.email;
