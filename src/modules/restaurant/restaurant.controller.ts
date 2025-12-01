import { Controller, Get, Post, Patch, Body, Param, UsePipes, ValidationPipe, UseGuards } from '@nestjs/common';
import { RestaurantService } from './restaurant.service';
import { TenantId } from '../../common/decorators/tenant.decorator';
import { BulkCreateTablesDto, UpdateTableStatusDto } from './dto/restaurant-table.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { TenantAccessGuard } from '../../auth/guards/tenant-access.guard';
import { Roles } from '../../auth/decorators/roles.decorator';
import { UserRole } from '../../users/entities/user.entity';

@Controller('restaurant')
@UseGuards(JwtAuthGuard, RolesGuard, TenantAccessGuard)
export class RestaurantController {
    constructor(private readonly restaurantService: RestaurantService) { }

    /**
     * Obtener todas las mesas del restaurante
     * GET /restaurant/tables
     */
    @Get('tables')
    getTables(@TenantId() tenantId: string) {
        return this.restaurantService.getTables(tenantId);
    }

    /**
     * Configuración inicial de mesas (setup wizard)
     * POST /restaurant/tables/setup
     * Body: { tables: [{ seats: 4, count: 5 }, { seats: 6, count: 2 }] }
     */
    @Post('tables/setup')
    @Roles(UserRole.SUPER_ADMIN, UserRole.TENANT_ADMIN)
    @UsePipes(new ValidationPipe({ transform: true }))
    bulkCreateTables(
        @TenantId() tenantId: string,
        @Body() dto: BulkCreateTablesDto
    ) {
        return this.restaurantService.bulkCreateTables(tenantId, dto);
    }

    /**
     * Actualizar estado de una mesa
     * PATCH /restaurant/tables/:id/status
     * Body: { status: 'occupied' }
     */
    @Patch('tables/:id/status')
    updateTableStatus(
        @TenantId() tenantId: string,
        @Param('id') id: string,
        @Body() dto: UpdateTableStatusDto
    ) {
        return this.restaurantService.updateTableStatus(id, tenantId, dto.status);
    }

    /**
     * Obtener mesa por ID
     * GET /restaurant/tables/:id
     */
    @Get('tables/:id')
    getTableById(
        @TenantId() tenantId: string,
        @Param('id') id: string
    ) {
        return this.restaurantService.getTableById(id, tenantId);
    }

    /**
     * Obtener estadísticas de mesas
     * GET /restaurant/stats
     */
    @Get('stats')
    getStats(@TenantId() tenantId: string) {
        return this.restaurantService.getTableStats(tenantId);
    }
}
