-- =====================================================
-- Sistema de Autenticación Multi-Tenant
-- Fecha: 26 de Noviembre de 2025
-- =====================================================

-- Habilitar extensión para UUIDs (si no está habilitada)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- Tabla: users
-- Almacena todos los usuarios del sistema
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    
    -- Rol global: super_admin, tenant_admin, tenant_user
    role VARCHAR(50) NOT NULL CHECK (role IN ('super_admin', 'tenant_admin', 'tenant_user')),
    
    is_active BOOLEAN DEFAULT true,
    email_verified BOOLEAN DEFAULT false,
    
    -- Auditoría
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    last_login_at TIMESTAMP
);

-- Índices para búsquedas frecuentes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_active ON users(is_active);

-- =====================================================
-- Tabla: user_tenant_permissions
-- Relaciona usuarios con tenants y define permisos específicos
-- Un usuario puede tener acceso a múltiples tenants (raro, pero posible)
-- Super admins NO necesitan registros aquí (tienen acceso global)
-- =====================================================
CREATE TABLE IF NOT EXISTS user_tenant_permissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    
    -- Rol dentro del tenant: 'admin', 'cashier', 'manager', 'inventory_manager', 'viewer'
    role_in_tenant VARCHAR(50) NOT NULL,
    
    -- Permisos específicos (JSON array de strings)
    -- Ejemplo: ["products.read", "sales.create", "inventory.count"]
    permissions JSONB DEFAULT '[]',
    
    -- Auditoría
    created_at TIMESTAMP DEFAULT NOW(),
    created_by_user_id UUID REFERENCES users(id),
    
    -- Un usuario puede tener solo un rol por tenant
    UNIQUE(user_id, tenant_id)
);

-- Índices para búsquedas frecuentes
CREATE INDEX idx_user_tenant_user ON user_tenant_permissions(user_id);
CREATE INDEX idx_user_tenant_tenant ON user_tenant_permissions(tenant_id);
CREATE INDEX idx_user_tenant_composite ON user_tenant_permissions(user_id, tenant_id);

-- =====================================================
-- Tabla: inventory_changes
-- Registra cambios de inventario que requieren aprobación
-- Los empleados (tenant_user) crean cambios pendientes
-- Los admins (tenant_admin) aprueban o rechazan
-- =====================================================
CREATE TABLE IF NOT EXISTS inventory_changes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id),
    variante_id BIGINT NOT NULL REFERENCES variantes(id),
    sucursal_id INTEGER,
    
    -- Usuario que propuso el cambio
    created_by_user_id UUID NOT NULL REFERENCES users(id),
    
    -- Tipo de cambio
    change_type VARCHAR(50) NOT NULL CHECK (change_type IN ('count', 'adjustment', 'entry', 'exit')),
    
    -- Valores del inventario
    cantidad_anterior DECIMAL(10,4),
    cantidad_nueva DECIMAL(10,4),
    diferencia DECIMAL(10,4),
    
    -- Estado de aprobación
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    
    -- Revisión por admin
    reviewed_by_user_id UUID REFERENCES users(id),
    reviewed_at TIMESTAMP,
    review_notes TEXT,
    
    -- Justificación del cambio
    reason TEXT,
    notes TEXT,
    
    -- Auditoría
    created_at TIMESTAMP DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_inv_changes_tenant_status ON inventory_changes(tenant_id, status);
CREATE INDEX idx_inv_changes_user ON inventory_changes(created_by_user_id);
CREATE INDEX idx_inv_changes_variante ON inventory_changes(variante_id);
CREATE INDEX idx_inv_changes_created_at ON inventory_changes(created_at DESC);

-- =====================================================
-- Actualizar tabla tenants
-- Agregar campo para identificar al dueño del negocio
-- =====================================================
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS owner_user_id UUID REFERENCES users(id);
CREATE INDEX IF NOT EXISTS idx_tenants_owner ON tenants(owner_user_id);

-- =====================================================
-- Actualizar tabla inventario
-- Agregar campos de auditoría
-- =====================================================
ALTER TABLE inventario ADD COLUMN IF NOT EXISTS fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE inventario ADD COLUMN IF NOT EXISTS usuario_actualizacion VARCHAR(255);

-- =====================================================
-- Datos de ejemplo: Super Admin
-- =====================================================
-- IMPORTANTE: Cambiar el email y password en producción
-- Password: "Admin123!" (usar bcrypt con 10 rounds para producción)
-- Este hash es solo para desarrollo: $2b$10$YourActualBcryptHashHere

INSERT INTO users (email, password_hash, first_name, last_name, role, email_verified, is_active)
VALUES (
    'admin@drcv.com',
    '$2b$10$XqN3YP0YRjHUwDfGwvMzgeQXZKJiJwXhzJ5lYJ7WqZLwFKvQZGXOi', -- Password: Admin123!
    'Super',
    'Admin',
    'super_admin',
    true,
    true
)
ON CONFLICT (email) DO NOTHING;

-- =====================================================
-- Datos de ejemplo: Tenant Admins
-- =====================================================
-- Usuario para Abarrotes Don Pepe
INSERT INTO users (email, password_hash, first_name, last_name, role, email_verified, is_active)
VALUES (
    'dueno@abarrotes.com',
    '$2b$10$XqN3YP0YRjHUwDfGwvMzgeQXZKJiJwXhzJ5lYJ7WqZLwFKvQZGXOi', -- Password: Admin123!
    'Juan',
    'Pérez',
    'tenant_admin',
    true,
    true
)
ON CONFLICT (email) DO NOTHING;

-- Usuario para Ferretería El Tornillo
INSERT INTO users (email, password_hash, first_name, last_name, role, email_verified, is_active)
VALUES (
    'dueno@ferreteria.com',
    '$2b$10$XqN3YP0YRjHUwDfGwvMzgeQXZKJiJwXhzJ5lYJ7WqZLwFKvQZGXOi', -- Password: Admin123!
    'María',
    'González',
    'tenant_admin',
    true,
    true
)
ON CONFLICT (email) DO NOTHING;

-- Usuario para Restaurante El Sazón
INSERT INTO users (email, password_hash, first_name, last_name, role, email_verified, is_active)
VALUES (
    'dueno@restaurante.com',
    '$2b$10$XqN3YP0YRjHUwDfGwvMzgeQXZKJiJwXhzJ5lYJ7WqZLwFKvQZGXOi', -- Password: Admin123!
    'Carlos',
    'Ramírez',
    'tenant_admin',
    true,
    true
)
ON CONFLICT (email) DO NOTHING;

-- =====================================================
-- Asociar usuarios con tenants
-- =====================================================
-- Abarrotes Don Pepe
INSERT INTO user_tenant_permissions (user_id, tenant_id, role_in_tenant, permissions)
SELECT 
    u.id,
    t.id,
    'admin',
    '["*"]'::jsonb
FROM users u, tenants t
WHERE u.email = 'dueno@abarrotes.com'
  AND t.nombre = 'Abarrotes Don Pepe'
ON CONFLICT (user_id, tenant_id) DO NOTHING;

-- Actualizar owner_user_id
UPDATE tenants t
SET owner_user_id = u.id
FROM users u
WHERE u.email = 'dueno@abarrotes.com'
  AND t.nombre = 'Abarrotes Don Pepe';

-- Ferretería El Tornillo
INSERT INTO user_tenant_permissions (user_id, tenant_id, role_in_tenant, permissions)
SELECT 
    u.id,
    t.id,
    'admin',
    '["*"]'::jsonb
FROM users u, tenants t
WHERE u.email = 'dueno@ferreteria.com'
  AND t.nombre = 'Ferretería El Tornillo'
ON CONFLICT (user_id, tenant_id) DO NOTHING;

UPDATE tenants t
SET owner_user_id = u.id
FROM users u
WHERE u.email = 'dueno@ferreteria.com'
  AND t.nombre = 'Ferretería El Tornillo';

-- Restaurante El Sazón
INSERT INTO user_tenant_permissions (user_id, tenant_id, role_in_tenant, permissions)
SELECT 
    u.id,
    t.id,
    'admin',
    '["*"]'::jsonb
FROM users u, tenants t
WHERE u.email = 'dueno@restaurante.com'
  AND t.nombre = 'Restaurante El Sazón'
ON CONFLICT (user_id, tenant_id) DO NOTHING;

UPDATE tenants t
SET owner_user_id = u.id
FROM users u
WHERE u.email = 'dueno@restaurante.com'
  AND t.nombre = 'Restaurante El Sazón';

-- =====================================================
-- Datos de ejemplo: Empleados (tenant_user)
-- =====================================================
-- Cajero para Abarrotes Don Pepe
INSERT INTO users (email, password_hash, first_name, last_name, role, email_verified, is_active)
VALUES (
    'cajero@abarrotes.com',
    '$2b$10$XqN3YP0YRjHUwDfGwvMzgeQXZKJiJwXhzJ5lYJ7WqZLwFKvQZGXOi', -- Password: Admin123!
    'Luis',
    'Martínez',
    'tenant_user',
    true,
    true
)
ON CONFLICT (email) DO NOTHING;

-- Asociar cajero con Abarrotes Don Pepe
INSERT INTO user_tenant_permissions (user_id, tenant_id, role_in_tenant, permissions)
SELECT 
    u.id,
    t.id,
    'cashier',
    '["products.read", "sales.create", "inventory.count"]'::jsonb
FROM users u, tenants t
WHERE u.email = 'cajero@abarrotes.com'
  AND t.nombre = 'Abarrotes Don Pepe'
ON CONFLICT (user_id, tenant_id) DO NOTHING;

-- =====================================================
-- Función para actualizar updated_at automáticamente
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para users
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- Verificación
-- =====================================================
-- Descomentar para verificar los datos insertados
-- SELECT u.email, u.role, t.nombre as tenant, utp.role_in_tenant
-- FROM users u
-- LEFT JOIN user_tenant_permissions utp ON u.id = utp.user_id
-- LEFT JOIN tenants t ON utp.tenant_id = t.id
-- ORDER BY u.role, u.email;

-- =====================================================
-- NOTAS IMPORTANTES
-- =====================================================
-- 1. El password_hash aquí es solo para DESARROLLO
--    En producción, usar bcrypt con rounds=10 mínimo
-- 2. Cambiar el email del super admin
-- 3. Habilitar verificación de email en producción
-- 4. Implementar rate limiting en login
-- 5. Considerar 2FA para super_admin
-- 6. Rotar JWT secrets regularmente
-- =====================================================
