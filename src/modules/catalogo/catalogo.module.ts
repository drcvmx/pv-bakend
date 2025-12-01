import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CatalogoController } from './catalogo.controller';
import { GlobalProductsController } from './global-products.controller';
import { CatalogoService } from './catalogo.service';
import { Producto } from './entities/producto.entity';
import { Variante } from './entities/variante.entity';
import { ProductRequest } from './entities/product-request.entity';
import { GlobalProduct } from './entities/global-product.entity';
import { ProductAudit } from './entities/product-audit.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Producto,
      Variante,
      ProductRequest,
      GlobalProduct,
      ProductAudit
    ])
  ],
  controllers: [CatalogoController, GlobalProductsController],
  providers: [CatalogoService],
  exports: [CatalogoService],
})
export class CatalogoModule { }
