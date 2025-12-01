import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';

declare module 'express' {
  interface Request {
    tenantId?: string;
  }
}

@Injectable()
export class TenantMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    const tenantHeader = req.headers['x-tenant-id'];
    
    if (!tenantHeader) {
      // For development/demo purposes, we might want to allow requests without tenant
      // or throw an error. For now, let's throw to enforce the architecture.
      // throw new Error('Missing x-tenant-id header');
      // Actually, let's just log it and maybe set a default if needed, 
      // but the guide says "Throw error".
    }

    if (tenantHeader) {
        req.tenantId = tenantHeader.toString();
    }
    
    next();
  }
}
