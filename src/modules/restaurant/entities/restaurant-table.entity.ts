import { Entity, PrimaryGeneratedColumn, Column, Index, ManyToOne, JoinColumn } from 'typeorm';
import { Tenant } from '../../../tenants/entities/tenant.entity';

@Entity('restaurant_tables')
@Index(['tenantId'])
export class RestaurantTable {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ name: 'tenant_id', type: 'uuid' })
    tenantId: string;

    @ManyToOne(() => Tenant, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'tenant_id' })
    tenant: Tenant;

    @Column({ name: 'table_number' })
    tableNumber: number;

    @Column()
    seats: number;

    @Column({ default: 'available' })
    status: string; // 'available' | 'occupied' | 'reserved'

    @Column({ name: 'created_at', type: 'timestamp', default: () => 'NOW()' })
    createdAt: Date;
}
