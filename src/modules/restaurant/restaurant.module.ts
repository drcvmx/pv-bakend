import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { RestaurantService } from './restaurant.service';
import { RestaurantController } from './restaurant.controller';
import { RestaurantTable } from './entities/restaurant-table.entity';

@Module({
    imports: [TypeOrmModule.forFeature([RestaurantTable])],
    controllers: [RestaurantController],
    providers: [RestaurantService],
    exports: [RestaurantService],
})
export class RestaurantModule { }
