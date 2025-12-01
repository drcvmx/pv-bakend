-- Script para actualizar productos de "API PARA LA INDUSTRIA"
-- Fecha: 2025-11-24
-- Acción: Borrar productos existentes e insertar catálogo real

-- 1. Borrar productos existentes de API PARA LA INDUSTRIA
DELETE FROM inventario 
WHERE tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

DELETE FROM variantes 
WHERE tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

DELETE FROM productos 
WHERE tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- 2. Insertar productos reales con imágenes de API México
INSERT INTO productos (tenant_id, nombre, descripcion, imagen_url) VALUES
-- Arcos y Sierras
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Arco junior', 'Modelo: 10210. Color: AJ-6', 'https://www.apimexico.com.mx/img/herramientas/10210.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Arco profecional', 'Modelo: 10230. Ajustable de solera de acero niquelado. Color: APT-12', 'https://www.apimexico.com.mx/img/herramientas/10230.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Arco industrial de aluminio', 'Modelo: 10251. Con mango de TPR. Color: ATI-12', 'https://www.apimexico.com.mx/img/herramientas/10251.png'),

-- Arnés
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'ARNES TRUPER', 'Modelo: 14433. 3 ANILLOS. Color: ARN-5437', 'https://www.apimexico.com.mx/img/herramientas/14433.png'),

-- Barretas
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Barreta de punta', 'Modelo: 10759. Para terrenos duros 1" x 150 cm. Color: BAP-150E', 'https://www.apimexico.com.mx/img/herramientas/10759.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Barretas', 'Modelo: 10850. Color: BU-30', 'https://www.apimexico.com.mx/img/herramientas/10850.png'),

-- Cinceles
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cincel', 'Modelo: 12163. TRUPER, 1" X 10". Color: C-1X10', 'https://www.apimexico.com.mx/img/herramientas/12163.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cincel ladrillero', 'Modelo: 12184. TRUPER LADRILLERO, 2 3/4" X 10". Color: CL-2-3/4X10', 'https://www.apimexico.com.mx/img/herramientas/12184.png'),

-- Cinchos
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cincho plastico', 'Modelo: 44308. Color: CIN-5030', 'https://www.apimexico.com.mx/img/herramientas/44308.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cincho plastico Truper', 'Modelo: 44301. Cincho truper de plastico. Color: CIN-1815', 'https://www.apimexico.com.mx/img/herramientas/44301.png'),

-- Cintas
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cinta de amarre', 'Modelo: 12322. 30 m. Color: BIMBO-30', 'https://www.apimexico.com.mx/img/herramientas/12322.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cinta de montaje', 'Modelo: 12540. 2.28 m. Color: CMT-228', 'https://www.apimexico.com.mx/img/herramientas/12540.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Despachador de cinta', 'Modelo: 12559. Incluye dos rollos de cinta. Color: DESP-CE', 'https://www.apimexico.com.mx/img/herramientas/12559.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cinta Ducto Plata', 'Modelo: 12611. 48mm x 50m. Color: Plata', 'https://www.apimexico.com.mx/img/herramientas/12611.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cinta de aislar Negro', 'Modelo: 20521. Utilizada en el amarre de bobinas. Color: Negro', 'https://www.apimexico.com.mx/img/herramientas/20521.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cinta Doble Cara Poli', 'Modelo: 12502. Transparente con adhesivo en ambas caras. Color: Transparente', 'https://www.apimexico.com.mx/img/herramientas/12502.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cintas masking', 'Modelo: 12503. Uso industrial para empalmes, embalajes, etc. Color: Blanca', 'https://www.apimexico.com.mx/img/herramientas/12503.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cinta adhesiva de polipropileno transparente', 'Modelo: 12504. Gran utilidad en el hogar, oficina y escuela. Color: Transparente', 'https://www.apimexico.com.mx/img/herramientas/12504.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cinta canela de empaque marca janel', 'Modelo: 12550. Canela, 48mm x 150 mts. Color: Canela', 'https://www.apimexico.com.mx/img/herramientas/12550.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cinta transparente de empaque marca janel', 'Modelo: 12551. 48 mm x 150 mts. Color: Transparente', 'https://www.apimexico.com.mx/img/herramientas/12551.png'),

-- Cutters
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cutter con alma metalica', 'Modelo: 16976. Color: CUT-6XX', 'https://www.apimexico.com.mx/img/herramientas/16976.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cutter profesional con alma met', 'Modelo: 16977. Color: CUT-6X', 'https://www.apimexico.com.mx/img/herramientas/16977.png'),

-- Desarmadores
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Juego con 15 de desarmadores de joyero', 'Modelo: 14205. Para electronica y trabajos de precision. Color: JOY-15', 'https://www.apimexico.com.mx/img/herramientas/14205.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Desarmadores de cruz', 'Modelo: 14062. Truper, mango de acetato, puntas magneticas. Color: DP-3/16X3', 'https://www.apimexico.com.mx/img/herramientas/14062.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Juego de 5 desarmadores', 'Modelo: 14137. Mango de acetato. Color: DTJ-5', 'https://www.apimexico.com.mx/img/herramientas/14137.png'),

-- Escuadra
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Escuadra de combinacion', 'Modelo: 14380. Cuerpo de inyeccion', 'https://www.apimexico.com.mx/img/herramientas/14380.png'),

-- Esmeriles
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Esmeril de banco 6 pulgadas', 'Modelo: 10937. 6 pulgadas, 1/2 HP potencia nominal. Color: EBA-650', 'https://www.apimexico.com.mx/img/herramientas/10937.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Esmeril de banco 3/4', 'Modelo: 10938. 3/4 COD-10938. Color: EBA-875', 'https://www.apimexico.com.mx/img/herramientas/10938.png'),

-- Espátulas y Extensiones
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Espatulas', 'Modelo: 14440. Color: ET-1R', 'https://www.apimexico.com.mx/img/herramientas/14440.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Extensiones', 'Modelo: 48044. Color: ER-6X16', 'https://www.apimexico.com.mx/img/herramientas/48044.png'),

-- Cinta métrica
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Cinta larga fibra de vidrio', 'Modelo: 1545FV. Doble vista en cm y pulgadas. Color: Rojo', 'https://www.apimexico.com.mx/img/herramientas/1545FV.png'),

-- Linternas
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Linterna 20 LED 2 pilas', 'Modelo: 10629. Bajo consumo de energia. Color: Negra', 'https://www.apimexico.com.mx/img/herramientas/10629.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Linterna de aluminio para cabeza', 'Modelo: 10620. 3 AAA, 100 lumenes. Color: LI-CA-120', 'https://www.apimexico.com.mx/img/herramientas/10620.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Linterna de aluminio para cabeza recargable', 'Modelo: 10617. 60 lumenes. Color: LI-CA-60R', 'https://www.apimexico.com.mx/img/herramientas/10617.png'),

-- Lentes
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Lentes de seguridad', 'Modelo: 14252. Tradicionales, transparente. Color: LEN-ST', 'https://www.apimexico.com.mx/img/herramientas/14252.png'),

-- Llaves
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Llave stillson', 'Modelo: 814UR. Acero cromovanadio', 'https://www.apimexico.com.mx/img/herramientas/814UR.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Llave ajustable profesional', 'Modelo: 15497. (Perico) pavonada 4, 6, 8, 10, 12, 15, y 24 pulgadas. Color: PET-4', 'https://www.apimexico.com.mx/img/herramientas/15497.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Juego de 8 llaves hexagonales allen', 'Modelo: 15556. Tipo navaja. Color: ALL-8P', 'https://www.apimexico.com.mx/img/herramientas/15556.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'llaves de llaves hexagonales L', 'Modelo: l49822. Acero tratado termicamente', 'https://www.apimexico.com.mx/img/herramientas/l49822.png'),

-- Marros
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Marro de acero octagonal', 'Modelo: 1435G. Cara de golpeo biselada y pulida', 'https://www.apimexico.com.mx/img/herramientas/1435G.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Marro octagonal', 'Modelo: 16507. Mango 12, 3 Lb. Color: MD-3M', 'https://www.apimexico.com.mx/img/herramientas/16507.png'),

-- Martillos
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Martillos de bola', 'Modelo: 16901. Disponible de 4 a 48 oz. Color: MB-12', 'https://www.apimexico.com.mx/img/herramientas/16901.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Martillos de uña', 'Modelo: 16654. Martillo pulido de uña. Color: MO-16', 'https://www.apimexico.com.mx/img/herramientas/16654.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Marros octagonales', 'Modelo: 16511', 'https://www.apimexico.com.mx/img/herramientas/16511.png'),

-- Nivel
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Nivel profesional', 'Modelo: UNT12. Acanalado tipo V, 3 burbujas. Color: Rojo', 'https://www.apimexico.com.mx/img/herramientas/UNT12.png'),

-- Palas
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Pala redonda', 'Modelo: 17150. Puno Y con mango de fibra de vidrio. Color: PRY-F', 'https://www.apimexico.com.mx/img/herramientas/17150.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Pala escarram', 'Modelo: 17152. Puno Y, mango de fibra de vidrio. Color: PES-F', 'https://www.apimexico.com.mx/img/herramientas/17152.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Pala carbonera', 'Modelo: 17153. Puno Y, con mando de fibra de vidrio. Color: PCAY-F', 'https://www.apimexico.com.mx/img/herramientas/17153.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Pala cuadrada', 'Modelo: 17161. Puno Y mango, T-2000. Color: PCY-P', 'https://www.apimexico.com.mx/img/herramientas/17161.png'),

-- Talachos y Zapapicos
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Talacho-pico', 'Modelo: 18631. 2.5 lb. Color: TP-2.5M', 'https://www.apimexico.com.mx/img/herramientas/18631.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Talacho-hacha', 'Modelo: 18632. 2.5 lb. Color: TH-2.5M', 'https://www.apimexico.com.mx/img/herramientas/18632.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Zapapicos', 'Modelo: 18646. 7 lb. Color: ZP-5MX', 'https://www.apimexico.com.mx/img/herramientas/18646.png'),

-- Machuelos y Tarrajas
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Juego de machuelos de acero de alta velocidad', 'Modelo: 123558. Contiene uno recto, semiconico y conico. Color: Plata', 'https://www.apimexico.com.mx/img/herramientas/123558.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Juego de tarraja para tubos', 'Modelo: 123557. Incluye portafolio. Color: Plata', 'https://www.apimexico.com.mx/img/herramientas/123557.png'),

-- Rodamientos
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Rodamientos rigidos de bolas', 'Modelo: RB9877. Simples, alta velocidad, resistentes', 'https://www.apimexico.com.mx/img/herramientas/RB9877.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Rodamientos de bolas a rotula', 'Modelo: RR9876. Autoalineables', 'https://www.apimexico.com.mx/img/herramientas/RR9876.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Rodamientos para husillos', 'Modelo: RH9875. Disponibles abiertos y obturados', 'https://www.apimexico.com.mx/img/herramientas/RH9875.png'),
('f8e9d7c6-5b4a-3210-9876-fedcba098765', 'Rodamiento de Rodillos Cilindricos de una Hilera', 'Modelo: RC9874. Para cargas radiales y axiales', 'https://www.apimexico.com.mx/img/herramientas/RC9874.png');

-- 3. Crear variantes con precio de $1.00 para todos los productos
INSERT INTO variantes (tenant_id, producto_id, nombre_variante, precio, costo, unidad_medida, track_stock)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    id,
    'Unidad',
    1.00,
    1.00,
    'PZA',
    true
FROM productos 
WHERE tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- 4. Crear inventario inicial con 100 unidades de cada producto
INSERT INTO inventario (tenant_id, variante_id, sucursal_id, cantidad, ubicacion)
SELECT 
    'f8e9d7c6-5b4a-3210-9876-fedcba098765',
    v.id,
    1,
    100,
    'Almacén Principal'
FROM variantes v
WHERE v.tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';

-- Verificación final
SELECT 
    'API PARA LA INDUSTRIA' as ferreteria,
    COUNT(DISTINCT p.id) as total_productos,
    COUNT(DISTINCT v.id) as total_variantes,
    SUM(i.cantidad) as total_items_inventario
FROM productos p
LEFT JOIN variantes v ON p.id = v.producto_id
LEFT JOIN inventario i ON v.id = i.variante_id
WHERE p.tenant_id = 'f8e9d7c6-5b4a-3210-9876-fedcba098765';
