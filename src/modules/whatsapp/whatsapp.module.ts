import { Module, Global } from '@nestjs/common';
import { WhatsappService } from './whatsapp.service';

import { TicketGeneratorService } from './ticket-generator.service';

@Global()
@Module({
    providers: [WhatsappService, TicketGeneratorService],
    exports: [WhatsappService, TicketGeneratorService],
})
export class WhatsappModule { }
