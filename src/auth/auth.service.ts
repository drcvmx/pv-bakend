import { Injectable, UnauthorizedException, ConflictException, BadRequestException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { UsersService } from '../users/users.service';
import { User, UserRole } from '../users/entities/user.entity';
import { RegisterDto } from './dto/register.dto';

@Injectable()
export class AuthService {
    constructor(
        private usersService: UsersService,
        private jwtService: JwtService,
        private dataSource: DataSource,
    ) { }

    async validateUser(email: string, password: string): Promise<any> {
        const user = await this.usersService.findByEmail(email);

        console.log('🔍 Login attempt:', { email, userFound: !!user, isActive: user?.isActive });

        if (!user || !user.isActive) {
            console.log('❌ User not found or inactive');
            return null;
        }

        const isPasswordValid = await bcrypt.compare(password, user.passwordHash);
        console.log('🔑 Password check:', {
            provided: password,
            hashStarts: user.passwordHash.substring(0, 20),
            isValid: isPasswordValid
        });

        if (!isPasswordValid) {
            console.log('❌ Invalid password');
            return null;
        }

        console.log('✅ Login successful');
        // No retornar el password hash
        const { passwordHash, ...result } = user;
        return result;
    }

    async login(user: User) {
        // Actualizar último login
        await this.usersService.updateLastLogin(user.id);

        // Construir payload del JWT
        let payload: any = {
            sub: user.id,
            email: user.email,
            role: user.role,
        };

        // Si es super admin, tiene acceso global
        if (user.role === UserRole.SUPER_ADMIN) {
            payload.permissions = ['*'];
            payload.tenantId = null;
        } else {
            // Obtener permisos del tenant
            const permissions = await this.usersService.getUserTenantPermissions(user.id);

            if (!permissions || permissions.length === 0) {
                throw new UnauthorizedException('Usuario sin permisos de tenant');
            }

            // Por ahora asumimos que un usuario solo tiene un tenant
            // En el futuro se podría permitir múltiples tenants
            const permission = permissions[0];

            // Obtener información del tenant desde la DB
            const tenantResult = await this.dataSource.query(
                'SELECT nombre FROM tenants WHERE id = $1',
                [permission.tenantId],
            );

            payload.tenantId = permission.tenantId;
            payload.tenantName = tenantResult[0]?.nombre || 'Desconocido';
            payload.roleInTenant = permission.roleInTenant;
            payload.permissions = permission.permissions || [];
        }

        const access_token = this.jwtService.sign(payload);

        return {
            access_token,
            user: {
                id: user.id,
                email: user.email,
                firstName: user.firstName,
                lastName: user.lastName,
                role: user.role,
                tenantId: payload.tenantId,
                tenantName: payload.tenantName,
            },
        };
    }

    async register(registerDto: RegisterDto) {
        // Verificar si el email ya existe
        const existingUser = await this.usersService.findByEmail(registerDto.email);
        if (existingUser) {
            throw new ConflictException('El email ya está registrado');
        }

        // Usar transacción para crear usuario y tenant
        const queryRunner = this.dataSource.createQueryRunner();
        await queryRunner.connect();
        await queryRunner.startTransaction();

        try {
            // 1. Hashear contraseña
            const passwordHash = await bcrypt.hash(registerDto.password, 10);

            // 2. Crear usuario
            const user = await this.usersService.create({
                email: registerDto.email,
                passwordHash,
                firstName: registerDto.firstName,
                lastName: registerDto.lastName,
                role: UserRole.TENANT_ADMIN,
                isActive: true,
                emailVerified: false, // TODO: Implementar verificación de email
            });

            // 3. Crear tenant
            const tenantResult = await queryRunner.query(
                `INSERT INTO tenants (nombre, tipo_negocio, owner_user_id) 
         VALUES ($1, $2, $3) 
         RETURNING id, nombre`,
                [registerDto.businessName, registerDto.businessType, user.id],
            );

            const tenant = tenantResult[0];

            // 4. Crear permiso de usuario-tenant
            await this.usersService.createTenantPermission(
                user.id,
                tenant.id,
                'admin',
                ['*'], // Admin del tenant tiene todos los permisos
            );

            await queryRunner.commitTransaction();

            // 5. Login automático después del registro
            return this.login(user);
        } catch (error) {
            await queryRunner.rollbackTransaction();
            throw new BadRequestException('Error al crear la cuenta: ' + error.message);
        } finally {
            await queryRunner.release();
        }
    }

    async validateToken(token: string) {
        try {
            const payload = this.jwtService.verify(token);
            return payload;
        } catch (error) {
            throw new UnauthorizedException('Token inválido o expirado');
        }
    }
}
