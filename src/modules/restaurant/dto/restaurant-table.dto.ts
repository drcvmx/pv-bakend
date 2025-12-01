import { IsNumber, IsArray, ValidateNested, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';

export class TableConfigDto {
    @IsNumber()
    @Min(1)
    @Max(20)
    seats: number;

    @IsNumber()
    @Min(1)
    @Max(50)
    count: number; // Cuántas mesas de esta capacidad
}

export class BulkCreateTablesDto {
    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => TableConfigDto)
    tables: TableConfigDto[];
}

export class UpdateTableStatusDto {
    @IsNumber()
    status: string; // 'available' | 'occupied' | 'reserved'
}
