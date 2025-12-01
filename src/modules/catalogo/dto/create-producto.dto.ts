import { IsString, IsOptional, IsArray, ValidateNested, ArrayMinSize, Length } from 'class-validator';
import { Type } from 'class-transformer';
import { CreateVarianteDto } from './create-variante.dto';

export class CreateProductoDto {
    @IsString()
    @Length(3, 100)
    nombre: string;

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

    @IsArray()
    @ValidateNested({ each: true })
    @ArrayMinSize(1)
    @Type(() => CreateVarianteDto)
    variantes: CreateVarianteDto[];
}
