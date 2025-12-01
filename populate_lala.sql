INSERT INTO public.global_products (nombre, descripcion, imagen_url, codigo_barras, categoria, marca, business_type) VALUES
('Leche Entera UHT', 'Envase de 1 Litro, Ultra Pasteurizada', 'https://www.lala.com.mx/storage/app/media/7501020565935_00.png', '7501020565935', 'Lácteos', 'Lala', 'retail'),
('Leche Deslactosada UHT', 'Envase de 1 Litro, Baja en Grasa', 'https://www.lala.com.mx/storage/app/media/Prodcutos/leches/uht-deslactosada/1l/7501020565911_00.png', '7501020515398', 'Lácteos', 'Lala', 'retail'),
('Yogurt Griego Natural Zero', 'Vaso de 120 gramos, Sin Azúcar Añadida', 'https://www.lala.com.mx/storage/app/media/Prodcutos/75071530_00.png', '7501020541793', 'Lácteos', 'Lala', 'retail')
ON CONFLICT (codigo_barras) DO NOTHING;
