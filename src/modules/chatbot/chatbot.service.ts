import { Injectable, Logger } from '@nestjs/common';
import Groq from 'groq-sdk';
import { CatalogoService } from '../catalogo/catalogo.service';
import { TenantsService } from '../../tenants/tenants.service';

interface ChatMessage {
  role: 'system' | 'user' | 'assistant' | 'function';
  content: string;
  name?: string;
}

@Injectable()
export class ChatbotService {
  private readonly logger = new Logger(ChatbotService.name);
  private groq: Groq;
  private conversations: Map<string, ChatMessage[]> = new Map();

  constructor(
    private readonly catalogoService: CatalogoService,
    private readonly tenantsService: TenantsService,
  ) {
    this.groq = new Groq({
      apiKey: process.env.GROQ_API_KEY,
    });
  }

  // Definir las herramientas disponibles (nuevo formato de Groq)
  private getToolDefinitions() {
    return [
      {
        type: 'function',
        function: {
          name: 'consultar_productos',
          description:
            'Busca productos en el catálogo por nombre, marca o descripción. Usa esta función cuando el usuario pregunte si tienen un producto, marca o categoría específica. La búsqueda es flexible y encuentra coincidencias parciales.',
          parameters: {
            type: 'object',
            properties: {
              query: {
                type: 'string',
                description:
                  'Término de búsqueda: puede ser nombre del producto, marca, o palabra clave (ej: "coca cola", "sabritas", "leche", "botana")',
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
            'Consulta el stock disponible de un producto específico. Usa esta función cuando el usuario pregunte cuántas unidades hay o si hay disponibilidad.',
          parameters: {
            type: 'object',
            properties: {
              producto_nombre: {
                type: 'string',
                description: 'Nombre del producto para consultar stock',
              },
            },
            required: ['producto_nombre'],
          },
        },
      },
      {
        type: 'function',
        function: {
          name: 'consultar_precio',
          description:
            'Consulta el precio de un producto específico. Usa esta función cuando el usuario pregunte cuánto cuesta un producto.',
          parameters: {
            type: 'object',
            properties: {
              producto_nombre: {
                type: 'string',
                description: 'Nombre del producto para consultar precio',
              },
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
            'Agrega un producto al carrito de compras. Usa esta función cuando el usuario explícitamente pida agregar, comprar o llevar un producto.',
          parameters: {
            type: 'object',
            properties: {
              producto_nombre: {
                type: 'string',
                description: 'Nombre del producto a agregar',
              },
              cantidad: {
                type: 'number',
                description: 'Cantidad a agregar (por defecto 1)',
              },
            },
            required: ['producto_nombre'],
          },
        },
      },
    ];
  }

  // Ejecutar función basado en el nombre
  private async executeFunction(
    tenantId: string,
    functionName: string,
    args: any,
  ): Promise<string> {
    this.logger.log(`Executing function: ${functionName} with args:`, args);

    try {
      switch (functionName) {
        case 'consultar_productos':
          return await this.consultarProductos(tenantId, args.query);

        case 'consultar_stock':
          return await this.consultarStock(tenantId, args.producto_nombre);

        case 'consultar_precio':
          return await this.consultarPrecio(tenantId, args.producto_nombre);

        case 'agregar_al_carrito':
          return await this.agregarAlCarrito(
            tenantId,
            args.producto_nombre,
            args.cantidad || 1,
          );

        default:
          return JSON.stringify({ error: 'Función no encontrada' });
      }
    } catch (error: any) {
      this.logger.error(`Error executing function ${functionName}:`, error);
      return JSON.stringify({
        error: 'Error al ejecutar la función',
        details: error?.message || 'Unknown error',
      });
    }
  }

  // Implementación de las funciones
  private async consultarProductos(
    tenantId: string,
    query: string,
  ): Promise<string> {
    const productos = await this.catalogoService.search(tenantId, query);

    if (!productos || productos.length === 0) {
      return JSON.stringify({
        found: false,
        message: 'No se encontraron productos que coincidan con la búsqueda.',
      });
    }

    const productosInfo = productos.map((p) => ({
      nombre: p.nombre,
      descripcion: p.descripcion,
      variantes: p.variantes?.map((v) => ({
        id: v.id,
        nombre: v.nombreVariante,
        precio: `$${Number(v.precio).toFixed(2)}`,
        unidad: v.unidadMedida,
        stock:
          v.inventario?.reduce(
            (sum: number, inv: any) => sum + Number(inv.cantidad || 0),
            0,
          ) || 0,
        disponible:
          (v.inventario?.reduce(
            (sum: number, inv: any) => sum + Number(inv.cantidad || 0),
            0,
          ) || 0) > 0,
      })),
    }));

    return JSON.stringify({
      found: true,
      count: productos.length,
      mensaje: `Se encontraron ${productos.length} producto(s)`,
      productos: productosInfo,
    });
  }

  private async consultarStock(
    tenantId: string,
    productoNombre: string,
  ): Promise<string> {
    const productos = await this.catalogoService.search(
      tenantId,
      productoNombre,
    );

    if (!productos || productos.length === 0) {
      return JSON.stringify({
        found: false,
        message: 'Producto no encontrado.',
      });
    }

    const producto = productos[0];
    const stockInfo = producto.variantes?.map((v) => ({
      variante: v.nombreVariante,
      stock:
        v.inventario?.reduce(
          (sum: number, inv: any) => sum + Number(inv.cantidad || 0),
          0,
        ) || 0,
      unidad: v.unidadMedida,
    }));

    return JSON.stringify({
      found: true,
      producto: producto.nombre,
      stock: stockInfo,
    });
  }

  private async consultarPrecio(
    tenantId: string,
    productoNombre: string,
  ): Promise<string> {
    const productos = await this.catalogoService.search(
      tenantId,
      productoNombre,
    );

    if (!productos || productos.length === 0) {
      return JSON.stringify({
        found: false,
        message: 'Producto no encontrado.',
      });
    }

    const producto = productos[0];
    const preciosInfo = producto.variantes?.map((v) => ({
      variante: v.nombreVariante,
      precio: v.precio,
      unidad: v.unidadMedida,
    }));

    return JSON.stringify({
      found: true,
      producto: producto.nombre,
      precios: preciosInfo,
    });
  }

  private async agregarAlCarrito(
    tenantId: string,
    productoNombre: string,
    cantidad: number,
  ): Promise<string> {
    const productos = await this.catalogoService.search(
      tenantId,
      productoNombre,
    );

    if (!productos || productos.length === 0) {
      return JSON.stringify({
        found: false,
        message: 'Producto no encontrado. No se pudo agregar al carrito.',
      });
    }

    // Tomar el primer producto y su primera variante por defecto
    // Idealmente la IA podría preguntar por variantes, pero por ahora simplificamos
    const producto = productos[0];
    const variante = producto.variantes?.[0];

    if (!variante) {
      return JSON.stringify({
        found: true,
        message: 'El producto no tiene variantes disponibles para venta.',
      });
    }

    return JSON.stringify({
      found: true,
      message: `He agregado ${cantidad} ${producto.nombre} (${variante.nombreVariante}) al carrito.`,
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

  // Método principal para procesar mensajes del chat
  async processMessage(
    tenantId: string,
    message: string,
    conversationId?: string,
  ): Promise<{ response: string; conversationId: string; actions?: any[] }> {
    // Obtener o crear historial de conversación
    const convId = conversationId || this.generateConversationId();
    let messages = this.conversations.get(convId) || [];
    const collectedActions: any[] = [];

    // Si es nueva conversación, agregar mensaje del sistema con contexto del tenant
    if (messages.length === 0) {
      // Obtener información del tenant
      let tenantName = 'la tienda';
      let businessType = 'comercio';
      try {
        const tenant = await this.tenantsService.findById(tenantId);
        if (tenant) {
          tenantName = tenant.nombre;
          businessType = tenant.tipoNegocio || 'comercio';
        }
      } catch (e) {
        this.logger.warn(`Could not fetch tenant info for ${tenantId}`);
      }

      messages.push({
        role: 'system',
        content: `Eres "Miboot", el asistente de "${tenantName}" (${businessType}).
Tu trabajo es ayudar a vender respondiendo dudas sobre productos y precios.

INSTRUCCIONES CLAVE:
1. BUSCA PRODUCTOS: Si te preguntan por algo, USA la herramienta 'consultar_productos'.
2. MARCAS: Si piden "Coca Cola" o "Sabritas", busca esa palabra exacta.
3. SÉ BREVE: Respuestas cortas y directas.
4. HERRAMIENTAS: Usa SIEMPRE tool_calls. NO inventes texto.`,
      });
    }

    // Agregar mensaje del usuario
    messages.push({
      role: 'user',
      content: message,
    });

    // Llamar a Groq con Tools (nuevo formato)
    let response = await this.groq.chat.completions.create({
      model: 'llama-3.1-8b-instant',
      messages: messages as any,
      tools: this.getToolDefinitions() as any,
      tool_choice: 'auto',
      temperature: 0.5,
      max_tokens: 300,
    });

    let assistantMessage = response.choices[0].message;

    // --- CORRECCIÓN DE ALUCINACIONES DE FORMATO ---
    // A veces el modelo alucina tags XML como <function=...> en lugar de usar tool_calls
    if (assistantMessage.content && assistantMessage.content.includes('<function=')) {
      try {
        const regex = /<function=(\w+)(?:=\[\])?(\{.*?\})?<\/function>/g;
        let match;
        const newToolCalls = [];
        let cleanContent = assistantMessage.content;

        while ((match = regex.exec(assistantMessage.content)) !== null) {
          const functionName = match[1];
          const jsonArgs = match[2] || '{}';

          try {
            // Intentar arreglar JSON malformado común
            let fixedJson = jsonArgs;
            if (!fixedJson.startsWith('{')) fixedJson = '{' + fixedJson;
            if (!fixedJson.endsWith('}')) fixedJson = fixedJson + '}';

            newToolCalls.push({
              id: 'call_fix_' + Date.now() + Math.random(),
              type: 'function',
              function: {
                name: functionName,
                arguments: fixedJson
              }
            });

            // Remover el tag del contenido visible
            cleanContent = cleanContent.replace(match[0], '');
          } catch (e) {
            this.logger.warn(`Failed to parse hallucinated function args: ${jsonArgs}`);
          }
        }

        if (newToolCalls.length > 0) {
          this.logger.log(`Fixed ${newToolCalls.length} hallucinated tool calls`);
          assistantMessage.tool_calls = newToolCalls as any;
          assistantMessage.content = cleanContent.trim() || null; // Si solo había tags, dejar null
        }
      } catch (e) {
        this.logger.error('Error fixing hallucinated tags', e);
      }
    }

    // Fallback: Si el modelo devuelve un JSON en el contenido en lugar de tool_calls nativos
    if (
      (!assistantMessage.tool_calls || assistantMessage.tool_calls.length === 0) &&
      assistantMessage.content &&
      assistantMessage.content.trim().startsWith('{')
    ) {
      try {
        const content = assistantMessage.content.trim();
        // Intentar limpiar bloques de código markdown si existen
        const cleanContent = content.replace(/^```json\s*|\s*```$/g, '');
        const json = JSON.parse(cleanContent);

        if (json.function && json.parameters) {
          assistantMessage.tool_calls = [
            {
              id: 'call_' + Date.now(),
              type: 'function',
              function: {
                name: json.function,
                arguments: JSON.stringify(json.parameters),
              },
            },
          ] as any;
          assistantMessage.content = null; // Limpiar contenido para evitar mostrar el JSON
        }
      } catch (e) {
        // No es un JSON válido o no tiene el formato esperado, continuar normal
      }
    }

    // Si la IA decidió llamar una herramienta
    let toolLoopCount = 0;
    const MAX_TOOL_LOOPS = 5;

    while (
      assistantMessage.tool_calls &&
      assistantMessage.tool_calls.length > 0 &&
      toolLoopCount < MAX_TOOL_LOOPS
    ) {
      toolLoopCount++;
      if (toolLoopCount === MAX_TOOL_LOOPS) {
        this.logger.warn('Max tool loop iterations reached. Stopping recursion.');
      }
      // Agregar el mensaje del asistente con TODOS los tool_calls
      messages.push({
        role: 'assistant',
        content: assistantMessage.content || '',
        tool_calls: assistantMessage.tool_calls,
      } as any);

      // Procesar cada tool call
      for (const toolCall of assistantMessage.tool_calls) {
        const functionName = toolCall.function.name;
        let functionArgs = {};

        try {
          functionArgs = JSON.parse(toolCall.function.arguments);
        } catch (e) {
          this.logger.error(`Failed to parse arguments for ${functionName}: ${toolCall.function.arguments}`);
          // Intentar recuperación básica si es posible, o dejar vacío
        }

        this.logger.log(`AI wants to call: ${functionName}`);

        // Ejecutar la función
        const functionResult = await this.executeFunction(
          tenantId,
          functionName,
          functionArgs,
        );

        // Verificar si hay acciones del cliente en el resultado
        try {
          const resultJson = JSON.parse(functionResult);
          if (resultJson.clientAction) {
            collectedActions.push(resultJson.clientAction);
          }
        } catch (e) {
          // Ignorar error de parseo si no es JSON
        }

        // Agregar el resultado de la herramienta
        messages.push({
          role: 'tool' as any,
          tool_call_id: toolCall.id,
          content: functionResult,
        } as any);
      }

      // Hacer otra llamada a la IA con los resultados
      response = await this.groq.chat.completions.create({
        model: 'llama-3.1-8b-instant',
        messages: messages as any,
        tools: this.getToolDefinitions() as any,
        tool_choice: 'auto',
        temperature: 0.5,
        max_tokens: 300,
      });

      assistantMessage = response.choices[0].message;
    }

    // Agregar respuesta final al historial
    messages.push({
      role: 'assistant',
      content:
        assistantMessage.content || 'Lo siento, no pude procesar tu solicitud.',
    });

    // Guardar conversación (limitar a últimos 20 mensajes para no sobrecargar)
    if (messages.length > 20) {
      messages = [messages[0], ...messages.slice(-19)]; // Mantener system prompt + últimos 19
    }
    this.conversations.set(convId, messages);

    // Limpiar conversaciones viejas (más de 1 hora)
    this.cleanOldConversations();

    return {
      response:
        assistantMessage.content || 'Lo siento, no pude procesar tu solicitud.',
      conversationId: convId,
      actions: collectedActions.length > 0 ? collectedActions : undefined,
    };
  }

  private generateConversationId(): string {
    return `conv_${Date.now()}_${Math.random().toString(36).substring(2, 11)}`;
  }

  private cleanOldConversations() {
    // Limpiar conversaciones cada cierto tiempo
    // Por simplicidad, mantener solo las últimas 50
    if (this.conversations.size > 50) {
      const keys = Array.from(this.conversations.keys());
      const toDelete = keys.slice(0, this.conversations.size - 50);
      toDelete.forEach((key) => this.conversations.delete(key));
    }
  }
}
