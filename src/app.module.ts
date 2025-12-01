import { Module, MiddlewareConsumer, RequestMethod } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { TenantMiddleware } from './common/middlewares/tenant.middleware';
import { OrdersModule } from './modules/orders/orders.module';
import { CatalogoModule } from './modules/catalogo/catalogo.module';
import { RestaurantModule } from './modules/restaurant/restaurant.module';
import { InventarioModule } from './modules/inventario/inventario.module';
import { UsersModule } from './users/users.module';
import { AuthModule } from './auth/auth.module';
import { ChatbotModule } from './modules/chatbot/chatbot.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { TenantsModule } from './tenants/tenants.module';
import { WhatsappModule } from './modules/whatsapp/whatsapp.module';

@Module({
  imports: [
    ConfigModule.forRoot(),
    ThrottlerModule.forRoot([{
      ttl: 60000,
      limit: 100,
    }]),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT || '5432'),
      username: process.env.DB_USERNAME || 'postgres',
      password: process.env.DB_PASSWORD || 'postgres',
      database: process.env.DB_NAME || 'punto_venta_saas',
      entities: [__dirname + '/**/*.entity{.ts,.js}'],
      synchronize: process.env.NODE_ENV !== 'production', // Safe: disabled in production
    }),
    TenantsModule,
    OrdersModule,
    CatalogoModule,
    RestaurantModule,
    InventarioModule,
    UsersModule,
    AuthModule,
    ChatbotModule,
    PaymentsModule,
    WhatsappModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
  ],
})
export class AppModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(TenantMiddleware)
      .forRoutes({ path: '*', method: RequestMethod.ALL });
  }
}
