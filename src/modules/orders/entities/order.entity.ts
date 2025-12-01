import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
import { Tenant } from '../../../tenants/entities/tenant.entity';
import { OrderItem } from './order-item.entity';

export enum OrderStatus {
    PENDING = 'pending_payment',
    PAID = 'paid',
    COMPLETED = 'completed', // Entregado
    FAILED = 'failed'
}

@Entity('orders')
export class Order {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    // Vital para tu SaaS: saber a qué tienda pertenece esta orden
    @Column({ name: 'tenant_id', type: 'uuid' })
    @Index()
    tenantId: string;

    @ManyToOne(() => Tenant, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'tenant_id' })
    tenant: Tenant;

    @Column({ name: 'store_id', type: 'int', nullable: true })
    storeId: number; // ID numérico interno de la sucursal

    @Column({ name: 'customer_email', nullable: true })
    customerEmail: string;

    @Column({ name: 'customer_name', nullable: true })
    customerName: string;

    @Column('decimal', { name: 'total_amount', precision: 10, scale: 2 })
    totalAmount: number;

    // Índice único para buscar rápido cuando llegue el Webhook
    @Index({ unique: true })
    @Column({ name: 'stripe_payment_intent_id', nullable: true })
    stripePaymentIntentId: string;

    @Column({
        type: 'enum',
        enum: OrderStatus,
        default: OrderStatus.PENDING
    })
    status: OrderStatus;

    // Código corto para recoger (ej: "A4F9")
    @Column({ name: 'collection_code', nullable: true })
    collectionCode: string;

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;

    @OneToMany(() => OrderItem, (item) => item.order, { cascade: true })
    items: OrderItem[];
}
