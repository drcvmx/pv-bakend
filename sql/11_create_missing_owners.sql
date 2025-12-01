-- =====================================================
-- Crear usuarios para tenants sin dueños
-- Fecha: 26 de Noviembre de 2025
-- =====================================================

-- Password para todos: Admin123!
-- Hash: $2b$10$vADHISDqFgXj5N3CCAvANew2y8Cy.jAuzPGjc/apXRe.WqOhCwzPG

-- =====================================================
-- 1. Usuario para Miselania Maria (Abarrotes)
-- =====================================================
INSERT INTO users (email, password_hash, first_name, last_name, role, email_verified, is_active)
VALUES (
    'dueno@miselania.com',
    '$2b$10$vADHISDqFgXj5N3CCAvANew2y8Cy.jAuzPGjc/apXRe.WqOhCwzPG',
    'María',
    'López',
    'tenant_admin',
    true,
    true
)
ON CONFLICT (email) DO NOTHING;

-- Asociar con Miselania Maria
INSERT INTO user_tenant_permissions (user_id, tenant_id, role_in_tenant, permissions)
SELECT 
    u.id,
    t.id,
    'admin',
    '["*"]'::jsonb
FROM users u, tenants t
WHERE u.email = 'dueno@miselania.com'
  AND t.id = 'b2c3d4e5-f678-9012-3456-7890abcdef12'
ON CONFLICT (user_id, tenant_id) DO NOTHING;

-- Actualizar owner
UPDATE tenants 
SET owner_user_id = (SELECT id FROM users WHERE email = 'dueno@miselania.com')
WHERE id = 'b2c3d4e5-f678-9012-3456-7890abcdef12';

-- =====================================================
-- 2. Usuario para API PARA LA INDUSTRIA (Ferretería)
-- =====================================================
INSERT INTO users (email, password_hash, first_name, last_name, role, email_verified, is_active)
VALUES (
    'dueno@api-industria.com',
    '$2b$10$vADHISDqFgXj5N3CCAvANew2y8Cy.jAuzPGjc/apXRe.WqOhCwzPG',
    'Roberto',
    'Méndez',
    'tenant_admin',
    true,
    true
)
ON CONFLICT (email) DO NOTHING;

-- Asociar con API PARA LA INDUSTRIA
INSERT INTO user_tenant_permissions (user_id, tenant_id, role_in_tenant, permissions)
SELECT 
    u.id,
    t.id,
    'admin',
    '["*"]'::jsonb
FROM users u, tenants t
WHERE u.email = 'dueno@api-industria.com'
  AND t.id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765'
ON CONFLICT (user_id, tenant_id) DO NOTHING;

-- Actualizar owner
UPDATE tenants 
SET owner_user_id = (SELECT id FROM users WHERE email = 'dueno@api-industria.com')
WHERE id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- =====================================================
-- Verificación final
-- =====================================================
SELECT 
    t.nombre as tenant,
    u.email as owner_email,
    u.first_name || ' ' || u.last_name as owner_name,
    utp.role_in_tenant
FROM tenants t
LEFT JOIN users u ON t.owner_user_id = u.id
LEFT JOIN user_tenant_permissions utp ON u.id = utp.user_id AND t.id = utp.tenant_id
ORDER BY t.nombre;
