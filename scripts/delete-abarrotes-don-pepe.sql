-- Script to delete "Abarrotes Don Pepe" and all associated data
-- Date: 2025-11-25
-- Tenant ID: a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11

-- 1. Delete Inventory
DELETE FROM public.inventario 
WHERE tenant_id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';

-- 2. Delete Variants
DELETE FROM public.variantes 
WHERE tenant_id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';

-- 3. Delete Products
DELETE FROM public.productos 
WHERE tenant_id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';

-- 4. Delete Orders (if any)
DELETE FROM public.orders 
WHERE tenant_id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';

-- 5. Delete Restaurant Tables (if any - unlikely for grocery but good practice)
DELETE FROM public.restaurant_tables 
WHERE tenant_id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';

-- 6. Finally, Delete the Tenant
DELETE FROM public.tenants 
WHERE id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';

-- 7. Verification
SELECT COUNT(*) as remaining_don_pepe 
FROM public.tenants 
WHERE id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
