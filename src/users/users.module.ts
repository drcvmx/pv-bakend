import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { User } from './entities/user.entity';
import { UserTenantPermission } from './entities/user-tenant-permission.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User, UserTenantPermission])],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService], // Exportar para que AuthModule pueda usarlo
})
export class UsersModule { }
