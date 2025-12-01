import { IsEmail, IsString, MinLength, IsNotEmpty, IsOptional, IsEnum } from 'class-validator';

export enum BusinessType {
    TIENDA = 'tienda',
    FERRETERIA = 'ferreteria',
    RESTAURANTE = 'restaurante',
}

export class RegisterDto {
    @IsEmail({}, { message: 'El email debe ser válido' })
    @IsNotEmpty({ message: 'El email es requerido' })
    email: string;

    @IsString()
    @MinLength(6, { message: 'La contraseña debe tener al menos 6 caracteres' })
    @IsNotEmpty({ message: 'La contraseña es requerida' })
    password: string;

    @IsString()
    @IsNotEmpty({ message: 'El nombre es requerido' })
    firstName: string;

    @IsString()
    @IsNotEmpty({ message: 'El apellido es requerido' })
    lastName: string;

    @IsString()
    @IsNotEmpty({ message: 'El nombre del negocio es requerido' })
    businessName: string;

    @IsEnum(BusinessType, { message: 'Tipo de negocio inválido' })
    @IsNotEmpty({ message: 'El tipo de negocio es requerido' })
    businessType: BusinessType;
}
