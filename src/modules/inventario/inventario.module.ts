import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { InventarioController } from './inventario.controller';
import { InventarioService } from './inventario.service';
import { Inventario } from './entities/inventario.entity';
import { InventoryChange } from './entities/inventory-change.entity';

@Module({
    imports: [TypeOrmModule.forFeature([Inventario, InventoryChange])],
    controllers: [InventarioController],
    providers: [InventarioService],
    exports: [InventarioService],
})
export class InventarioModule { }
