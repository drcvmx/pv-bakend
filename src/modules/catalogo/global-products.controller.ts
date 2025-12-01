import { Controller, Get, Post, Body, Query, Param, UseGuards } from '@nestjs/common';
import { CatalogoService } from './catalogo.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { TenantId } from '../../common/decorators/tenant.decorator';

@Controller('catalogo/global')
@UseGuards(JwtAuthGuard)
export class GlobalProductsController {
    constructor(private readonly catalogoService: CatalogoService) { }

    /**
     * GET /catalogo/global
     * Obtener todos los productos del catálogo global
     * Query params:
     * - businessType: Filtrar por tipo de negocio (opcional)
     */
    @Get()
    async getAllGlobalProducts(
        @Query('businessType') businessType?: string
    ) {
        return this.catalogoService.findAllGlobalProducts(businessType);
    }

    /**
     * GET /catalogo/global/search
     * Buscar productos en el catálogo global
     * Query params:
     * - barcode: Buscar por código de barras
     * - q: Buscar por texto (nombre, marca, categoría)
     * - businessType: Filtrar por tipo de negocio
     */
    @Get('search')
    async searchGlobalProducts(
        @Query('barcode') barcode?: string,
        @Query('q') query?: string,
        @Query('businessType') businessType?: string
    ) {
        console.log('🔍 Global Search Request:', { barcode, query, businessType });

        // Prioridad: barcode > query
        if (barcode) {
            console.log('🔍 Searching by barcode:', barcode);
            const product = await this.catalogoService.findGlobalByBarcode(barcode);
            console.log('🔍 Found product:', product);
            return product || null;
        }

        if (query) {
            console.log('🔍 Searching by query:', query);
            return this.catalogoService.searchGlobalProducts(query, businessType);
        }

        // Si no hay parámetros, devolver lista limitada
        console.log('🔍 Returning all global products');
        return this.catalogoService.findAllGlobalProducts(businessType);
    }

    /**
     * GET /catalogo/global/:id
     * Obtener un producto del catálogo global por ID
     */
    @Get(':id')
    async getGlobalProductById(@Param('id') id: string) {
        return this.catalogoService.findGlobalById(id);
    }

    /**
     * POST /catalogo/from-global
     * Crear un producto local desde el catálogo global
     */
    @Post('/from-global')
    async createFromGlobal(
        @TenantId() tenantId: string,
        @Body() dto: {
            globalProductId: string;
            precioBase: number;
            costo?: number;
            unidadMedida?: string;
            nombreVariante?: string;
        }
    ) {
        return this.catalogoService.createProductFromGlobal(
            tenantId,
            dto.globalProductId,
            dto.precioBase,
            dto.costo,
            dto.unidadMedida,
            dto.nombreVariante
        );
    }
}
