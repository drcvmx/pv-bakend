import { Entity, PrimaryGeneratedColumn, Column, Index, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
import { Producto } from './producto.entity';
import { Inventario } from '../../inventario/entities/inventario.entity';
import { Tenant } from '../../../tenants/entities/tenant.entity';

@Entity('variantes')
@Index(['tenantId', 'id'])
export class Variante {
    @PrimaryGeneratedColumn({ type: 'bigint' })
    id: string;

    @Column({ name: 'tenant_id', type: 'uuid' })
    tenantId: string;

    @ManyToOne(() => Tenant, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'tenant_id' })
    tenant: Tenant;

    @Column({ name: 'producto_id', type: 'bigint' })
    productoId: string;

    @ManyToOne(() => Producto, (producto) => producto.variantes)
    @JoinColumn({ name: 'producto_id' })
    producto: Producto;

    @Column({ name: 'nombre_variante' })
    nombreVariante: string;

    @Column('decimal', { precision: 10, scale: 2 })
    precio: number;

    @Column('decimal', { precision: 10, scale: 2, nullable: true })
    costo: number;

    @Column({ name: 'unidad_medida' })
    unidadMedida: string;

    @Column({ name: 'track_stock', default: true })
    trackStock: boolean;

    @Column({ name: 'codigo_barras', nullable: true, length: 50 })
    @Index()
    codigoBarras: string;

    @Column({ name: 'codigo_qr', nullable: true, length: 100 })
    @Index()
    codigoQr: string;

    @Column({ name: 'tipo_codigo', nullable: true, length: 20, default: 'BARRAS' })
    tipoCodigo: string; // 'BARRAS', 'QR', 'AMBOS'

    @OneToMany(() => Inventario, (inventario) => inventario.variante)
    inventario: Inventario[];
}
