import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Openpay from 'openpay';
import { CatalogoService } from '../catalogo/catalogo.service';
import { OrdersService } from '../orders/orders.service';
import { WhatsappService } from '../whatsapp/whatsapp.service';
import { TenantsService } from '../../tenants/tenants.service';

@Injectable()
export class PaymentsService {
    private openpay: any;
    private readonly logger = new Logger(PaymentsService.name);

    constructor(
        private configService: ConfigService,
        private ordersService: OrdersService,
        private catalogoService: CatalogoService,
        private whatsappService: WhatsappService,
        private tenantsService: TenantsService
    ) {
        const merchantId = this.configService.get<string>('OPENPAY_MERCHANT_ID');
        const privateKey = this.configService.get<string>('OPENPAY_PRIVATE_KEY');
        const isProduction = this.configService.get<string>('OPENPAY_PRODUCTION') === 'true';

        if (!merchantId || !privateKey) {
            this.logger.error('Openpay credentials not found in environment variables');
            throw new Error('Openpay credentials missing');
        }

        this.openpay = new Openpay(merchantId, privateKey, isProduction);
        this.logger.log(`Openpay initialized in ${isProduction ? 'PRODUCTION' : 'SANDBOX'} mode`);
    }

    async createCharge(chargeData: any): Promise<any> {
        // 1. Create Pending Order in DB
        // TODO: Get tenantId from request or context. For now assuming it's passed or we use a default valid UUID.
        const tenantId = chargeData.tenantId || '00000000-0000-0000-0000-000000000000';

        const order = await this.ordersService.createPendingOrder(tenantId, {
            items: chargeData.items, // Pass items for validation
            amount: chargeData.amount,
            customerEmail: chargeData.customer.email,
            customerName: `${chargeData.customer.name} ${chargeData.customer.last_name || ''}`.trim(),
            storeId: chargeData.storeId // Ensure frontend sends this
        });

        const openpayRequest = {
            source_id: chargeData.token_id,
            method: 'card',
            amount: parseFloat(chargeData.amount),
            currency: 'MXN',
            description: `Order #${order.id} - ${chargeData.description}`, // Link description to Order ID
            order_id: order.id, // Send our Order ID to Openpay
            device_session_id: chargeData.device_session_id,
            customer: {
                name: chargeData.customer.name,
                last_name: '.',
                phone_number: chargeData.customer.phone_number,
                email: chargeData.customer.email
            }
        };

        return new Promise(async (resolve, reject) => {
            // 2. Validate Stock AGAIN before charging (Race Condition Fix)
            try {
                await this.catalogoService.validateStock(chargeData.items);
            } catch (error) {
                this.logger.warn(`Stock validation failed before charge: ${error.message}`);
                await this.ordersService.updateOrderToFailed(order.id);
                return reject(error);
            }

            this.openpay.charges.create(openpayRequest, async (error: any, body: any, response: any) => {
                if (error) {
                    this.logger.error(`Openpay Charge Error: ${JSON.stringify(error)}`);
                    await this.ordersService.updateOrderToFailed(order.id);
                    reject(error);
                } else {
                    this.logger.log(`Charge created successfully: ${body.id}`);
                    // Deduct stock immediately upon successful payment
                    await this.catalogoService.deductStock(chargeData.items);

                    const paidOrder = await this.ordersService.updateOrderToPaid(order.id, body.id);

                    // --- WHATSAPP NOTIFICATION START ---
                    if (chargeData.customer.phone_number) {
                        try {
                            const tenant = await this.tenantsService.findById(tenantId);
                            const storeName = tenant.nombre || "Nuestra Tienda";

                            // Send visual ticket
                            this.whatsappService.enviarTicket(chargeData.customer.phone_number, paidOrder, storeName);
                        } catch (error) {
                            this.logger.error(`Error fetching tenant for WhatsApp message: ${error.message}`);
                            // Fallback
                            this.whatsappService.enviarTicket(chargeData.customer.phone_number, paidOrder, "Tienda");
                        }
                    }
                    // --- WHATSAPP NOTIFICATION END ---

                    resolve(paidOrder); // Return the full order object with collectionCode
                }
            });
        });
    }

    validateWebhookSignature(signature: string, body: any): boolean {
        // TODO: Implement HMAC validation when webhook secret is available
        return true;
    }
}
