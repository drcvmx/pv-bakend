import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserRole } from './entities/user.entity';
import { UserTenantPermission } from './entities/user-tenant-permission.entity';

@Injectable()
export class UsersService {
    constructor(
        @InjectRepository(User)
        private usersRepository: Repository<User>,
        @InjectRepository(UserTenantPermission)
        private permissionsRepository: Repository<UserTenantPermission>,
    ) { }

    async findOne(id: string): Promise<User | null> {
        return this.usersRepository.findOne({
            where: { id },
            relations: ['tenantPermissions'],
        });
    }

    async findByEmail(email: string): Promise<User | null> {
        return this.usersRepository.findOne({
            where: { email },
            relations: ['tenantPermissions'],
        });
    }

    async create(userData: Partial<User>): Promise<User> {
        const user = this.usersRepository.create(userData);
        return this.usersRepository.save(user);
    }

    async updateLastLogin(userId: string): Promise<void> {
        await this.usersRepository.update(userId, {
            lastLoginAt: new Date(),
        });
    }

    async getUserTenantPermissions(userId: string): Promise<UserTenantPermission[]> {
        return this.permissionsRepository.find({
            where: { userId },
        });
    }

    async createTenantPermission(
        userId: string,
        tenantId: string,
        roleInTenant: string,
        permissions: string[] = ['*'],
    ): Promise<UserTenantPermission> {
        const permission = this.permissionsRepository.create({
            userId,
            tenantId,
            roleInTenant,
            permissions,
        });
        return this.permissionsRepository.save(permission);
    }
}
