-- 1. Actualizar dueno@abarrotes.com para asignarle el tenant "Tienda Don Jose"
UPDATE user_tenant_permissions 
SET tenant_id = 'a1b2c3d4-e5f6-7890-1234-567890abcdef', 
    role_in_tenant = 'admin' 
WHERE user_id = 'f4707db9-2fc5-4a46-8ff6-559d8779adf6';

-- 2. Crear registro para cajero@abarrotes.com
INSERT INTO user_tenant_permissions (user_id, tenant_id, role_in_tenant, permissions) 
VALUES (
    '2f7fea90-9af8-4dda-847c-3bd05defe26c', 
    'a1b2c3d4-e5f6-7890-1234-567890abcdef', 
    'cashier', 
    '["products.read", "sales.create", "inventory.read"]'::jsonb
);

-- 3. Verificar que se crearon correctamente
SELECT u.email, utp.role_in_tenant, t.nombre 
FROM user_tenant_permissions utp 
JOIN users u ON utp.user_id = u.id 
JOIN tenants t ON utp.tenant_id = t.id 
WHERE u.email IN ('dueno@abarrotes.com', 'cajero@abarrotes.com');
