# Test Chatbot

$tenantId = "a1b2c3d4-e5f6-7890-1234-567890abcdef" # Tienda Don Jose

# 1. Test Context (Store Name)
Write-Host "Testing Context..."
Invoke-RestMethod -Uri "http://localhost:3000/chatbot/message" -Method Post -Headers @{ "x-tenant-id" = $tenantId } -Body (@{ message = "¿cómo se llama la tienda?" } | ConvertTo-Json) -ContentType "application/json"

# 2. Test Product Search (Coca Cola)
Write-Host "`nTesting Product Search..."
Invoke-RestMethod -Uri "http://localhost:3000/chatbot/message" -Method Post -Headers @{ "x-tenant-id" = $tenantId } -Body (@{ message = "tienen coca cola?" } | ConvertTo-Json) -ContentType "application/json"
