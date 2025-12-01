import { Controller, Post, Body, UseGuards, Headers, UnauthorizedException, Get, Param, Query, Req, BadRequestException } from '@nestjs/common';
import { OrdersService } from './orders.service';
import { TenantId } from '../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { TenantAccessGuard } from '../../auth/guards/tenant-access.guard';
import { Public } from '../../auth/decorators/public.decorator';

@Controller('orders')
@UseGuards(JwtAuthGuard, RolesGuard, TenantAccessGuard)
export class OrdersController {
    constructor(private readonly ordersService: OrdersService) { }

    // Endpoint protegido - Para usuarios autenticados (POS, admin, etc)
    @Post()
    create(@TenantId() tenantId: string, @Body() body: any, @Req() req: any) {
        const userId = req.user?.id;
        return this.ordersService.createPendingOrder(tenantId, { ...body, userId });
    }

    @Public()
    @Get('public/:id')
    async findOnePublic(@Param('id') id: string) {
        return this.ordersService.findOne(id);
    }

    @Get('admin/sales-report')
    async getSalesReport(
        @Query('startDate') startDate: string,
        @Query('endDate') endDate: string
    ) {
        return this.ordersService.getSalesReport(startDate, endDate);
    }

    @Get('dashboard/top-products')
    async getTopSellingProducts(@TenantId() tenantId: string) {
        return this.ordersService.getTopSellingProducts(tenantId);
    }

    @Get('dashboard/stock-alerts')
    async getStockAlerts(@TenantId() tenantId: string) {
        return this.ordersService.getStockAlerts(tenantId);
    }

    @Get('validate/:code')
    async validateOrder(@Param('code') code: string, @TenantId() tenantId: string) {
        const order = await this.ordersService.findByCollectionCode(code, tenantId);
        if (!order) {
            throw new BadRequestException('Código de colección inválido');
        }
        return order;
    }

    @Post(':id/deliver')
    async markAsDelivered(@Param('id') id: string, @TenantId() tenantId: string) {
        return this.ordersService.markAsDelivered(id, tenantId);
    }



    // Endpoint público - Para webhooks de pasarelas de pago
    @Public()
    @Post('webhook/payment')
    async handlePaymentWebhook(
        @Headers('x-webhook-signature') signature: string,
        @Body() body: any
    ) {
        // 1. CRÍTICO: Validar firma del webhook
        // Esto previene que cualquiera pueda crear órdenes
        const isValidSignature = this.validateWebhookSignature(signature, body);

        if (!isValidSignature) {
            throw new UnauthorizedException('Invalid webhook signature');
        }

        // 2. Extraer tenant_id del payload de la pasarela
        const tenantId = body.metadata?.tenant_id;
        if (!tenantId) {
            throw new UnauthorizedException('Missing tenant_id in webhook');
        }

        // 3. Crear la orden SOLO si el pago fue exitoso
        if (body.status === 'paid' || body.status === 'succeeded') {
            return this.ordersService.createPendingOrder(tenantId, {
                items: body.items,
                amount: body.amount / 100, // Stripe envía centavos
                customerName: body.customer?.name || 'Unknown',
                customerEmail: body.customer?.email || 'unknown@email.com',
                paymentIntentId: body.id,
                status: 'paid'
            });
        }

        return { received: true };
    }

    // Método para validar la firma del webhook
    private validateWebhookSignature(signature: string, body: any): boolean {
        // TODO: Implementar validación según tu pasarela

        // Ejemplo para Stripe:
        // const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
        // const event = stripe.webhooks.constructEvent(
        //     body,
        //     signature,
        //     process.env.STRIPE_WEBHOOK_SECRET
        // );

        // Ejemplo para PayPal:
        // const crypto = require('crypto');
        // const expected = crypto
        //     .createHmac('sha256', process.env.PAYPAL_WEBHOOK_SECRET)
        //     .update(JSON.stringify(body))
        //     .digest('hex');
        // return signature === expected;

        // Por ahora, solo validamos que exista
        // ⚠️ CAMBIAR EN PRODUCCIÓN
        return !!signature;
    }
}
