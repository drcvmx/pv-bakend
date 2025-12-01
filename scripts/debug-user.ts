
import { DataSource } from 'typeorm';
import * as dotenv from 'dotenv';
import { User } from '../src/users/entities/user.entity';
import { UserTenantPermission } from '../src/users/entities/user-tenant-permission.entity';
import { Tenant } from '../src/tenants/entities/tenant.entity';

dotenv.config();

const dataSource = new DataSource({
    type: 'postgres',
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '5432'),
    username: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
    database: process.env.DB_NAME || 'punto_venta_drcv',
    entities: [User, UserTenantPermission, Tenant],
    synchronize: false,
});

async function debugUser() {
    try {
        await dataSource.initialize();
        console.log('DB_CONNECTED');

        const email = 'dueno@api-industria.com';
        const user = await dataSource.getRepository(User).findOne({ where: { email } });

        if (!user) {
            console.log('USER_NOT_FOUND');
            return;
        }

        console.log(`USER_ID: ${user.id}`);

        const permissions = await dataSource.getRepository(UserTenantPermission).find({
            where: { userId: user.id }
        });

        console.log(`PERMISSIONS_COUNT: ${permissions.length}`);

        for (const p of permissions) {
            console.log(`PERMISSION_ID: ${p.id}`);
            console.log(`TENANT_ID_IN_PERM: ${p.tenantId}`);

            if (p.tenantId) {
                const tenant = await dataSource.getRepository(Tenant).findOne({ where: { id: p.tenantId } });
                console.log(`TENANT_EXISTS: ${!!tenant}`);
                if (tenant) {
                    console.log(`TENANT_NAME: ${tenant.nombre}`);
                }
            } else {
                console.log('TENANT_ID_IS_NULL');
            }
        }

    } catch (error) {
        console.error('ERROR:', error);
    } finally {
        await dataSource.destroy();
    }
}

debugUser();
