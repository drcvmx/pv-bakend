import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Order } from './order.entity';
import { Variante } from '../../catalogo/entities/variante.entity';

@Entity('order_items')
export class OrderItem {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ name: 'order_id', type: 'uuid' })
    orderId: string;

    @ManyToOne(() => Order, (order) => order.items, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'order_id' })
    order: Order;

    @Column({ name: 'variant_id', type: 'bigint', nullable: true })
    variantId: string;

    @ManyToOne(() => Variante, { nullable: true })
    @JoinColumn({ name: 'variant_id' })
    variant: Variante;

    @Column({ name: 'product_name' })
    productName: string;

    @Column('int')
    quantity: number;

    @Column('decimal', { precision: 10, scale: 2 })
    price: number;

    @Column('decimal', { precision: 10, scale: 2 })
    subtotal: number;
}
