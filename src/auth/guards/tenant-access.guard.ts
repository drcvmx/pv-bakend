import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { IS_PUBLIC_KEY } from '../decorators/public.decorator';
import { UserRole } from '../../users/entities/user.entity';

@Injectable()
export class TenantAccessGuard implements CanActivate {
    constructor(private reflector: Reflector) { }

    canActivate(context: ExecutionContext): boolean {
        // Check if route is public
        const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
            context.getHandler(),
            context.getClass(),
        ]);

        if (isPublic) {
            return true; // Skip tenant validation for public routes
        }

        const request = context.switchToHttp().getRequest();
        const user = request.user;
        const requestedTenantId = request.headers['x-tenant-id'] || request.params?.tenantId || request.body?.tenantId;

        if (!user) {
            return false;
        }

        // Super admin puede acceder a cualquier tenant
        if (user.role === UserRole.SUPER_ADMIN) {
            return true;
        }

        // Si no hay tenant solicitado, permitir (se validará en el servicio)
        if (!requestedTenantId) {
            return true;
        }

        // Verificar que el usuario tenga acceso al tenant solicitado
        if (user.tenantId !== requestedTenantId) {
            throw new ForbiddenException('No tienes acceso a este tenant');
        }

        return true;
    }
}
