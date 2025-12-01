import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn, Index } from 'typeorm';
import { Variante } from '../../catalogo/entities/variante.entity';
import { User } from '../../../users/entities/user.entity';

export enum InventoryChangeType {
    COUNT = 'count',           // Conteo físico
    ADJUSTMENT = 'adjustment', // Ajuste manual
    ENTRY = 'entry',          // Entrada de mercancía
    EXIT = 'exit',            // Salida/merma
}

export enum InventoryChangeStatus {
    PENDING = 'pending',
    APPROVED = 'approved',
    REJECTED = 'rejected',
}

@Entity('inventory_changes')
@Index(['tenantId', 'status'])
export class InventoryChange {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ name: 'tenant_id' })
    tenantId: string;

    @Column({ name: 'variante_id', type: 'bigint' })
    varianteId: string;

    @ManyToOne(() => Variante)
    @JoinColumn({ name: 'variante_id' })
    variante: Variante;

    @Column({ name: 'sucursal_id', nullable: true })
    sucursalId: number;

    @Column({ name: 'created_by_user_id' })
    createdByUserId: string;

    @ManyToOne(() => User)
    @JoinColumn({ name: 'created_by_user_id' })
    createdBy: User;

    @Column({
        name: 'change_type',
        type: 'varchar',
        length: 50,
        enum: InventoryChangeType,
    })
    changeType: InventoryChangeType;

    @Column({
        name: 'cantidad_anterior',
        type: 'decimal',
        precision: 10,
        scale: 4,
        nullable: true,
    })
    cantidadAnterior: number;

    @Column({
        name: 'cantidad_nueva',
        type: 'decimal',
        precision: 10,
        scale: 4,
    })
    cantidadNueva: number;

    @Column({
        type: 'decimal',
        precision: 10,
        scale: 4,
    })
    diferencia: number;

    @Column({
        type: 'varchar',
        length: 50,
        default: InventoryChangeStatus.PENDING,
        enum: InventoryChangeStatus,
    })
    status: InventoryChangeStatus;

    @Column({ name: 'reviewed_by_user_id', nullable: true })
    reviewedByUserId: string;

    @ManyToOne(() => User, { nullable: true })
    @JoinColumn({ name: 'reviewed_by_user_id' })
    reviewedBy: User;

    @Column({ name: 'reviewed_at', type: 'timestamp', nullable: true })
    reviewedAt: Date;

    @Column({ name: 'review_notes', type: 'text', nullable: true })
    reviewNotes: string;

    @Column({ type: 'text', nullable: true })
    reason: string;

    @Column({ type: 'text', nullable: true })
    notes: string;

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;
}
