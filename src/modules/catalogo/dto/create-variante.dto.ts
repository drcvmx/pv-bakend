import { IsString, IsNumber, IsOptional, IsBoolean, Min } from 'class-validator';

export class CreateVarianteDto {
    @IsString()
    nombreVariante: string;

    @IsNumber()
    @Min(0)
    precio: number;

    @IsNumber()
    @IsOptional()
    @Min(0)
    costo?: number;

    @IsString()
    unidadMedida: string;

    @IsBoolean()
    @IsOptional()
    trackStock?: boolean;

    @IsString()
    @IsOptional()
    codigoBarras?: string;

    @IsString()
    @IsOptional()
    codigoQr?: string;

    @IsString()
    @IsOptional()
    tipoCodigo?: string; // 'BARRAS', 'QR', 'AMBOS'
}
