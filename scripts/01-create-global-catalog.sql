-- Script to implement Global Product Catalog
-- Date: 2025-11-24

-- 1. Create global_products table
CREATE TABLE IF NOT EXISTS public.global_products (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    business_type VARCHAR(50) NOT NULL, -- 'ferreteria', 'abarrotes', 'restaurante'
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    imagen_url TEXT,
    codigo_barras VARCHAR(50) UNIQUE,
    categoria VARCHAR(100),
    marca VARCHAR(100),
    created_at TIMESTAMP DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_global_business_type ON public.global_products(business_type);
CREATE INDEX IF NOT EXISTS idx_global_barcode ON public.global_products(codigo_barras);

-- 2. Add reference to products table
ALTER TABLE public.productos 
ADD COLUMN IF NOT EXISTS global_product_id uuid REFERENCES public.global_products(id);

-- 3. Make name nullable in products (local override or inherit)
ALTER TABLE public.productos ALTER COLUMN nombre DROP NOT NULL;

-- 4. Verification
SELECT COUNT(*) as global_products_created FROM global_products;
