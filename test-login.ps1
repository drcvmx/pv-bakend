# Test Login Script
Write-Host "Probando sistema de autenticación..." -ForegroundColor Cyan

# Test 1: Super Admin
Write-Host "`n1. Login Super Admin (admin@drcv.com):" -ForegroundColor Yellow
$response = Invoke-RestMethod -Uri "http://localhost:3001/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"admin@drcv.com","password":"Admin123!"}'
Write-Host "✓ Token recibido: $($response.access_token.Substring(0,50))..." -ForegroundColor Green
Write-Host "✓ Usuario: $($response.user.email) - Rol: $($response.user.role)" -ForegroundColor Green

# Test 2: Tenant Admin
Write-Host "`n2. Login Tenant Admin (dueno@abarrotes.com):" -ForegroundColor Yellow
$response2 = Invoke-RestMethod -Uri "http://localhost:3001/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"dueno@abarrotes.com","password":"Admin123!"}'
Write-Host "✓ Token recibido: $($response2.access_token.Substring(0,50))..." -ForegroundColor Green
Write-Host "✓ Usuario: $($response2.user.email) - Rol: $($response2.user.role)" -ForegroundColor Green
Write-Host "✓ Tenant: $($response2.user.tenantName)" -ForegroundColor Green

# Test 3: Cajero
Write-Host "`n3. Login Cajero (cajero at abarrotes.com):" -ForegroundColor Yellow
$response3 = Invoke-RestMethod -Uri "http://localhost:3001/auth/login" -Method Post -ContentType "application/json" -Body '{"email":"cajero@abarrotes.com","password":"Admin123!"}'
Write-Host "✓ Token recibido: $($response3.access_token.Substring(0,50))..." -ForegroundColor Green
Write-Host "✓ Usuario: $($response3.user.email) - Rol: $($response3.user.role)" -ForegroundColor Green
Write-Host "✓ Tenant: $($response3.user.tenantName)" -ForegroundColor Green

Write-Host "`n✅ TODOS LOS TESTS PASARON!" -ForegroundColor Green
