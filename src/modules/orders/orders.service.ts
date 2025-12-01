import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DeepPartial } from 'typeorm';
import { Order, OrderStatus } from './entities/order.entity';
import { OrderItem } from './entities/order-item.entity';
import { randomBytes } from 'crypto';
import { CatalogoService } from '../catalogo/catalogo.service';

@Injectable()
export class OrdersService {
    constructor(
        @InjectRepository(Order) private orderRepo: Repository<Order>,
        private catalogoService: CatalogoService,
    ) { }

    async createPendingOrder(tenantId: string, createOrderDto: any) {
        const { items, customerEmail, customerName, storeId } = createOrderDto;

        // 1. Validar que hay items
        if (!items || items.length === 0) {
            throw new BadRequestException('La orden debe tener al menos un producto');
        }

        // 2. Recalcular total y validar stock usando precios de la BD
        let calculatedTotal = 0;
        const orderItems: DeepPartial<OrderItem>[] = [];

        for (const item of items) {
            // Validar cantidad sospechosa (Fraude)
            if (item.quantity > 100) {
                throw new BadRequestException(`Cantidad sospechosa para el producto ${item.variantId}`);
            }

            // Obtener variante con producto e inventario desde la BD
            const variant = await this.catalogoService.getVariantForOrder(item.variantId);

            // Validar que el producto existe
            if (!variant) {
                throw new BadRequestException(`Producto ${item.variantId} no encontrado`);
            }

            // Validar stock disponible
            if (variant.trackStock && variant.inventario && variant.inventario.length > 0) {
                const totalStock = variant.inventario.reduce((sum, inv) => sum + inv.cantidad, 0);
                if (totalStock < item.quantity) {
                    throw new BadRequestException(
                        `Stock insuficiente para ${variant.producto.nombre}. Disponible: ${totalStock}, Solicitado: ${item.quantity}`
                    );
                }
            }

            // Usar precio de la BD (NO del cliente)
            const price = Number(variant.precio);
            const subtotal = price * item.quantity;
            calculatedTotal += subtotal;

            // Crear item para guardar
            orderItems.push({
                variantId: variant.id,
                productName: variant.producto.nombre + (variant.nombreVariante !== 'Estándar' ? ` - ${variant.nombreVariante}` : ''),
                quantity: item.quantity,
                price: price,
                subtotal: subtotal
            });
        }

        const isCashPayment = createOrderDto.paymentMethod === 'cash';
        const initialStatus = isCashPayment ? OrderStatus.PAID : OrderStatus.PENDING;

        const newOrder = this.orderRepo.create({
            tenantId,
            storeId,
            customerEmail,
            customerName,
            totalAmount: calculatedTotal, // Usar total calculado con precios de la BD
            status: initialStatus,
            collectionCode: isCashPayment ? Math.floor(100000000000 + Math.random() * 900000000000).toString() : undefined,
            items: orderItems // TypeORM se encarga de guardar los items gracias a cascade: true
        });

        const savedOrder = await this.orderRepo.save(newOrder);

        // Si es pago en efectivo, descontar inventario inmediatamente
        if (isCashPayment) {
            await this.catalogoService.deductStock(items);
        }

        return savedOrder;
    }

    async updateOrderToPaid(orderId: string, openpayId: string) {
        const collectionCode = Math.floor(100000000000 + Math.random() * 900000000000).toString();

        await this.orderRepo.update(orderId, {
            status: OrderStatus.PAID,
            stripePaymentIntentId: openpayId, // Reusing this column for Openpay ID for now
            collectionCode: collectionCode
        });

        return this.orderRepo.findOne({
            where: { id: orderId },
            relations: ['items']
        });
    }

    async updateOrderToFailed(orderId: string) {
        await this.orderRepo.update(orderId, {
            status: OrderStatus.FAILED
        });
    }

    async findOne(id: string): Promise<Order | null> {
        return this.orderRepo.findOne({
            where: { id },
            relations: ['items']
        });
    }

    async getSalesReport(startDate?: string, endDate?: string) {
        const query = this.orderRepo.createQueryBuilder('order')
            .select('order.tenantId', 'tenantId')
            .addSelect('SUM(order.totalAmount)', 'totalSales')
            .addSelect('COUNT(order.id)', 'orderCount')
            .where('order.status = :status', { status: OrderStatus.PAID });

        if (startDate) {
            query.andWhere('order.createdAt >= :startDate', { startDate });
        }
        if (endDate) {
            query.andWhere('order.createdAt <= :endDate', { endDate });
        }

        query.groupBy('order.tenantId');

        return query.getRawMany();
    }

    async getTopSellingProducts(tenantId: string) {
        return this.orderRepo.manager.createQueryBuilder(OrderItem, 'item')
            .select('item.productName', 'name')
            .addSelect('SUM(item.quantity)', 'sales')
            .innerJoin('item.order', 'order')
            .where('order.tenantId = :tenantId', { tenantId })
            .andWhere('order.status = :status', { status: OrderStatus.PAID })
            .groupBy('item.productName')
            .orderBy('sales', 'DESC')
            .limit(5)
            .getRawMany();
    }

    async getStockAlerts(tenantId: string) {
        // Esto idealmente iría en CatalogoService, pero para el dashboard lo ponemos aquí por ahora
        // o inyectamos CatalogoService (ya está inyectado)
        return this.catalogoService.getLowStockProducts(tenantId);
    }

    async findByCollectionCode(code: string, tenantId: string) {
        const order = await this.orderRepo.findOne({
            where: {
                collectionCode: code,
                tenantId: tenantId
            },
            relations: ['items']
        });

        if (!order) {
            return null;
        }

        return order;
    }

    async markAsDelivered(id: string, tenantId: string) {
        const order = await this.orderRepo.findOne({ where: { id, tenantId } });

        if (!order) {
            throw new BadRequestException('Orden no encontrada');
        }

        if (order.status === OrderStatus.COMPLETED) {
            throw new BadRequestException('La orden ya fue entregada');
        }

        await this.orderRepo.update(id, {
            status: OrderStatus.COMPLETED
        });

        return { success: true, message: 'Orden marcada como entregada' };
    }
}
