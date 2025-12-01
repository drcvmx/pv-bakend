# Ejemplo de uso del API mejorado

## Crear Producto con Variantes

### Request
```bash
curl -X POST http://localhost:3001/catalogo/productos \
  -H "Content-Type: application/json" \
  -H "x-tenant-id: a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11" \
  -d '{
    "nombre": "Coca Cola",
    "descripcion": "Refresco de cola carbonatada",
    "variantes": [
      {
        "nombreVariante": "600ml",
        "precio": 18.00,
        "costo": 12.00,
        "unidadMedida": "PZA"
      },
      {
        "nombreVariante": "2L",
        "precio": 35.00,
        "costo": 25.00,
        "unidadMedida": "PZA"
      },
      {
        "nombreVariante": "355ml Lata",
        "precio": 15.00,
        "costo": 10.00,
        "unidadMedida": "PZA"
      }
    ]
  }'
```

### Response
```json
{
  "id": "34",
  "tenantId": "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
  "nombre": "Coca Cola",
  "descripcion": "Refresco de cola carbonatada",
  "imagenUrl": null,
  "variantes": [
    {
      "id": "50",
      "tenantId": "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
      "productoId": "34",
      "nombreVariante": "600ml",
      "precio": "18.00",
      "costo": "12.00",
      "unidadMedida": "PZA",
      "trackStock": true
    },
    {
      "id": "51",
      "tenantId": "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
      "productoId": "34",
      "nombreVariante": "2L",
      "precio": "35.00",
      "costo": "25.00",
      "unidadMedida": "PZA",
      "trackStock": true
    },
    {
      "id": "52",
      "tenantId": "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
      "productoId": "34",
      "nombreVariante": "355ml Lata",
      "precio": "15.00",
      "costo": "10.00",
      "unidadMedida": "PZA",
      "trackStock": true
    }
  ]
}
```

---

## Eliminar Producto

### Request
```bash
curl -X DELETE http://localhost:3001/catalogo/productos/34 \
  -H "x-tenant-id: a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"
```

### Response
```json
{
  "message": "Product deleted successfully"
}
```

---

## Tenant IDs para Pruebas

- **Abarrotes Don Pepe**: `a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11`
- **Ferretería El Tornillo**: `2853318c-e931-4718-b955-4508168e6953`
- **Restaurante El Sazón**: `83cfebd6-0668-43d1-a26f-46f32fdd8944`

---

## Notas Importantes

✅ **Auto-assignación de IDs**: No necesitas proporcionar `id` ni `productoId`, se generan automáticamente  
✅ **Validación**: Si falta algún campo requerido, recibirás error 400 con detalles  
✅ **Segregación**: Cada tenant solo puede crear/eliminar sus propios productos  
✅ **Transaccional**: Si falla crear alguna variante, se revierte todo
