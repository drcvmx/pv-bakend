import { Entity, PrimaryGeneratedColumn, Column, Index, OneToMany, ManyToOne, JoinColumn } from 'typeorm';
import { Variante } from './variante.entity';
import { GlobalProduct } from './global-product.entity';
import { Tenant } from '../../../tenants/entities/tenant.entity';

@Entity('productos')
@Index(['tenantId', 'nombre'])
export class Producto {
    @PrimaryGeneratedColumn({ type: 'bigint' })
    id: string;

    @Column({ name: 'tenant_id', type: 'uuid' })
    tenantId: string;

    @ManyToOne(() => Tenant, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'tenant_id' })
    tenant: Tenant;

    @Column()
    nombre: string;

    @Column({ type: 'text', nullable: true })
    descripcion: string;

    @Column({ name: 'imagen_url', type: 'text', nullable: true })
    imagenUrl: string;

    @Column({ nullable: true, length: 100 })
    marca: string;

    @Column({ nullable: true, length: 100 })
    categoria: string;

    @Column({ nullable: true, length: 255 })
    proveedor: string;

    @Column({ name: 'codigo_barras', nullable: true, length: 50 })
    @Index()
    codigoBarras: string;

    @Column({ name: 'global_product_id', type: 'uuid', nullable: true })
    globalProductId: string;

    @ManyToOne(() => GlobalProduct, { nullable: true, onDelete: 'SET NULL' })
    @JoinColumn({ name: 'global_product_id' })
    globalProduct: GlobalProduct;

    @OneToMany(() => Variante, (variante) => variante.producto)
    variantes: Variante[];
}
