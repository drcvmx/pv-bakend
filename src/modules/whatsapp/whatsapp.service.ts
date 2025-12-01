import { Injectable, OnModuleInit, Logger } from '@nestjs/common';
import { Client, LocalAuth, MessageMedia } from 'whatsapp-web.js';
import * as qrcode from 'qrcode-terminal';
import { TicketGeneratorService } from './ticket-generator.service';

@Injectable()
export class WhatsappService implements OnModuleInit {
  private client: Client;
  private readonly logger = new Logger(WhatsappService.name);

  constructor(private readonly ticketGenerator: TicketGeneratorService) {
    this.client = new Client({
      authStrategy: new LocalAuth({ clientId: 'bot-ventas' }),
      puppeteer: {
        headless: true,
        args: ['--no-sandbox', '--disable-setuid-sandbox'],
      },
    });
  }

  onModuleInit() {
    this.logger.log('Inicializando cliente de WhatsApp...');

    this.client.on('qr', (qr: string) => {
      this.logger.warn('⚠️ ESCANEA EL CÓDIGO QR EN LA TERMINAL ⚠️');
      qrcode.generate(qr, { small: true });
    });

    this.client.on('ready', () => {
      this.logger.log('✅ WhatsApp está conectado y listo para enviar tickets!');
    });

    this.client.on('auth_failure', (msg: string) => {
      this.logger.error('❌ Fallo de autenticación', msg);
    });

    this.client.initialize();
  }

  async enviarMensaje(numero: string, mensaje: string): Promise<boolean> {
    try {
      const chatId = await this.resolveChatId(numero);
      if (!chatId) return false;

      await this.client.sendMessage(chatId, mensaje);
      this.logger.log(`Mensaje enviado a ${numero}`);
      return true;
    } catch (error) {
      this.logger.error(`Error enviando mensaje a ${numero}`, error);
      return false;
    }
  }

  async enviarTicket(numero: string, order: any, storeName: string): Promise<boolean> {
    try {
      const chatId = await this.resolveChatId(numero);
      if (!chatId) return false;

      const imageBuffer = await this.ticketGenerator.generateTicketImage(order, storeName);
      const media = new MessageMedia('image/png', imageBuffer.toString('base64'), 'ticket.png');

      const caption = `🧾 *Ticket de Compra - ${storeName}*\n\nHola ${order.customerName || 'Cliente'}, gracias por tu compra.\n🆔 Orden: *${order.collectionCode}*\n\nPresenta la imagen adjunta en caja para recoger tu pedido.`;

      await this.client.sendMessage(chatId, media, { caption });
      this.logger.log(`Ticket visual enviado a ${numero}`);
      return true;
    } catch (error) {
      this.logger.error(`Error enviando ticket visual a ${numero}`, error);
      return false;
    }
  }

  private async resolveChatId(numero: string): Promise<string | null> {
    // Limpiar el número de caracteres no numéricos
    const numeroLimpio = numero.replace(/\D/g, '');

    // Intentar obtener el ID formateado correctamente desde WhatsApp
    // Probamos primero con el código de país 52 (México) si son 10 dígitos
    let candidateNumber = numeroLimpio;
    if (candidateNumber.length === 10) {
      candidateNumber = `52${candidateNumber}`;
    }

    // getNumberId devuelve el ID serializado correcto (incluyendo @c.us y correcciones de 521)
    const contact = await this.client.getNumberId(candidateNumber);

    if (!contact) {
      this.logger.warn(`El número ${numero} (probado como ${candidateNumber}) no está registrado en WhatsApp.`);
      return null;
    }

    return contact._serialized;
  }
}
