import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn, Index } from 'typeorm';
import { User } from './user.entity';
import { Tenant } from '../../tenants/entities/tenant.entity';

@Entity('user_tenant_permissions')
@Index(['userId', 'tenantId'], { unique: true })
export class UserTenantPermission {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ name: 'user_id' })
    userId: string;

    @ManyToOne(() => User, (user) => user.tenantPermissions, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'user_id' })
    user: User;

    @Column({ name: 'tenant_id', type: 'uuid', nullable: true })
    tenantId: string;

    @ManyToOne(() => Tenant, { nullable: true, onDelete: 'CASCADE' })
    @JoinColumn({ name: 'tenant_id' })
    tenant: Tenant;

    // No creamos relación con Tenant aquí para evitar dependencia circular
    // La relación se maneja a nivel de aplicación

    @Column({ name: 'role_in_tenant', length: 50 })
    roleInTenant: string; // 'admin', 'cashier', 'manager', 'inventory_manager', 'viewer'

    @Column({ type: 'jsonb', default: '[]' })
    permissions: string[]; // Array de permisos como ['products.read', 'sales.create']

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;

    @Column({ name: 'created_by_user_id', nullable: true })
    createdByUserId: string;

    @ManyToOne(() => User, { nullable: true })
    @JoinColumn({ name: 'created_by_user_id' })
    createdBy: User;
}
