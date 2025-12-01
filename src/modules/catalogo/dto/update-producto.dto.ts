import { IsNumber, IsOptional, IsString, Length, Min, Max } from 'class-validator';

export class UpdateProductoDto {
    @IsString()
    @IsOptional()
    @Length(3, 100)
    nombre?: string;

    @IsString()
    @IsOptional()
    @Length(0, 500)
    descripcion?: string;

    @IsString()
    @IsOptional()
    @Length(0, 255)
    imagenUrl?: string;

    @IsString()
    @IsOptional()
    @Length(0, 50)
    marca?: string;

    @IsString()
    @IsOptional()
    @Length(0, 50)
    categoria?: string;

    @IsString()
    @IsOptional()
    @Length(0, 100)
    proveedor?: string;

    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(999999.99)
    precio?: number;

    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(999999.99)
    costo?: number;

    @IsString()
    @IsOptional()
    @Length(0, 50)
    codigoBarras?: string;
}
