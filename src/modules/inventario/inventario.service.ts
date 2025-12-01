import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Inventario } from './entities/inventario.entity';
import { InventoryChange, InventoryChangeType, InventoryChangeStatus } from './entities/inventory-change.entity';

@Injectable()
export class InventarioService {
    constructor(
        @InjectRepository(Inventario)
        private inventarioRepo: Repository<Inventario>,
        @InjectRepository(InventoryChange)
        private changesRepo: Repository<InventoryChange>,
    ) { }

    async getStock(tenantId: string) {
        return this.inventarioRepo.find({
            where: { tenantId },
            relations: ['variante', 'variante.producto'],
        });
    }

    async registerPhysicalCount(
        tenantId: string,
        userId: string,
        role: string,
        items: { varianteId: string; cantidad: number }[]
    ) {
        const results = [];

        for (const item of items) {
            // 1. Buscar stock actual
            let inventario = await this.inventarioRepo.findOne({
                where: { tenantId, varianteId: item.varianteId },
            });

            // Si no existe, lo creamos con 0
            if (!inventario) {
                inventario = this.inventarioRepo.create({
                    tenantId,
                    varianteId: item.varianteId,
                    cantidad: 0,
                    sucursalId: 1, // Default sucursal
                });
                await this.inventarioRepo.save(inventario);
            }

            const currentStock = Number(inventario.cantidad);
            const difference = item.cantidad; // En modo ajuste/entrada, la diferencia es lo que se agrega
            const nuevoStock = currentStock + item.cantidad;

            // 2. Registrar el cambio
            const change = this.changesRepo.create({
                tenantId,
                varianteId: item.varianteId as any,
                changeType: InventoryChangeType.ADJUSTMENT, // Cambiado a ADJUSTMENT para sumar
                cantidadAnterior: currentStock,
                cantidadNueva: nuevoStock,
                diferencia: difference,
                createdByUserId: userId,
                status: role === 'tenant_admin' ? InventoryChangeStatus.APPROVED : InventoryChangeStatus.PENDING,
                notes: 'Ajuste de inventario (Suma) desde App',
            });

            const savedChange = await this.changesRepo.save(change);

            // 3. Si es admin, aplicar inmediatamente
            if (role === 'tenant_admin') {
                inventario.cantidad = nuevoStock;
                inventario.fechaActualizacion = new Date();
                inventario.usuarioActualizacion = userId;
                await this.inventarioRepo.save(inventario);
            }

            results.push(savedChange);
        }

        return {
            message: role === 'tenant_admin'
                ? 'Inventario actualizado correctamente'
                : 'Conteo enviado a aprobación',
            changes: results
        };
    }

    async getPendingChanges(tenantId: string) {
        return this.changesRepo.find({
            where: { tenantId, status: InventoryChangeStatus.PENDING },
            relations: ['variante', 'variante.producto'],
            order: { createdAt: 'DESC' }
        });
    }

    async approveChange(tenantId: string, changeId: string, adminId: string) {
        const change = await this.changesRepo.findOne({
            where: { id: changeId, tenantId },
            relations: ['variante']
        });

        if (!change) throw new NotFoundException('Cambio no encontrado');
        if (change.status !== InventoryChangeStatus.PENDING) throw new Error('El cambio no está pendiente');

        // Aplicar cambio
        let inventario = await this.inventarioRepo.findOne({
            where: { tenantId, varianteId: change.varianteId as any }
        });

        if (!inventario) {
            inventario = this.inventarioRepo.create({
                tenantId,
                varianteId: change.varianteId as any,
                cantidad: 0,
                sucursalId: 1
            });
        }

        // Si es conteo físico, reemplaza. Si es ajuste, suma/resta.
        if (change.changeType === InventoryChangeType.COUNT) {
            inventario.cantidad = change.cantidadNueva;
        } else {
            inventario.cantidad = Number(inventario.cantidad) + Number(change.diferencia);
        }

        inventario.fechaActualizacion = new Date();
        inventario.usuarioActualizacion = adminId;

        await this.inventarioRepo.save(inventario);

        // Actualizar estado del cambio
        change.status = InventoryChangeStatus.APPROVED;
        change.reviewedByUserId = adminId;
        change.reviewedAt = new Date();

        return this.changesRepo.save(change);
    }
}
