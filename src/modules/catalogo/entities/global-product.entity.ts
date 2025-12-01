import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('global_products')
export class GlobalProduct {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ nullable: true })
    nombre: string;

    @Column({ type: 'text', nullable: true })
    descripcion: string;

    @Column({ name: 'imagen_url', type: 'text', nullable: true })
    imagenUrl: string;

    @Column({ name: 'codigo_barras', nullable: true })
    codigoBarras: string;

    @Column({ nullable: true })
    categoria: string;

    @Column({ nullable: true })
    marca: string;

    @Column({ name: 'business_type', nullable: true })
    businessType: string;

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;
}
