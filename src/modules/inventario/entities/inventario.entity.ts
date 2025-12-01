import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { Variante } from '../../catalogo/entities/variante.entity';
import { Tenant } from '../../../tenants/entities/tenant.entity';

@Entity('inventario')
@Index(['tenantId', 'varianteId', 'sucursalId'])
export class Inventario {
    @PrimaryGeneratedColumn({ type: 'bigint' })
    id: string;

    @Column({ name: 'tenant_id', type: 'uuid' })
    tenantId: string;

    @ManyToOne(() => Tenant, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'tenant_id' })
    tenant: Tenant;

    @Column({ name: 'variante_id', type: 'bigint' })
    varianteId: string;

    @ManyToOne(() => Variante, (variante) => variante.inventario)
    @JoinColumn({ name: 'variante_id' })
    variante: Variante;

    @Column({ name: 'sucursal_id', nullable: true })
    sucursalId: number;

    @Column('decimal', { precision: 10, scale: 4, default: 0 })
    cantidad: number;

    @Column({ nullable: true, length: 255 })
    ubicacion: string;

    @Column({ name: 'fecha_actualizacion', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
    fechaActualizacion: Date;

    @Column({ name: 'usuario_actualizacion', nullable: true, length: 255 })
    usuarioActualizacion: string;
}
