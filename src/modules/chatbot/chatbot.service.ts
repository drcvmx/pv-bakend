import { Injectable, Logger } from '@nestjs/common';
import { CatalogoService } from '../catalogo/catalogo.service';
import { TenantsService } from '../../tenants/tenants.service';

interface ChatMessage {
  role: 'system' | 'user' | 'assistant' | 'function';
  content: string;
  name?: string;
}

// ─────────────────────────────────────────────────────────────────────────────
// Pre-clasificador de intención — sin llamada LLM extra.
// Si el mensaje contiene estas palabras forzamos tool_choice en lugar de usar
// 'auto', que los modelos pequeños ignoran con frecuencia.
// ─────────────────────────────────────────────────────────────────────────────
const PRODUCT_INTENT_KEYWORDS = [
  // Verbos de consulta
  'tienes', 'tienen', 'hay', 'venden', 'vendes', 'existe', 'manejan',
  'busca', 'muestra', 'lista', 'dame', 'dime', 'ver', 'mostrar',
  // Precio
  'precio', 'cuánto', 'cuanto', 'cuesta', 'cuestan', 'vale', 'valen', 'costo',
  // Stock
  'stock', 'queda', 'quedan', 'disponible', 'unidades', 'existencia',
  // Carrito
  'agreg', 'añad', 'pon ', 'lleva', 'quiero', 'compra', 'carrito', 'pedir',
  // Catálogo general
  'catálogo', 'catalogo', 'productos', 'variante', 'opciones',
  'qué tienes', 'que tienes', 'algo de', 'tienes algo', 'tienen algo',
  'marca', 'marcas', // <- Se agregaron para atrapar "¿qué marcas tienes?"
  // Categorías genéricas
  'botanas', 'galletas', 'dulces', 'bebidas', 'refrescos', 'pastelitos', 'snacks', 'saludable',
  // Marcas del catálogo DRCV Store
  'barcel', 'marinela', 'bimbo',
  // Productos específicos del catálogo
  'takis', 'gansito', 'pinguinos', 'pingüinos', 'chocoroles', 'roles',
  'barritas', 'canelitas', 'principe', 'príncipe', 'sponch', 'triki', 'trikes',
  'big mix', 'golden nuts', 'wapas', 'runners', 'papatinas', 'chipotles',
  'spiga', 'bran frut', 'barras multigrano',
  // Términos coloquiales
  'chetos', 'sabritas', 'ruffles', 'tostitos', 'coca', 'pepsi',
];

function hasProductIntent(message: string): boolean {
  const lower = message.toLowerCase();
  return PRODUCT_INTENT_KEYWORDS.some((kw) => lower.includes(kw));
}

// Inferir la tool más específica según el texto del usuario.
function inferTool(message: string): string {
  const lower = message.toLowerCase();
  if (/agreg|añad|llévame|llevame|quiero\s+\d|dame\s+\d|pon\s+\d|compra/.test(lower)) {
    return 'agregar_al_carrito';
  }
  if (/precio|cuánto|cuanto|cuesta|cuestan|vale|valen|costo/.test(lower)) {
    return 'consultar_precio';
  }
  if (/stock|queda|quedan|disponible|unidades|existencia|cuántos|cuantos/.test(lower)) {
    return 'consultar_stock';
  }
  return 'consultar_productos';
}

@Injectable()
export class ChatbotService {
  private readonly logger = new Logger(ChatbotService.name);
  private ollamaUrl: string;
  private llmModel: string;
  private conversations: Map<string, ChatMessage[]> = new Map();

  constructor(
    private readonly catalogoService: CatalogoService,
    private readonly tenantsService: TenantsService,
  ) {
    this.ollamaUrl = process.env.OLLAMA_URL || 'http://localhost:11434';
    this.llmModel = process.env.LLM_MODEL || 'qwen2.5:7b';
    this.logger.log(
      `Chatbot conectado a Ollama: ${this.ollamaUrl} (modelo: ${this.llmModel})`,
    );
  }

  // toolChoice: 'auto' | 'required' | 'none' | { type: 'function', function: { name } }
  private async chatCompletion(
    messages: any[],
    tools?: any[],
    toolChoice: any = 'auto',
  ): Promise<any> {
    const body: any = {
      model: this.llmModel,
      messages,
      temperature: 0.1,
      max_tokens: 600,
    };
    if (tools && tools.length > 0) {
      body.tools = tools;
      body.tool_choice = toolChoice;
    }
    const res = await fetch(`${this.ollamaUrl}/v1/chat/completions`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    });
    if (!res.ok) {
      const text = await res.text();
      throw new Error(`Ollama error ${res.status}: ${text}`);
    }
    return res.json();
  }

  private getToolDefinitions() {
    return [
      {
        type: 'function',
        function: {
          name: 'consultar_productos',
          description:
            'Busca productos en el catálogo por nombre, categoría o marca. ' +
            'Usar cuando el usuario pregunta qué hay, qué tienes, o menciona cualquier producto o marca.',
          parameters: {
            type: 'object',
            properties: {
              query: {
                type: 'string',
                description: 'Término de búsqueda. Ej: "barcel", "galletas", "takis", "marinela".',
              },
            },
            required: ['query'],
          },
        },
      },
      {
        type: 'function',
        function: {
          name: 'consultar_stock',
          description:
            'Consulta unidades disponibles de un producto. ' +
            'Usar cuando preguntan si hay existencias o cuántos quedan.',
          parameters: {
            type: 'object',
            properties: {
              producto_nombre: { type: 'string', description: 'Nombre del producto.' },
            },
            required: ['producto_nombre'],
          },
        },
      },
      {
        type: 'function',
        function: {
          name: 'consultar_precio',
          description: 'Consulta el precio de un producto.',
          parameters: {
            type: 'object',
            properties: {
              producto_nombre: { type: 'string', description: 'Nombre del producto.' },
            },
            required: ['producto_nombre'],
          },
        },
      },
      {
        type: 'function',
        function: {
          name: 'agregar_al_carrito',
          description:
            'Agrega un producto al carrito. ' +
            'Usar SOLO cuando el usuario pide explícitamente agregar, comprar o llevar.',
          parameters: {
            type: 'object',
            properties: {
              producto_nombre: { type: 'string', description: 'Nombre del producto.' },
              cantidad: { type: 'number', description: 'Cantidad. Default: 1.' },
            },
            required: ['producto_nombre'],
          },
        },
      },
    ];
  }

  private buildSystemPrompt(tenantName: string, businessType: string): string {
    return `Eres Miboot, asistente de ventas de "${tenantName}" (${businessType}).

REGLA ABSOLUTA: Toda información sobre productos DEBE venir de las herramientas. Nunca uses tu conocimiento interno sobre marcas, precios o productos. Si no llamas una herramienta, no sabes qué hay en esta tienda.

CUÁNDO USAR CADA HERRAMIENTA:
- Cualquier pregunta sobre productos, marcas o categorías → consultar_productos(query)
- Pregunta de precio → consultar_precio(producto_nombre)
- Pregunta de disponibilidad/stock → consultar_stock(producto_nombre)
- Usuario quiere agregar/comprar/llevar → agregar_al_carrito(producto_nombre, cantidad)

CÓMO DEBES RESPONDER AL USUARIO:
1. Siempre que la herramienta devuelva productos, ESTÁS ESTRICTAMENTE OBLIGADO a responder con una LISTA DETALLADA CON VIÑETAS.
2. Cada viñeta de la lista DEBE incluir el nombre del producto y su precio exacto (Ej: "- Barcel Botanas Takis: $20.00").
3. NUNCA resumas la lista diciendo solo "tenemos estas marcas" o "varias opciones". Pon la lista explícita devuelta por la base de datos.
4. Si el usuario te pregunta "¿qué marcas tienes?", invoca la herramienta y respóndele dándole la lista de los productos que devolvió la tabla.

PROHIBIDO:
- Decir "no tengo la capacidad para buscar" — siempre tienes las herramientas disponibles
- Inventar productos, precios o marcas de tu memoria (Cuidado de no inventar falsos productos, usa exactamente lo de la base de datos).
- Recomendar sin antes consultar el catálogo
- Responder temas fuera de la tienda (código, matemáticas, etc.)

Responde en español, de forma breve y amable.`;
  }

  private async executeFunction(
    tenantId: string,
    functionName: string,
    args: any,
  ): Promise<string> {
    this.logger.log(`Tool call: ${functionName}`, args);
    try {
      switch (functionName) {
        case 'consultar_productos':
          return await this.consultarProductos(tenantId, args.query);
        case 'consultar_stock':
          return await this.consultarStock(tenantId, args.producto_nombre);
        case 'consultar_precio':
          return await this.consultarPrecio(tenantId, args.producto_nombre);
        case 'agregar_al_carrito':
          return await this.agregarAlCarrito(tenantId, args.producto_nombre, args.cantidad || 1);
        default:
          return JSON.stringify({ error: 'Función no encontrada' });
      }
    } catch (error: any) {
      this.logger.error(`Error en ${functionName}:`, error);
      return JSON.stringify({ error: 'Error al ejecutar la función', details: error?.message });
    }
  }

  private async consultarProductos(tenantId: string, query: string): Promise<string> {
    // FIX MAGICO: Si la IA dice buscar "marcas", buscamos "a" para que la tabla escupa todo el catálogo.
    if (query && (query.toLowerCase() === 'marca' || query.toLowerCase() === 'marcas')) {
      query = 'a';
    }

    const productos = await this.catalogoService.search(tenantId, query);
    if (!productos || productos.length === 0) {
      return JSON.stringify({ found: false, message: `No hay productos para: "${query}".` });
    }
    return JSON.stringify({
      found: true,
      count: productos.length,
      productos: productos.map((p) => ({
        nombre: p.nombre,
        marca: p.marca,
        categoria: p.categoria,
        variantes: p.variantes?.map((v) => ({
          id: v.id,
          nombre: v.nombreVariante,
          precio: `$${Number(v.precio).toFixed(2)}`,
          unidad: v.unidadMedida,
          stock: v.inventario?.reduce((s: number, i: any) => s + Number(i.cantidad || 0), 0) || 0,
          disponible: (v.inventario?.reduce((s: number, i: any) => s + Number(i.cantidad || 0), 0) || 0) > 0,
        })),
      })),
    });
  }

  private async consultarStock(tenantId: string, productoNombre: string): Promise<string> {
    const productos = await this.catalogoService.search(tenantId, productoNombre);
    if (!productos?.length) return JSON.stringify({ found: false, message: 'Producto no encontrado.' });
    const producto = productos[0];
    return JSON.stringify({
      found: true,
      producto: producto.nombre,
      stock: producto.variantes?.map((v) => ({
        variante: v.nombreVariante,
        stock: v.inventario?.reduce((s: number, i: any) => s + Number(i.cantidad || 0), 0) || 0,
        unidad: v.unidadMedida,
      })),
    });
  }

  private async consultarPrecio(tenantId: string, productoNombre: string): Promise<string> {
    const productos = await this.catalogoService.search(tenantId, productoNombre);
    if (!productos?.length) return JSON.stringify({ found: false, message: 'Producto no encontrado.' });
    const producto = productos[0];
    return JSON.stringify({
      found: true,
      producto: producto.nombre,
      precios: producto.variantes?.map((v) => ({
        variante: v.nombreVariante,
        precio: v.precio,
        unidad: v.unidadMedida,
      })),
    });
  }

  private async agregarAlCarrito(
    tenantId: string,
    productoNombre: string,
    cantidad: number,
  ): Promise<string> {
    const productos = await this.catalogoService.search(tenantId, productoNombre);
    if (!productos?.length) {
      return JSON.stringify({ found: false, message: 'Producto no encontrado.' });
    }
    const producto = productos[0];
    const variante = producto.variantes?.[0];
    if (!variante) {
      return JSON.stringify({ found: true, message: 'El producto no tiene variantes disponibles.' });
    }
    return JSON.stringify({
      found: true,
      message: `Agregué ${cantidad} × ${producto.nombre} (${variante.nombreVariante}) al carrito.`,
      clientAction: {
        type: 'ADD_TO_CART',
        payload: {
          id: producto.id,
          variantId: variante.id,
          name: `${producto.nombre} - ${variante.nombreVariante}`,
          price: Number(variante.precio),
          quantity: cantidad,
        },
      },
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Extrae argumentos del texto del usuario para el fallback manual.
  // Limpia frases de acción y stopwords, dejando solo el nombre del producto.
  // ─────────────────────────────────────────────────────────────────────────
  private extractArgsFromMessage(message: string, toolName: string): any {
    const cantidadMatch = message.match(/\b(\d+)\b/);
    const cantidad = cantidadMatch ? parseInt(cantidadMatch[1]) : 1;

    let query = message.toLowerCase();

    // Paso 1: eliminar frases de acción completas (orden: más largas primero)
    const ACTION_PHRASES = [
      'agregar al carrito', 'al carrito', 'en el carrito', 'del carrito',
      'agrégame', 'agregame', 'agrégueme', 'agregueme',
      'añádeme', 'anademe', 'añade', 'anade',
      'llévame', 'llevame', 'llévatelo', 'llevatelo',
      'quiero comprar', 'quiero pedir', 'quiero',
      'dame', 'pon', 'ponme',
      'comprar', 'compra', 'pedir', 'pide', 'necesito',
      'por favor', 'porfavor', 'porfa', 'please',
      'agrega', 'agregar',
      'tienes', 'tienen', 'hay', 'muestrame', 'muéstrame',
      'buscar', 'busca', 'ver',
      'cuánto cuesta', 'cuanto cuesta', 'cuánto cuestan', 'cuanto cuestan',
      'cuánto vale', 'cuanto vale',
      'precio de', 'el precio',
      'algo de', 'algo',
    ];
    ACTION_PHRASES.sort((a, b) => b.length - a.length);
    ACTION_PHRASES.forEach((phrase) => {
      query = query.replace(new RegExp(phrase, 'gi'), ' ');
    });

    // Paso 2: quitar artículos y preposiciones
    const STOPWORDS = [
      'el', 'la', 'los', 'las', 'un', 'una', 'unos', 'unas',
      'de', 'del', 'al', 'a', 'en', 'con', 'para', 'por',
      'qué', 'que', 'me', 'te', 'le', 'nos', 'se',
      'unidad', 'unidades', 'pieza', 'piezas', 'bolsa', 'bolsas', 'paquete',
    ];
    STOPWORDS.forEach((sw) => {
      query = query.replace(new RegExp(`\\b${sw}\\b`, 'gi'), ' ');
    });

    // Paso 3: quitar número de cantidad
    if (cantidad > 0) {
      query = query.replace(new RegExp(`\\b${cantidad}\\b`, 'g'), ' ');
    }

    // Paso 4: limpiar puntuación y espacios múltiples
    query = query.replace(/[¿?¡!,\.;:]/g, ' ').replace(/\s+/g, ' ').trim();

    this.logger.debug(`extractArgs: "${message}" → "${query}" (cantidad: ${cantidad})`);

    if (toolName === 'agregar_al_carrito') return { producto_nombre: query, cantidad };
    if (toolName === 'consultar_precio') return { producto_nombre: query };
    if (toolName === 'consultar_stock') return { producto_nombre: query };
    return { query: query || 'productos' };
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Método principal
  // ─────────────────────────────────────────────────────────────────────────
  async processMessage(
    tenantId: string,
    message: string,
    conversationId?: string,
  ): Promise<{ response: string; conversationId: string; actions?: any[] }> {
    const convId = conversationId || this.generateConversationId();
    let messages = this.conversations.get(convId) || [];
    const collectedActions: any[] = [];

    if (messages.length === 0) {
      let tenantName = 'la tienda';
      let businessType = 'comercio';
      try {
        const tenant = await this.tenantsService.findById(tenantId);
        if (tenant) {
          tenantName = tenant.nombre;
          businessType = tenant.tipoNegocio || 'comercio';
        }
      } catch (_) {
        this.logger.warn(`Could not fetch tenant info for ${tenantId}`);
      }
      messages.push({ role: 'system', content: this.buildSystemPrompt(tenantName, businessType) });
    }

    messages.push({ role: 'user', content: message });

    // ── Paso 1: Pre-clasificar intención y forzar tool_choice ─────────────
    const needsTools = hasProductIntent(message);
    let toolChoice: any = 'auto';
    let forcedTool: string | null = null;

    if (needsTools) {
      forcedTool = inferTool(message);
      toolChoice = { type: 'function', function: { name: forcedTool } };
      this.logger.log(`Pre-classifier → forcing tool: ${forcedTool}`);
    }

    let response = await this.chatCompletion(messages, this.getToolDefinitions(), toolChoice);
    let assistantMessage = response.choices[0].message;

    // ── Corrección: alucinación de tags XML <function=...> ────────────────
    if (assistantMessage.content?.includes('<function=')) {
      try {
        const regex = /<function=(\w+)(?:=\[\])?(\{.*?\})?<\/function>/g;
        const newToolCalls: any[] = [];
        let cleanContent = assistantMessage.content;
        let match;
        while ((match = regex.exec(assistantMessage.content)) !== null) {
          let fixedJson = match[2] || '{}';
          if (!fixedJson.startsWith('{')) fixedJson = '{' + fixedJson;
          if (!fixedJson.endsWith('}')) fixedJson = fixedJson + '}';
          newToolCalls.push({
            id: `call_fix_${Date.now()}_${Math.random()}`,
            type: 'function',
            function: { name: match[1], arguments: fixedJson },
          });
          cleanContent = cleanContent.replace(match[0], '');
        }
        if (newToolCalls.length > 0) {
          this.logger.log(`Fixed ${newToolCalls.length} hallucinated XML tool calls`);
          assistantMessage.tool_calls = newToolCalls;
          assistantMessage.content = cleanContent.trim() || null;
        }
      } catch (e) {
        this.logger.error('Error fixing hallucinated XML tags', e);
      }
    }

    // ── Corrección: JSON plano en content ─────────────────────────────────
    if (!assistantMessage.tool_calls?.length && assistantMessage.content?.trim().startsWith('{')) {
      try {
        const clean = assistantMessage.content.trim().replace(/^```json\s*|\s*```$/g, '');
        const json = JSON.parse(clean);
        if (json.function && json.parameters) {
          assistantMessage.tool_calls = [{
            id: `call_${Date.now()}`,
            type: 'function',
            function: { name: json.function, arguments: JSON.stringify(json.parameters) },
          }];
          assistantMessage.content = null;
        }
      } catch (_) { }
    }

    // ── Fallback: el modelo ignoró tool_choice forzado ────────────────────
    if (needsTools && forcedTool && !assistantMessage.tool_calls?.length) {
      this.logger.warn(`Model ignored forced tool_choice. Executing ${forcedTool} manually.`);
      const args = this.extractArgsFromMessage(message, forcedTool);
      const functionResult = await this.executeFunction(tenantId, forcedTool, args);

      try {
        const resultJson = JSON.parse(functionResult);
        if (resultJson.clientAction) collectedActions.push(resultJson.clientAction);
      } catch (_) { }

      const callId = `call_manual_${Date.now()}`;
      messages.push({
        role: 'assistant' as const,
        content: null as any,
        tool_calls: [{ id: callId, type: 'function', function: { name: forcedTool, arguments: JSON.stringify(args) } }],
      } as any);
      messages.push({ role: 'tool' as any, tool_call_id: callId, content: functionResult } as any);

      response = await this.chatCompletion(messages, this.getToolDefinitions(), 'none');
      assistantMessage = response.choices[0].message;

      const finalContent = assistantMessage.content || 'Lo siento, no pude procesar tu solicitud.';
      messages.push({ role: 'assistant', content: finalContent });
      if (messages.length > 21) messages = [messages[0], ...messages.slice(-20)];
      this.conversations.set(convId, messages);
      this.cleanOldConversations();
      return {
        response: finalContent,
        conversationId: convId,
        actions: collectedActions.length > 0 ? collectedActions : undefined,
      };
    }

    // ── Loop de herramientas normal ───────────────────────────────────────
    let toolLoopCount = 0;
    const MAX_TOOL_LOOPS = 5;

    while (assistantMessage.tool_calls?.length > 0 && toolLoopCount < MAX_TOOL_LOOPS) {
      toolLoopCount++;

      messages.push({
        role: 'assistant',
        content: assistantMessage.content || '',
        tool_calls: assistantMessage.tool_calls,
      } as any);

      for (const toolCall of assistantMessage.tool_calls) {
        let functionArgs = {};
        try {
          functionArgs = JSON.parse(toolCall.function.arguments);
        } catch (_) {
          this.logger.error(`Bad args for ${toolCall.function.name}: ${toolCall.function.arguments}`);
        }

        const functionResult = await this.executeFunction(tenantId, toolCall.function.name, functionArgs);

        try {
          const resultJson = JSON.parse(functionResult);
          if (resultJson.clientAction) collectedActions.push(resultJson.clientAction);
        } catch (_) { }

        messages.push({ role: 'tool' as any, tool_call_id: toolCall.id, content: functionResult } as any);
      }

      // 'none' para que no entre en loop infinito de tools
      response = await this.chatCompletion(messages, this.getToolDefinitions(), 'none');
      assistantMessage = response.choices[0].message;
    }

    const finalContent = assistantMessage.content || 'Lo siento, no pude procesar tu solicitud.';
    messages.push({ role: 'assistant', content: finalContent });

    if (messages.length > 21) messages = [messages[0], ...messages.slice(-20)];
    this.conversations.set(convId, messages);
    this.cleanOldConversations();

    return {
      response: finalContent,
      conversationId: convId,
      actions: collectedActions.length > 0 ? collectedActions : undefined,
    };
  }

  private generateConversationId(): string {
    return `conv_${Date.now()}_${Math.random().toString(36).substring(2, 11)}`;
  }

  private cleanOldConversations() {
    if (this.conversations.size > 50) {
      const keys = Array.from(this.conversations.keys());
      keys.slice(0, this.conversations.size - 50).forEach((k) => this.conversations.delete(k));
    }
  }
}

