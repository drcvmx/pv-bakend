import { Controller, Get, Query } from '@nestjs/common';
import { AppService } from './app.service';
import { TenantsService } from './tenants/tenants.service';

@Controller()
export class AppController {
  constructor(
    private readonly appService: AppService,
    private readonly tenantsService: TenantsService,
  ) { }

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('tenants')
  async getTenants() {
    return this.tenantsService.findAll();
  }

  @Get('tenants/by-domain')
  async getTenantByDomain(@Query('domain') domain: string) {
    return this.tenantsService.findByDomain(domain);
  }
}
