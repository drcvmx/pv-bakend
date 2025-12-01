import { IsString, IsNumber, IsOptional, Min } from 'class-validator';

/**
 * DTO para registro rápido de producto al escanear un código no encontrado
 */
export class RegistroRapidoDto {
    @IsString()
    codigoEscaneado: string; // El código de barras o QR escaneado

    @IsString()
    tipoCodigo: string; // 'BARRAS' o 'QR'

    @IsString()
    nombre: string;

    @IsString()
    @IsOptional()
    nombreVariante?: string; // Si no se proporciona, usa "Presentación Única"

    @IsString()
    @IsOptional()
    marca?: string;

    @IsString()
    @IsOptional()
    categoria?: string;

    @IsString()
    @IsOptional()
    proveedor?: string;

    @IsString()
    @IsOptional()
    descripcion?: string;

    @IsString()
    @IsOptional()
    imagenUrl?: string;

    @IsNumber()
    @Min(0)
    precio: number;

    @IsNumber()
    @IsOptional()
    @Min(0)
    costo?: number;

    @IsString()
    unidadMedida: string; // 'PZA', 'KG', 'LT', etc.

    @IsNumber()
    @IsOptional()
    @Min(0)
    cantidadInicial?: number; // Para inventario inicial
}
