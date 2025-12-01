-- ========================================
-- CONSULTAS DE VERIFICACIÓN
-- ========================================

-- Ver todos los productos de la Tienda
SELECT
    t.nombre AS Negocio,
    p.nombre AS Producto,
    v.nombre_variante AS Variante,
    v.precio,
    v.unidad_medida
FROM tenants t
JOIN productos p ON t.id = p.tenant_id
JOIN variantes v ON p.id = v.producto_id
WHERE t.tipo_negocio = 'Tienda'
ORDER BY p.nombre, v.nombre_variante;

-- Ver todos los productos de la Ferretería
SELECT
    t.nombre AS Negocio,
    p.nombre AS Producto,
    v.nombre_variante AS Variante,
    v.precio,
    v.unidad_medida
FROM tenants t
JOIN productos p ON t.id = p.tenant_id
JOIN variantes v ON p.id = v.producto_id
WHERE t.tipo_negocio = 'Ferreteria'
ORDER BY p.nombre, v.nombre_variante;

-- Ver todos los productos del Restaurante
SELECT
    t.nombre AS Negocio,
    p.nombre AS Producto,
    v.nombre_variante AS Variante,
    v.precio,
    v.unidad_medida
FROM tenants t
JOIN productos p ON t.id = p.tenant_id
JOIN variantes v ON p.id = v.producto_id
WHERE t.tipo_negocio = 'Restaurante'
ORDER BY p.nombre, v.nombre_variante;

-- Contar productos por cada tenant
SELECT
    t.nombre AS Negocio,
    t.tipo_negocio,
    COUNT(DISTINCT p.id) AS Total_Productos,
    COUNT(v.id) AS Total_Variantes
FROM tenants t
LEFT JOIN productos p ON t.id = p.tenant_id
LEFT JOIN variantes v ON p.id = v.producto_id
GROUP BY t.id, t.nombre, t.tipo_negocio
ORDER BY t.nombre;
