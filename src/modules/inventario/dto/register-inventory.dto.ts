import { IsArray, IsNumber, IsString, Min, ValidateNested, ArrayMaxSize, ArrayMinSize } from 'class-validator';
import { Type } from 'class-transformer';

export class InventoryItemDto {
    @IsString()
    varianteId: string;

    @IsNumber()
    @Min(0)
    cantidad: number;
}

export class RegisterInventoryDto {
    @IsArray()
    @ValidateNested({ each: true })
    @ArrayMinSize(1)
    @ArrayMaxSize(100) // Limit batch size to prevent DoS
    @Type(() => InventoryItemDto)
    items: InventoryItemDto[];
}
