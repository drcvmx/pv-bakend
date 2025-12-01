-- Fix missing tenant_id for dueno@api-industria.com
-- Tenant: API PARA LA INDUSTRIA (ID: f8e9d7c6-5b4a-3210-9876-fedcba098765)

UPDATE user_tenant_permissions
SET tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765'
WHERE user_id = (SELECT id FROM users WHERE email = 'dueno@api-industria.com');

-- Verify the change
SELECT u.email, p.tenant_id, p.role_in_tenant, t.nombre 
FROM users u 
LEFT JOIN user_tenant_permissions p ON u.id = p.user_id 
LEFT JOIN tenants t ON p.tenant_id = t.id 
WHERE u.email = 'dueno@api-industria.com';
