import { Module } from '@nestjs/common';
import { ChatbotController } from './chatbot.controller';
import { ChatbotService } from './chatbot.service';
import { CatalogoModule } from '../catalogo/catalogo.module';
import { TenantsModule } from '../../tenants/tenants.module';

@Module({
    imports: [CatalogoModule, TenantsModule],
    controllers: [ChatbotController],
    providers: [ChatbotService],
    exports: [ChatbotService],
})
export class ChatbotModule { }
