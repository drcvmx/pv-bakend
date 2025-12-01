import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { RestaurantTable } from './entities/restaurant-table.entity';
import { BulkCreateTablesDto, UpdateTableStatusDto } from './dto/restaurant-table.dto';

@Injectable()
export class RestaurantService {
    constructor(
        @InjectRepository(RestaurantTable)
        private tableRepo: Repository<RestaurantTable>,
    ) { }

    /**
     * Obtener todas las mesas de un tenant
     */
    async getTables(tenantId: string) {
        return this.tableRepo.find({
            where: { tenantId },
            order: { tableNumber: 'ASC' }
        });
    }

    /**
     * Configuración inicial de mesas (elimina anteriores y crea nuevas)
     */
    async bulkCreateTables(tenantId: string, dto: BulkCreateTablesDto) {
        // Eliminar mesas existentes del tenant
        await this.tableRepo.delete({ tenantId });

        // Crear nuevas mesas
        const tables = [];
        let tableNumber = 1;

        for (const config of dto.tables) {
            for (let i = 0; i < config.count; i++) {
                tables.push(this.tableRepo.create({
                    tenantId,
                    tableNumber: tableNumber++,
                    seats: config.seats,
                    status: 'available'
                }));
            }
        }

        return this.tableRepo.save(tables);
    }

    /**
     * Actualizar estado de una mesa
     */
    async updateTableStatus(id: string, tenantId: string, status: string) {
        const table = await this.tableRepo.findOne({
            where: { id, tenantId }
        });

        if (!table) {
            throw new NotFoundException('Mesa no encontrada o no pertenece a este tenant');
        }

        table.status = status;
        return this.tableRepo.save(table);
    }

    /**
     * Obtener mesa por ID
     */
    async getTableById(id: string, tenantId: string) {
        const table = await this.tableRepo.findOne({
            where: { id, tenantId }
        });

        if (!table) {
            throw new NotFoundException('Mesa no encontrada');
        }

        return table;
    }

    /**
     * Obtener estadísticas de mesas
     */
    async getTableStats(tenantId: string) {
        const tables = await this.getTables(tenantId);

        return {
            total: tables.length,
            available: tables.filter(t => t.status === 'available').length,
            occupied: tables.filter(t => t.status === 'occupied').length,
            reserved: tables.filter(t => t.status === 'reserved').length,
            totalSeats: tables.reduce((sum, t) => sum + t.seats, 0),
        };
    }
}
