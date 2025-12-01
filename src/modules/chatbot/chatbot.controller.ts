import { Controller, Post, Body, UsePipes, ValidationPipe } from '@nestjs/common';
import { ChatbotService } from './chatbot.service';
import { ChatMessageDto } from './dto/chat-message.dto';
import { TenantId } from '../../common/decorators/tenant.decorator';
import { Public } from '../../auth/decorators/public.decorator';

@Controller('chatbot')
export class ChatbotController {
    constructor(private readonly chatbotService: ChatbotService) { }

    @Public()
    @Post('message')
    @UsePipes(new ValidationPipe({ transform: true }))
    async sendMessage(
        @TenantId() tenantId: string,
        @Body() dto: ChatMessageDto,
    ) {
        return this.chatbotService.processMessage(
            tenantId,
            dto.message,
            dto.conversationId,
        );
    }
}
