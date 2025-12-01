import { Controller, Get, Post, Body, UseGuards, Patch, Param } from '@nestjs/common';
import { InventarioService } from './inventario.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { TenantAccessGuard } from '../../auth/guards/tenant-access.guard';
import { Roles } from '../../auth/decorators/roles.decorator';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { TenantId } from '../../common/decorators/tenant.decorator';
import { UserRole } from '../../users/entities/user.entity';
import { RegisterInventoryDto } from './dto/register-inventory.dto';

@Controller('inventario')
@UseGuards(JwtAuthGuard, RolesGuard, TenantAccessGuard)
export class InventarioController {
    constructor(private readonly inventarioService: InventarioService) { }

    @Get()
    @Roles(UserRole.TENANT_ADMIN, UserRole.TENANT_USER)
    getStock(@TenantId() tenantId: string) {
        return this.inventarioService.getStock(tenantId);
    }

    @Post('fisico')
    @Roles(UserRole.TENANT_ADMIN, UserRole.TENANT_USER)
    registerPhysicalCount(
        @TenantId() tenantId: string,
        @CurrentUser() user: any,
        @Body() body: RegisterInventoryDto
    ) {
        return this.inventarioService.registerPhysicalCount(
            tenantId,
            user.sub,
            user.role,
            body.items
        );
    }

    @Get('pendientes')
    @Roles(UserRole.TENANT_ADMIN)
    getPendingChanges(@TenantId() tenantId: string) {
        return this.inventarioService.getPendingChanges(tenantId);
    }

    @Patch('changes/:id/approve')
    @Roles(UserRole.TENANT_ADMIN)
    approveChange(
        @TenantId() tenantId: string,
        @Param('id') id: string,
        @CurrentUser() user: any
    ) {
        return this.inventarioService.approveChange(tenantId, id, user.sub);
    }
}
