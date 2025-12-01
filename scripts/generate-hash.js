const bcrypt = require('bcrypt');

async function generateHash() {
    const password = 'Admin123!';
    const hash = await bcrypt.hash(password, 10);

    console.log('Password:', password);
    console.log('Hash:', hash);
    console.log('\n--- SQL para actualizar usuarios ---');
    console.log(`UPDATE users SET password_hash = '${hash}' WHERE role IN ('super_admin', 'tenant_admin', 'tenant_user');`);
}

generateHash();
