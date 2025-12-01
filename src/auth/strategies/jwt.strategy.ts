import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
    constructor(private configService: ConfigService) {
        const secret = configService.get<string>('JWT_SECRET') || 'your-secret-key-change-in-production';
        super({
            jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
            ignoreExpiration: false,
            secretOrKey: secret,
        });
    }

    async validate(payload: any) {
        // El payload viene del JWT decodificado
        // Retornamos la info del usuario que se adjuntará a request.user
        return {
            sub: payload.sub,
            email: payload.email,
            role: payload.role,
            tenantId: payload.tenantId,
            tenantName: payload.tenantName,
            roleInTenant: payload.roleInTenant,
            permissions: payload.permissions,
        };
    }
}
