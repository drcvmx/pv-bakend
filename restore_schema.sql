-- Script de Restauración Manual de Tablas
-- Ejecutar esto arreglará la estructura de la base de datos

BEGIN;

-- 1. Limpiar tablas conflictivas si existen (para recrear limpio)
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS user_tenant_permissions CASCADE;
DROP TABLE IF EXISTS inventory_changes CASCADE;
DROP TABLE IF EXISTS inventario CASCADE;
DROP TABLE IF EXISTS inventario_sesiones CASCADE;
DROP TABLE IF EXISTS variantes CASCADE;
DROP TABLE IF EXISTS productos CASCADE;

-- 2. Recrear Tablas de Productos y Variantes
CREATE TABLE IF NOT EXISTS public.productos (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    tenant_id uuid NOT NULL,
    nombre character varying(255) NOT NULL,
    descripcion text,
    precio numeric(10,2) NOT NULL,
    stock integer DEFAULT 0,
    imagen_url text,
    created_at timestamp without time zone DEFAULT now(),
    marca character varying(100),
    categoria character varying(100),
    proveedor character varying(100),
    global_product_id uuid,
    CONSTRAINT productos_tenant_fk FOREIGN KEY (tenant_id) REFERENCES public.tenants(id),
    CONSTRAINT productos_global_product_id_fkey FOREIGN KEY (global_product_id) REFERENCES public.global_products(id)
);

CREATE TABLE IF NOT EXISTS public.variantes (
    id bigserial PRIMARY KEY,
    producto_id uuid,
    tenant_id uuid,
    nombre_variante character varying(255),
    precio numeric(10,2),
    stock integer DEFAULT 0,
    unidad_medida character varying(50),
    codigo_barras character varying(100),
    codigo_qr character varying(255),
    tipo_codigo character varying(50),
    CONSTRAINT variantes_producto_fk FOREIGN KEY (producto_id) REFERENCES public.productos(id) ON DELETE CASCADE,
    CONSTRAINT variantes_tenant_fk FOREIGN KEY (tenant_id) REFERENCES public.tenants(id)
);

-- 3. Recrear Tablas de Inventario
CREATE TABLE IF NOT EXISTS public.inventario (
    id serial PRIMARY KEY,
    tenant_id uuid NOT NULL,
    variante_id bigint,
    sucursal_id integer,
    cantidad numeric(10,4) DEFAULT 0,
    ubicacion character varying(255),
    fecha_actualizacion timestamp without time zone DEFAULT now(),
    usuario_actualizacion character varying(255),
    CONSTRAINT inventario_variante_fk FOREIGN KEY (variante_id) REFERENCES public.variantes(id) ON DELETE CASCADE,
    CONSTRAINT inventario_tenant_fk FOREIGN KEY (tenant_id) REFERENCES public.tenants(id)
);

CREATE TABLE IF NOT EXISTS public.inventory_changes (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    tenant_id uuid NOT NULL,
    variante_id bigint NOT NULL,
    sucursal_id integer,
    created_by_user_id uuid,
    change_type character varying(50) NOT NULL,
    cantidad_anterior numeric(10,4),
    cantidad_nueva numeric(10,4),
    diferencia numeric(10,4),
    status character varying(50) DEFAULT 'approved',
    reviewed_by_user_id uuid,
    reviewed_at timestamp without time zone,
    review_notes text,
    reason text,
    notes text,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT ic_tenant_fk FOREIGN KEY (tenant_id) REFERENCES public.tenants(id),
    CONSTRAINT ic_variante_fk FOREIGN KEY (variante_id) REFERENCES public.variantes(id)
);

CREATE TABLE IF NOT EXISTS public.inventario_sesiones (
    id serial PRIMARY KEY,
    tenant_id uuid NOT NULL,
    sucursal_id integer,
    usuario_nombre character varying(255),
    fecha_inicio timestamp without time zone DEFAULT now(),
    fecha_cierre timestamp without time zone
);

-- 4. Recrear Tablas de Permisos
CREATE TABLE IF NOT EXISTS public.user_tenant_permissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    user_id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    role_in_tenant character varying(50) NOT NULL,
    permissions jsonb DEFAULT '{}'::jsonb,
    created_by_user_id uuid,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT utp_user_fk FOREIGN KEY (user_id) REFERENCES public.users(id),
    CONSTRAINT utp_tenant_fk FOREIGN KEY (tenant_id) REFERENCES public.tenants(id)
);

-- 5. Recrear Tablas de Órdenes (Ventas)
DO $$ BEGIN
    CREATE TYPE public.payout_status_enum AS ENUM ('pending', 'paid');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

CREATE TABLE IF NOT EXISTS public.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    tenant_id uuid NOT NULL,
    store_id integer,
    customer_email character varying(255),
    customer_name character varying(255),
    total_amount numeric(10,2) NOT NULL,
    stripe_payment_intent_id character varying(255),
    status character varying(50) DEFAULT 'pending_payment',
    payout_status public.payout_status_enum DEFAULT 'pending',
    collection_code character varying(50),
    created_at timestamp without time zone DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    order_id uuid,
    variant_id character varying(255),
    product_name character varying(255) NOT NULL,
    quantity integer NOT NULL,
    price numeric(10,2) NOT NULL,
    CONSTRAINT "FK_order_items_order" FOREIGN KEY ("order_id") REFERENCES "orders"("id") ON DELETE CASCADE
);

-- 6. Restaurar Permisos de Dueños
INSERT INTO user_tenant_permissions (user_id, tenant_id, role_in_tenant, permissions)
SELECT owner_user_id, id, 'owner', '{"all": true}'::jsonb
FROM tenants
WHERE owner_user_id IS NOT NULL;

COMMIT;
