-- Script to populate Global Catalog with Abarrotes products
-- Date: 2025-11-25
-- Source: User provided list (datos.txt)

INSERT INTO public.global_products (business_type, nombre, marca, descripcion, codigo_barras, imagen_url) VALUES
('abarrotes', 'Papas Fritas Sal de Mar', 'Chips (Barcel)', '58 g / 60 g', '7501000264049', 'https://www.barcel.com.mx/themes/custom/barceldos/images/files/chips-sal-de-mar-v2.png'),
('abarrotes', 'Papas Fritas Fuego', 'Chips (Barcel)', '58 g / 60 g', '7500810024546', 'https://www.barcel.com.mx/themes/custom/barceldos/images/files/chips-fuegov2.png'),
('abarrotes', 'Papas Fritas Adobadas', 'Chips (Barcel)', '58 g / 60 g', '7503028643745', 'https://www.barcel.com.mx/themes/custom/barceldos/images/files/chips-adobadasv2.png'),
('abarrotes', 'Papas Fritas Jalapeño', 'Chips (Barcel)', '58 g / 60 g', '7501000264773', 'https://www.barcel.com.mx/themes/custom/barceldos/images/files/chips-jalapeno-v2.png'),
('abarrotes', 'Takis Fuego', 'Takis (Barcel)', '56 g / 58 g', '7501030424536', 'https://www.barcel.com.mx/themes/custom/barceldos/images/files/takis_fuego.png'),
('abarrotes', 'Takis Original', 'Takis (Barcel)', '56 g', '7501000164370', 'https://www.barcel.com.mx/themes/custom/barceldos/images/files/takis_original.png'),
('abarrotes', 'Takis Huakamoles', 'Takis (Barcel)', '62 g', '7501000148288', 'https://www.barcel.com.mx/themes/custom/barceldos/images/files/takis_huakamole.png'),
('abarrotes', 'Cacahuates Salados', 'Golden Nuts', '40 g / 50 g', '7501000164804', 'https://www.barcel.com.mx/themes/custom/barceldos/images/files/Gold_Nuts_Salado-v2.png'),
('abarrotes', 'Cacahuates Japonés', 'Golden Nuts', '100 g / 120 g', '7501000164880', 'https://www.barcel.com.mx/themes/custom/barceldos/images/files/Gold_Nuts_Japones-v2.png'),
('abarrotes', 'Pepitas Saladas', 'Golden Nuts', '17 g / 25 g', '7501000164828', 'https://www.barcel.com.mx/themes/custom/barceldos/images/files/Gold_Nuts_Pepitas-v2.png'),
('abarrotes', 'Botana Surtida Queso', 'Big Mix (Barcel)', '70 g', '7501000192531', 'https://www.barcel.com.mx/themes/custom/barceldos/images/files/Big_Mix_Queso.png'),
('abarrotes', 'Botana Surtida Clásico', 'Big Mix (Barcel)', '70 g', '7501000167690', 'https://www.barcel.com.mx/themes/custom/barceldos/images/files/Big_Mix_Clasico.png'),
('abarrotes', 'Botana Surtida Fuego', 'Big Mix (Barcel)', '70 g', '7501000192463', 'https://www.barcel.com.mx/themes/custom/barceldos/images/files/Big_Mix_Fuego.png'),
('abarrotes', 'Botana Surtida Party', 'Big Mix (Barcel)', '80 g', '7501000167676', 'https://www.barcel.com.mx/themes/custom/barceldos/images/files/Big_Mix_Party.png'),
('abarrotes', 'Bolitas', 'Cheetos', 'Queso (46 g)', '7500478015047', 'https://www.cheetos.com.mx/storage/img/cheetos-bolitas.webp'),
('abarrotes', 'Poffs', 'Cheetos', 'Queso (42 g)', '7500478014606', 'https://www.cheetos.com.mx/storage/img/cheetos-poffs.webp'),
('abarrotes', 'Flamin'' Hot', 'Cheetos', 'Sabor Flamin'' Hot (52 g)', '7501011143753', 'https://www.cheetos.com.mx/storage/imagenes/productos/yG46Bju1YIDsxnunhrQ09zPVDw8NWpMglMcrKiGD.webp'),
('abarrotes', 'Salsa Verde', 'Tostitos', 'Totopos (62 g / 65 g)', '7501011127012', 'https://www.tostitos.com.mx/storage/imagenes/productos/salsa_verde.jpg'),
('abarrotes', 'Dip Queso Jalapeño', 'Tostitos', 'Dip (255 g, Bote)', '7501011194465', 'https://www.tostitos.com.mx/storage/imagenes/productos/topin_queso_jalapeno.jpg'),
('abarrotes', 'Refresco Coca-Cola Original', 'Coca-Cola', '3 L (Botella)', '7501055301824', 'https://resources.coca-colaentuhogar.com/media/catalog/product/c/o/coccol-orig-nor-pet-2l-1_1.png?quality=100&fit=bounds&height=550&width=550&format=webp'),
('abarrotes', 'Refresco Coca-Cola Original', 'Coca-Cola', '2 L (Botella)', '7501055300605', 'https://resources.coca-colaentuhogar.com/media/catalog/product/c/o/coccol-orig-nor-pet-2l-1_1.png?quality=100&fit=bounds&height=550&width=550&format=webp'),
('abarrotes', 'Refresco Coca-Cola Original', 'Coca-Cola', '600 ml (Botella)', '7501055301305', 'https://resources.coca-colaentuhogar.com/media/catalog/product/c/o/coccol-orig-nor-pet-600ml-4pz_6.png?quality=100&fit=bounds&height=550&width=550&format=webp'),
('abarrotes', 'Refresco Jarritos Mandarina', 'Jarritos', '600 ml (Botella)', '7501441610115', 'https://jarritosmexico.com/wp-content/uploads/2025/07/Mandarina_600.webp'),
('abarrotes', 'Refresco Jarritos Piña', 'Jarritos', '600 ml (Botella)', '7501441610122', 'https://jarritosmexico.com/wp-content/uploads/2025/07/Pina_600.webp'),
('abarrotes', 'Refresco Jarritos Limón', 'Jarritos', '600 ml (Botella)', '7501441610214', 'https://jarritosmexico.com/wp-content/uploads/2025/07/Limon_600.webp'),
('abarrotes', 'Refresco Jarritos Tamarindo', 'Jarritos', '600 ml (Botella)', '7501441610213', 'https://jarritosmexico.com/wp-content/uploads/2025/07/Tamarindo_600.webp'),
('abarrotes', 'Refresco Jarritos Manzana', 'Jarritos', '600 ml (Botella)', '7501441610139', 'https://jarritosmexico.com/wp-content/uploads/2025/07/Manzana_600.webp'),
('abarrotes', 'Refresco Jarritos Uva', 'Jarritos', '600 ml (Botella)', '7501441610146', 'https://jarritosmexico.com/wp-content/uploads/2025/07/Uva_600.webp'),
('abarrotes', 'Refresco Jarritos Tutifruti', 'Jarritos', '600 ml (Botella)', '7501441610153', 'https://jarritosmexico.com/wp-content/uploads/2025/07/Tutifruti_600.webp'),
('abarrotes', 'Refresco Jarritos Mandarina', 'Jarritos', '2 Litros (Botella)', '7501441620114', 'https://jarritosmexico.com/wp-content/uploads/2025/07/Mandarina-2L.webp'),
('abarrotes', 'Refresco Jarritos Limón', 'Jarritos', '2 Litros (Botella)', '7501441620213', 'https://jarritosmexico.com/wp-content/uploads/2025/07/Limon-2L.webp'),
('abarrotes', 'Refresco Jarritos Piña', 'Jarritos', '2 Litros (Botella)', '7501441620121', 'https://jarritosmexico.com/wp-content/uploads/2025/07/Pina-2L.webp'),
('abarrotes', 'Refresco Jarritos Tamarindo', 'Jarritos', '2 Litros (Botella)', '7501441620212', 'https://jarritosmexico.com/wp-content/uploads/2025/07/Tamarindo-2L.webp'),
('abarrotes', 'Refresco Jarritos Manzana', 'Jarritos', '2 Litros (Botella)', '7501441620138', 'https://jarritosmexico.com/wp-content/uploads/2025/07/Manzana-2L.webp'),
('abarrotes', 'Refresco Jarritos Uva', 'Jarritos', '2 Litros (Botella)', '7501441620145', 'https://jarritosmexico.com/wp-content/uploads/2025/07/Uva-2L.webp'),
('abarrotes', 'Refresco Jarritos Tutifruti', 'Jarritos', '2 Litros (Botella)', '7501441620152', 'https://jarritosmexico.com/wp-content/uploads/2025/07/Tutifruti-2L.webp'),
('abarrotes', 'Galletas Clásicas', 'Marías Gamesa', '850 g (Caja)', '7501000625062', 'https://www.gamesacookies.com/sites/gamesa.com/files//2021-09/marias-4-pack.png'),
('abarrotes', 'Galletas Azucaradas', 'Marías Gamesa', '450 g', '7500478035939', 'https://www.gamesacookies.com/sites/gamesa.com/files//2021-09/marias-delux.png'),
('abarrotes', 'Galletas Clásicas', 'Marías Gamesa', '170 g (Rollo)', '7501000658923', 'https://www.gamesacookies.com/sites/gamesa.com/files//2021-11/marias-individual-v3.png'),
('abarrotes', 'Emperador® Vainilla', 'Gamesa', '134 g (Galletas)', '7501000632349', 'https://www.gamesacookies.com/sites/gamesa.com/files//2021-11/emperador-v2.png'),
('abarrotes', 'Emperador® Limón', 'Gamesa', '134 g (Galletas)', '7501000645062', 'https://www.gamesacookies.com/sites/gamesa.com/files//2022-04/emperador-lemon-big-v2.png'),
('abarrotes', 'Barra Quaker® Stila® con relleno sabor Manzana y Canela', 'Quaker®', 'Barras', '750176184798', 'https://quaker.lat/mx/sites/default/files/2023-07/750176184798_720x840.png'),
('abarrotes', 'Barra Quaker® Stila® con relleno sabor Fresa', 'Quaker®', 'Barras', '750176186329', 'https://quaker.lat/mx/sites/default/files/2023-07/750176186329_720x840.png'),
('abarrotes', 'Avena Quaker® 3 Minutos® bote', 'Quaker®', '3 Minutos', '750176181039', 'https://quaker.lat/mx/sites/default/files/2023-07/750176181039_720x840.png')
ON CONFLICT (codigo_barras) DO UPDATE 
SET 
    nombre = EXCLUDED.nombre,
    marca = EXCLUDED.marca,
    descripcion = EXCLUDED.descripcion,
    imagen_url = EXCLUDED.imagen_url;

-- Verification
SELECT COUNT(*) as abarrotes_products FROM global_products WHERE business_type = 'abarrotes';
