-- Script to create two new grocery stores and link them to the global catalog
-- Date: 2025-11-25

-- 1. Create Tenants
-- Tienda Don Jose
INSERT INTO public.tenants (id, nombre, tipo_negocio) VALUES 
('a1b2c3d4-e5f6-7890-1234-567890abcdef', 'Tienda Don Jose', 'Abarrotes');

-- Miselania Maria
INSERT INTO public.tenants (id, nombre, tipo_negocio) VALUES 
('b2c3d4e5-f678-9012-3456-7890abcdef12', 'Miselania Maria', 'Abarrotes');


-- 2. Link Global Products to "Tienda Don Jose"
-- We insert into local products table referencing the global_product_id
INSERT INTO public.productos (tenant_id, global_product_id, nombre, descripcion, imagen_url)
SELECT 
    'a1b2c3d4-e5f6-7890-1234-567890abcdef', -- Don Jose ID
    id, -- Global Product ID
    nombre, -- Inherit name (optional, but good for cache)
    descripcion,
    imagen_url
FROM public.global_products
WHERE business_type = 'abarrotes';

-- 3. Create Variants for "Tienda Don Jose" (Price NULL)
INSERT INTO public.variantes (tenant_id, producto_id, nombre_variante, precio, costo, track_stock, codigo_barras)
SELECT 
    'a1b2c3d4-e5f6-7890-1234-567890abcdef',
    p.id,
    'Unidad',
    NULL, -- Price NULL as requested
    NULL,
    true,
    gp.codigo_barras -- Inherit barcode from global
FROM public.productos p
JOIN public.global_products gp ON p.global_product_id = gp.id
WHERE p.tenant_id = 'a1b2c3d4-e5f6-7890-1234-567890abcdef';

-- 4. Create Inventory for "Tienda Don Jose" (Stock: 50)
INSERT INTO public.inventario (tenant_id, variante_id, cantidad, ubicacion)
SELECT 
    'a1b2c3d4-e5f6-7890-1234-567890abcdef',
    v.id,
    50, -- Fixed stock for Don Jose
    'Bodega'
FROM public.variantes v
WHERE v.tenant_id = 'a1b2c3d4-e5f6-7890-1234-567890abcdef';


-- 5. Link Global Products to "Miselania Maria"
INSERT INTO public.productos (tenant_id, global_product_id, nombre, descripcion, imagen_url)
SELECT 
    'b2c3d4e5-f678-9012-3456-7890abcdef12', -- Maria ID
    id,
    nombre,
    descripcion,
    imagen_url
FROM public.global_products
WHERE business_type = 'abarrotes';

-- 6. Create Variants for "Miselania Maria" (Price NULL)
INSERT INTO public.variantes (tenant_id, producto_id, nombre_variante, precio, costo, track_stock, codigo_barras)
SELECT 
    'b2c3d4e5-f678-9012-3456-7890abcdef12',
    p.id,
    'Unidad',
    NULL, -- Price NULL as requested
    NULL,
    true,
    gp.codigo_barras
FROM public.productos p
JOIN public.global_products gp ON p.global_product_id = gp.id
WHERE p.tenant_id = 'b2c3d4e5-f678-9012-3456-7890abcdef12';

-- 7. Create Inventory for "Miselania Maria" (Stock: 25)
INSERT INTO public.inventario (tenant_id, variante_id, cantidad, ubicacion)
SELECT 
    'b2c3d4e5-f678-9012-3456-7890abcdef12',
    v.id,
    25, -- Different stock for Maria
    'Estante Principal'
FROM public.variantes v
WHERE v.tenant_id = 'b2c3d4e5-f678-9012-3456-7890abcdef12';

-- 8. Verification
SELECT t.nombre, COUNT(p.id) as productos, SUM(i.cantidad) as total_stock
FROM public.tenants t
JOIN public.productos p ON t.id = p.tenant_id
JOIN public.variantes v ON p.id = v.producto_id
JOIN public.inventario i ON v.id = i.variante_id
WHERE t.id IN ('a1b2c3d4-e5f6-7890-1234-567890abcdef', 'b2c3d4e5-f678-9012-3456-7890abcdef12')
GROUP BY t.nombre;
