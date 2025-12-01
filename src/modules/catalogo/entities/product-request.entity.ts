import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

export enum RequestType {
    NEW_PRODUCT = 'NEW_PRODUCT',
    PRICE_CHANGE = 'PRICE_CHANGE',
    STOCK_ADJUSTMENT = 'STOCK_ADJUSTMENT'
}

export enum RequestStatus {
    PENDING = 'PENDING',
    APPROVED = 'APPROVED',
    REJECTED = 'REJECTED'
}

@Entity('product_requests')
export class ProductRequest {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ name: 'tenant_id' })
    tenantId: string;

    @Column({ name: 'user_id' })
    userId: string;

    @Column({
        type: 'enum',
        enum: RequestType,
        default: RequestType.NEW_PRODUCT
    })
    type: RequestType;

    @Column({
        type: 'enum',
        enum: RequestStatus,
        default: RequestStatus.PENDING
    })
    status: RequestStatus;

    @Column('jsonb')
    payload: any;

    @Column({ name: 'admin_notes', type: 'text', nullable: true })
    adminNotes: string;

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;

    @UpdateDateColumn({ name: 'updated_at' })
    updatedAt: Date;
}
