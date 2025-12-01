import { Entity, PrimaryGeneratedColumn, Column, OneToMany, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { Exclude } from 'class-transformer';
import { UserTenantPermission } from './user-tenant-permission.entity';

export enum UserRole {
    SUPER_ADMIN = 'super_admin',
    TENANT_ADMIN = 'tenant_admin',
    TENANT_USER = 'tenant_user',
}

@Entity('users')
export class User {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ unique: true, length: 255 })
    email: string;

    @Column({ name: 'password_hash', length: 255 })
    @Exclude() // No exponer en respuestas JSON automáticamente
    passwordHash: string;

    @Column({ name: 'first_name', length: 100, nullable: true })
    firstName: string;

    @Column({ name: 'last_name', length: 100, nullable: true })
    lastName: string;

    @Column({
        type: 'varchar',
        length: 50,
        enum: UserRole,
    })
    role: UserRole;

    @Column({ name: 'is_active', default: true })
    isActive: boolean;

    @Column({ name: 'email_verified', default: false })
    emailVerified: boolean;

    @OneToMany(() => UserTenantPermission, (permission) => permission.user)
    tenantPermissions: UserTenantPermission[];

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;

    @UpdateDateColumn({ name: 'updated_at' })
    updatedAt: Date;

    @Column({ name: 'last_login_at', type: 'timestamp', nullable: true })
    lastLoginAt: Date;

    // Computed property para nombre completo
    get fullName(): string {
        return `${this.firstName || ''} ${this.lastName || ''}`.trim();
    }
}
