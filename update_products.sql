-- 1. Fix product_audits table to accept varchar IDs
DROP TABLE IF EXISTS product_audits;
CREATE TABLE product_audits (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    product_id varchar(50) NOT NULL,
    tenant_id uuid NOT NULL,
    user_id uuid NOT NULL,
    action varchar(50) NOT NULL,
    changes jsonb,
    created_at timestamp DEFAULT now(),
    CONSTRAINT pa_user_fk FOREIGN KEY (user_id) REFERENCES public.users(id)
);

-- 2. Update Products and Variants (Matching by Name)
-- We use a temporary table to hold the CSV data
CREATE TEMP TABLE product_updates (
    nombre text,
    codigo_barras text,
    marca text,
    precio numeric
);

INSERT INTO product_updates (nombre, codigo_barras, marca, precio) VALUES
('Arco industrial de aluminio', '10251', 'TRUPER / GENÉRICO', 225.00),
('Arco junior', '10210', 'TRUPER / GENÉRICO', 95.00),
('Arco profecional', '10230', 'TRUPER / GENÉRICO', 259.00),
('ARNES TRUPER', '14433', 'TRUPER', 625.00),
('Barreta de punta', '10759', 'TRUPER', 285.00),
('Barretas', '10850', 'TRUPER', 279.00),
('Cincel', '12163', 'TRUPER', 157.00),
('Cincel ladrillero', '12184', 'TRUPER', 189.00),
('Cincho plastico', '44308', 'GENÉRICO', 55.00),
('Cincho plastico Truper', '44301', 'TRUPER', 85.00),
('Cinta de amarre', '12322', 'GENÉRICO', 99.00),
('Cinta de montaje', '12540', 'GENÉRICO', 75.00),
('Despachador de cinta', '12559', 'GENÉRICO', 125.00),
('Cinta Ducto Plata', '12611', 'GENÉRICO', 160.00),
('Cinta de aislar Negro', '20521', 'GENÉRICO', 45.00),
('Cinta Doble Cara Poli', '12502', 'GENÉRICO', 90.00),
('Cintas masking', '12503', 'GENÉRICO', 60.00),
('Cinta adhesiva de polipropileno transparente', '12504', 'GENÉRICO', 45.00),
('Cinta canela de empaque marca janel', '12550', 'JANEL', 180.00),
('Cinta transparente de empaque marca janel', '12551', 'JANEL', 180.00),
('Cutter con alma metalica', '16976', 'TRUPER', 75.00),
('Cutter profesional con alma met', '16977', 'TRUPER', 90.00),
('Juego con 15 de desarmadores de joyero', '14205', 'TRUPER', 249.00),
('Desarmadores de cruz', '14062', 'TRUPER', 130.00),
('Juego de 5 desarmadores', '14137', 'TRUPER', 199.00),
('Escuadra de combinacion', '14380', 'TRUPER', 150.00),
('Esmeril de banco 6 pulgadas', '10937', 'TRUPER', 2100.00),
('Esmeril de banco 3/4', '10938', 'TRUPER', 2800.00),
('Espatulas', '14440', 'TRUPER', 65.00),
('Extensiones', '48044', 'TRUPER', 199.00),
('Cinta larga fibra de vidrio', '1545FV', 'TRUPER', 299.00),
('Linterna 20 LED 2 pilas', '10629', 'TRUPER', 119.00),
('Linterna de aluminio para cabeza', '10620', 'TRUPER', 240.00),
('Linterna de aluminio para cabeza recargable', '10617', 'TRUPER', 399.00),
('Lentes de seguridad', '14252', 'TRUPER', 55.00),
('Llave stillson', '814UR', 'TRUPER', 350.00),
('Llave ajustable profesional', '15497', 'TRUPER', 189.00),
('Juego de 8 llaves hexagonales allen', '15556', 'TRUPER', 150.00),
('llaves de llaves hexagonales L', 'l49822', 'TRUPER', 140.00),
('Marro de acero octagonal', '1435G', 'TRUPER', 220.00),
('Marro octagonal', '16507', 'TRUPER', 269.00),
('Martillos de bola', '16901', 'TRUPER', 210.00),
('Martillos de uña', '16654', 'TRUPER', 195.00),
('Marros octagonales', '16511', 'TRUPER', 299.00),
('Nivel profesional', 'UNT12', 'TRUPER', 199.00),
('Pala redonda', '17150', 'TRUPER', 279.00),
('Pala escarram', '17152', 'TRUPER', 285.00),
('Pala carbonera', '17153', 'TRUPER', 299.00),
('Pala cuadrada', '17161', 'TRUPER', 239.00),
('Talacho-pico', '18631', 'TRUPER', 250.00),
('Talacho-hacha', '18632', 'TRUPER', 250.00),
('Zapapicos', '18646', 'TRUPER', 350.00),
('Juego de machuelos de acero de alta velocidad', '123558', 'GENÉRICO', 1200.00),
('Juego de tarraja para tubos', '123557', 'GENÉRICO', 950.00),
('Rodamientos rigidos de bolas', 'RB9877', 'GENÉRICO', 350.00),
('Rodamientos de bolas a rotula', 'RR9876', 'GENÉRICO', 350.00),
('Rodamientos para husillos', 'RH9875', 'GENÉRICO', 450.00),
('Rodamiento de Rodillos Cilindricos de una Hilera', 'RC9874', 'GENÉRICO', 400.00);

-- Update Productos (Marca)
UPDATE productos p
SET marca = u.marca
FROM product_updates u
WHERE p.nombre = u.nombre;

-- Update Variantes (Codigo Barras, Precio)
UPDATE variantes v
SET codigo_barras = u.codigo_barras,
    precio = u.precio
FROM productos p
JOIN product_updates u ON p.nombre = u.nombre
WHERE v.producto_id = p.id;

DROP TABLE product_updates;
