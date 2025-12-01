import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity('tenants')
@Index(['ownerUserId'])
export class Tenant {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ length: 255, nullable: true })
    nombre: string;

    @Column({ name: 'tipo_negocio', length: 50, nullable: true })
    tipoNegocio: string;

    @Column({ name: 'owner_user_id', type: 'uuid', nullable: true })
    ownerUserId: string;

    @ManyToOne(() => User, { nullable: true })
    @JoinColumn({ name: 'owner_user_id' })
    owner: User;
}
