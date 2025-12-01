import { Controller, Post, Body, Headers, UnauthorizedException, Logger, UseGuards } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { Public } from '../../auth/decorators/public.decorator';

@Controller('payments')
@UseGuards(JwtAuthGuard)
export class PaymentsController {
    private readonly logger = new Logger(PaymentsController.name);

    constructor(private readonly paymentsService: PaymentsService) { }

    @Public()
    @Post('charge')
    async createCharge(@Body() chargeData: any) {
        this.logger.log('Received charge request');
        // Here we would normally validate the DTO
        // chargeData should contain: source_id (token), method, amount, description, device_session_id, customer
        return this.paymentsService.createCharge(chargeData);
    }

    @Public()
    @Post('webhook')
    async handleWebhook(@Headers('openpay-signature') signature: string, @Body() body: any) {
        this.logger.log('Received webhook event');

        // Validate signature (skip for now until secret is set)
        // if (!this.paymentsService.validateWebhookSignature(signature, body)) {
        //   throw new UnauthorizedException('Invalid signature');
        // }

        // Process event
        if (body.type === 'charge.succeeded') {
            this.logger.log(`Payment succeeded: ${body.id}`);
            // TODO: Update order status
        }

        return { received: true };
    }
}
