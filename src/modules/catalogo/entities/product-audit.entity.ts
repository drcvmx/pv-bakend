import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { User } from '../../../users/entities/user.entity';

@Entity('product_audits')
export class ProductAudit {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ name: 'product_id' })
    productId: string;

    @Column({ name: 'tenant_id' })
    tenantId: string;

    @Column({ name: 'user_id' })
    userId: string;

    @ManyToOne(() => User)
    @JoinColumn({ name: 'user_id' })
    user: User;

    @Column({ length: 50 })
    action: 'CREATE' | 'UPDATE' | 'DELETE';

    @Column({ type: 'jsonb', nullable: true })
    changes: any;

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;
}
