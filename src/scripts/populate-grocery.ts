
import { NestFactory } from '@nestjs/core';
import { AppModule } from '../app.module';
import { CatalogoService } from '../modules/catalogo/catalogo.service';
import { CreateProductoDto } from '../modules/catalogo/dto/create-producto.dto';

const TENANT_ID = 'a1b2c3d4-e5f6-7890-1234-567890abcdef'; // Tienda Don Jose

const products = [
    { nombre: 'Papas Fritas Sal de Mar', marca: 'Chips (Barcel)', codigo: '7501000264049', precio: 18.00, categoria: 'Botanas' },
    { nombre: 'Papas Fritas Fuego', marca: 'Chips (Barcel)', codigo: '7500810024546', precio: 19.50, categoria: 'Botanas' },
    { nombre: 'Papas Fritas Adobadas', marca: 'Chips (Barcel)', codigo: '7503028643745', precio: 18.00, categoria: 'Botanas' },
    { nombre: 'Papas Fritas Jalapeño', marca: 'Chips (Barcel)', codigo: '7501000264773', precio: 19.50, categoria: 'Botanas' },
    { nombre: 'Takis Fuego', marca: 'Takis (Barcel)', codigo: '7501030424536', precio: 21.00, categoria: 'Botanas' },
    { nombre: 'Takis Original', marca: 'Takis (Barcel)', codigo: '7501000164370', precio: 20.00, categoria: 'Botanas' },
    { nombre: 'Takis Huakamoles', marca: 'Takis (Barcel)', codigo: '7501000148288', precio: 22.00, categoria: 'Botanas' },
    { nombre: 'Cacahuates Salados', marca: 'Golden Nuts', codigo: '7501000164804', precio: 17.00, categoria: 'Botanas' },
    { nombre: 'Cacahuates Japonés', marca: 'Golden Nuts', codigo: '7501000164880', precio: 25.00, categoria: 'Botanas' },
    { nombre: 'Pepitas Saladas', marca: 'Golden Nuts', codigo: '7501000164828', precio: 14.00, categoria: 'Botanas' },
    { nombre: 'Botana Surtida Queso', marca: 'Big Mix (Barcel)', codigo: '7501000192531', precio: 24.00, categoria: 'Botanas' },
    { nombre: 'Botana Surtida Clásico', marca: 'Big Mix (Barcel)', codigo: '7501000167690', precio: 24.00, categoria: 'Botanas' },
    { nombre: 'Botana Surtida Fuego', marca: 'Big Mix (Barcel)', codigo: '7501000192463', precio: 25.50, categoria: 'Botanas' },
    { nombre: 'Botana Surtida Party', marca: 'Big Mix (Barcel)', codigo: '7501000167676', precio: 29.00, categoria: 'Botanas' },
    { nombre: 'Bolitas', marca: 'Cheetos', codigo: '7500478015047', precio: 18.00, categoria: 'Botanas' },
    { nombre: 'Poffs', marca: 'Cheetos', codigo: '7500478014606', precio: 17.00, categoria: 'Botanas' },
    { nombre: 'Flamin\' Hot', marca: 'Cheetos', codigo: '7501011143753', precio: 20.00, categoria: 'Botanas' },
    { nombre: 'Salsa Verde', marca: 'Tostitos', codigo: '7501011127012', precio: 21.00, categoria: 'Botanas' },
    { nombre: 'Dip Queso Jalapeño', marca: 'Tostitos', codigo: '7501011194465', precio: 38.00, categoria: 'Salsas' },
    { nombre: 'Refresco Coca-Cola Original (3 L)', marca: 'Coca-Cola', codigo: '7501055301824', precio: 45.00, categoria: 'Bebidas' },
    { nombre: 'Refresco Coca-Cola Original (2 L)', marca: 'Coca-Cola', codigo: '7501055300605', precio: 35.00, categoria: 'Bebidas' },
    { nombre: 'Refresco Coca-Cola Original (600 ml)', marca: 'Coca-Cola', codigo: '7501055301305', precio: 18.00, categoria: 'Bebidas' },
    { nombre: 'Refresco Jarritos Mandarina (600 ml)', marca: 'Jarritos', codigo: '7501441610115', precio: 16.00, categoria: 'Bebidas' },
    { nombre: 'Refresco Jarritos Piña (600 ml)', marca: 'Jarritos', codigo: '7501441610122', precio: 16.00, categoria: 'Bebidas' },
    { nombre: 'Refresco Jarritos Limón (600 ml)', marca: 'Jarritos', codigo: '7501441610214', precio: 16.00, categoria: 'Bebidas' },
    { nombre: 'Refresco Jarritos Mandarina (2 L)', marca: 'Jarritos', codigo: '7501441620114', precio: 30.00, categoria: 'Bebidas' },
    { nombre: 'Refresco Jarritos Piña (2 L)', marca: 'Jarritos', codigo: '7501441620121', precio: 30.00, categoria: 'Bebidas' },
    { nombre: 'Refresco Jarritos Limón (2 L)', marca: 'Jarritos', codigo: '7501441620213', precio: 30.00, categoria: 'Bebidas' },
    { nombre: 'Galletas Clásicas (850 g)', marca: 'Marías Gamesa', codigo: '7501000625062', precio: 55.00, categoria: 'Galletas' },
    { nombre: 'Galletas Azucaradas (450 g)', marca: 'Marías Gamesa', codigo: '7500478035939', precio: 42.00, categoria: 'Galletas' },
    { nombre: 'Emperador® Vainilla (134 g)', marca: 'Gamesa', codigo: '7501000632349', precio: 18.00, categoria: 'Galletas' },
    { nombre: 'Emperador® Limón (134 g)', marca: 'Gamesa', codigo: '7501000645062', precio: 18.00, categoria: 'Galletas' },
    { nombre: 'Barra Quaker® Stila® Manzana/Canela', marca: 'Quaker®', codigo: '750176184798', precio: 15.00, categoria: 'Barras' },
    { nombre: 'Barra Quaker® Stila® Fresa', marca: 'Quaker®', codigo: '750176186329', precio: 15.00, categoria: 'Barras' },
    { nombre: 'Avena Quaker® 3 Minutos® bote', marca: 'Quaker®', codigo: '750176181039', precio: 58.00, categoria: 'Cereales' },
    { nombre: 'Tortillinas® Clásicas (500 g)', marca: 'Tía Rosa', codigo: '7501000103735', precio: 45.00, categoria: 'Panadería' },
    { nombre: 'Tiras Doraditas® (120 g)', marca: 'Tía Rosa', codigo: '7501000105319', precio: 22.00, categoria: 'Panadería' },
];

async function bootstrap() {
    const app = await NestFactory.createApplicationContext(AppModule);
    const catalogoService = app.get(CatalogoService);

    console.log(`🚀 Iniciando población de productos para el tenant: ${TENANT_ID}`);

    for (const prod of products) {
        try {
            // Verificar si ya existe
            const existing = await catalogoService.buscarPorCodigo(TENANT_ID, prod.codigo);
            // Si existe y NO tiene la propiedad isGlobal, es un producto local
            if (existing && !('isGlobal' in existing)) {
                console.log(`⚠️ Producto ya existe: ${prod.nombre} (${prod.codigo})`);
                continue;
            }

            // Buscar en catálogo global para obtener imagen si existe
            const globalProd = await catalogoService.findGlobalByBarcode(prod.codigo);
            const imagenUrl = globalProd?.imagenUrl || undefined;

            const createDto: CreateProductoDto = {
                nombre: prod.nombre,
                marca: prod.marca,
                categoria: prod.categoria,
                proveedor: prod.marca.split(' ')[0], // Simple heurística
                imagenUrl: imagenUrl,
                variantes: [{
                    nombreVariante: 'Presentación Única',
                    precio: prod.precio,
                    costo: prod.precio * 0.7, // Asumimos 30% margen
                    unidadMedida: 'PZA',
                    codigoBarras: prod.codigo,
                    trackStock: true
                }]
            };

            await catalogoService.createProductoConVariantes(TENANT_ID, createDto, 'system-script');
            console.log(`✅ Creado: ${prod.nombre}`);
        } catch (error) {
            console.error(`❌ Error creando ${prod.nombre}:`, error.message);
        }
    }

    console.log('🏁 Población finalizada');
    await app.close();
}

bootstrap();
