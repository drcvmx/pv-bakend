import { Injectable } from '@nestjs/common';
import { TenantsService } from './tenants/tenants.service';

@Injectable()
export class AppService {
  constructor(private tenantsService: TenantsService) { }

  getHello(): string {
    return 'Hello World!';
  }

  async getTenants() {
    return this.tenantsService.findAll();
  }
}
