import { Controller, Get, Post, Delete, Patch, Query, Body, Param, UsePipes, ValidationPipe, UseGuards } from '@nestjs/common';
import { CatalogoService } from './catalogo.service';
import { TenantId } from '../../common/decorators/tenant.decorator';
import { CreateProductoDto } from './dto/create-producto.dto';
import { UpdateProductoDto } from './dto/update-producto.dto';
import { RegistroRapidoDto } from './dto/registro-rapido.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { TenantAccessGuard } from '../../auth/guards/tenant-access.guard';
import { Roles } from '../../auth/decorators/roles.decorator';
import { UserRole } from '../../users/entities/user.entity';
import { Public } from '../../auth/decorators/public.decorator';
import { RequestType } from './entities/product-request.entity';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';

@Controller('catalogo')
@UseGuards(JwtAuthGuard, RolesGuard, TenantAccessGuard)
export class CatalogoController {
    constructor(private readonly catalogoService: CatalogoService) { }

    @Public()
    @Get()
    getAllProducts(@TenantId() tenantId: string) {
        return this.catalogoService.getAllProducts(tenantId);
    }

    @Get('search')
    search(@TenantId() tenantId: string, @Query('q') query: string) {
        return this.catalogoService.search(tenantId, query);
    }

    @Post('productos')
    @Roles(UserRole.SUPER_ADMIN, UserRole.TENANT_ADMIN)
    @UsePipes(new ValidationPipe({ transform: true }))
    createProducto(
        @TenantId() tenantId: string,
        @CurrentUser() user: any,
        @Body() createProductoDto: CreateProductoDto
    ) {
        return this.catalogoService.createProductoConVariantes(tenantId, createProductoDto, user.sub);
    }

    @Patch('productos/:id')
    @Roles(UserRole.SUPER_ADMIN, UserRole.TENANT_ADMIN)
    @UsePipes(new ValidationPipe({ transform: true }))
    updateProducto(
        @TenantId() tenantId: string,
        @Param('id') id: string,
        @CurrentUser() user: any,
        @Body() updateProductoDto: UpdateProductoDto
    ) {
        return this.catalogoService.updateProducto(id, tenantId, updateProductoDto, user.sub);
    }

    @Delete('productos/:id')
    @Roles(UserRole.SUPER_ADMIN, UserRole.TENANT_ADMIN)
    deleteProducto(
        @TenantId() tenantId: string,
        @Param('id') id: string,
        @CurrentUser() user: any
    ) {
        return this.catalogoService.deleteProducto(id, tenantId, user.sub);
    }

    @Get('buscar-codigo')
    @Roles(UserRole.TENANT_ADMIN, UserRole.TENANT_USER)
    buscarPorCodigo(
        @TenantId() tenantId: string,
        @Query('codigo') codigo: string
    ) {
        return this.catalogoService.buscarPorCodigo(tenantId, codigo);
    }

    @Post('registro-rapido')
    @Roles(UserRole.SUPER_ADMIN, UserRole.TENANT_ADMIN, UserRole.TENANT_USER)
    @UsePipes(new ValidationPipe({ transform: true }))
    registroRapido(
        @TenantId() tenantId: string,
        @Body() registroRapidoDto: RegistroRapidoDto
    ) {
        return this.catalogoService.registroRapido(tenantId, registroRapidoDto);
    }

    // --- GLOBAL CATALOG & REQUESTS ---



    @Post('requests')
    @Roles(UserRole.TENANT_USER, UserRole.TENANT_ADMIN)
    createRequest(
        @TenantId() tenantId: string,
        @CurrentUser() user: any,
        @Body() body: { type: RequestType; payload: any }
    ) {
        return this.catalogoService.createRequest(tenantId, user.sub, body.type, body.payload);
    }

    @Get('requests')
    @Roles(UserRole.TENANT_ADMIN)
    getRequests(@TenantId() tenantId: string) {
        return this.catalogoService.getRequests(tenantId);
    }

    @Post('requests/:id/approve')
    @Roles(UserRole.TENANT_ADMIN)
    approveRequest(
        @TenantId() tenantId: string,
        @Param('id') id: string,
        @CurrentUser() user: any
    ) {
        return this.catalogoService.approveRequest(tenantId, id, user.sub);
    }
}
