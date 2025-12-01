import { IsEmail, IsString, MinLength, IsNotEmpty } from 'class-validator';

export class LoginDto {
    @IsEmail({}, { message: 'El email debe ser válido' })
    @IsNotEmpty({ message: 'El email es requerido' })
    email: string;

    @IsString()
    @MinLength(6, { message: 'La contraseña debe tener al menos 6 caracteres' })
    @IsNotEmpty({ message: 'La contraseña es requerida' })
    password: string;
}
