import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { OrdersModule } from '../orders/orders.module';
import { PaymentsService } from './payments.service';
import { PaymentsController } from './payments.controller';

import { CatalogoModule } from '../catalogo/catalogo.module';
import { TenantsModule } from '../../tenants/tenants.module';

@Module({
    imports: [ConfigModule, OrdersModule, CatalogoModule, TenantsModule],
    controllers: [PaymentsController],
    providers: [PaymentsService],
    exports: [PaymentsService],
})
export class PaymentsModule { }
