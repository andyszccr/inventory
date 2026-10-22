# Manual técnico para probar las APIs

Sirve para Postman y para Bruno. La base de las peticiones es:

`http://localhost:5184`

La API se arranca desde la carpeta de la solución:

```powershell
dotnet run --project InventoryAPI --launch-profile http
```

En todas las peticiones con cuerpo usa el encabezado `Content-Type: application/json`.

## Cómo configurar Postman

1. Crea un environment con la variable `baseUrl` = `http://localhost:5184`.
2. En cada URL escribe `{{baseUrl}}/api/...`.
3. Después del login, copia el valor de `token` a una variable `token`.
4. En las peticiones protegidas, pestaña **Authorization**, tipo **Bearer Token**, valor `{{token}}`.

También puedes poner el encabezado a mano:

`Authorization: Bearer {{token}}`

## Cómo configurar Bruno

1. Crea una colección y abre **Environments**.
2. Agrega `baseUrl` = `http://localhost:5184` y `token` vacío.
3. La URL de cada request queda `{{baseUrl}}/api/...`.
4. En la petición de login, pestaña **Script** o **Post Response**, guarda el token:

```javascript
bru.setEnvVar("token", res.body.token);
```

5. En las peticiones protegidas, pestaña **Auth**, tipo **Bearer** y token `{{token}}`.

## Códigos que vas a ver

| Código | Qué significa |
| --- | --- |
| 200 | Consulta o actualización correcta. Trae JSON. |
| 201 | Registro creado. Trae un mensaje. |
| 204 | Borrado correcto. No trae cuerpo. No es un error. |
| 400 | Dato inválido: campo vacío, precio negativo, tipo de movimiento incorrecto. |
| 401 | Falta el token, está vencido o el correo y la contraseña no coinciden. |
| 404 | El id no existe o ya fue eliminado. |
| 409 | El nombre o el código ya existe. |

El token dura **120 minutos**. Si una petición protegida responde 401, vuelve a hacer login.

Estas rutas piden token: roles, categorías, productos, movimientos, y también consultar, editar y eliminar usuarios. Crear usuario y hacer login no lo piden.

## Orden recomendado

1. Crear un rol. Si la base está vacía y esta ruta responde 401, crea el primer rol directo en SQL Server y sigue con el usuario.
2. Crear un usuario con el `roleId` de ese rol. Esta ruta no pide token.
3. Hacer login y guardar el token.
4. Crear una categoría.
5. Crear un producto con el `categoriaId`.
6. Registrar un movimiento. Eso es lo que cambia el stock.

## 1. Roles

Requiere token.

### Crear

`POST {{baseUrl}}/api/roles`

```json
{
  "rolesName": "Administrador",
  "rolesDescription": "Acceso total",
  "isActive": true
}
```

Respuesta **201**. El cuerpo incluye `roleId`. Guárdalo para crear el usuario.

### Listar

`GET {{baseUrl}}/api/roles`

### Consultar uno

`GET {{baseUrl}}/api/roles/1`

### Actualizar

`PUT {{baseUrl}}/api/roles/1`

```json
{
  "rolesName": "Administrador",
  "rolesDescription": "Acceso total al inventario",
  "isActive": true
}
```

Respuesta **204**.

### Eliminar

`DELETE {{baseUrl}}/api/roles/1`

Respuesta **204**. Es una baja lógica.

## 2. Usuarios

Crear un usuario no pide token. El resto sí.

### Crear

`POST {{baseUrl}}/api/usuarios`

```json
{
  "nombreCompleto": "Ana Pérez",
  "email": "ana@inventario.local",
  "password": "ClaveSegura1",
  "roleId": 1
}
```

La contraseña debe tener al menos 8 caracteres. En la base se guarda solo el hash. Respuesta **201** con el mensaje `Usuario creado.`

### Login y token

`POST {{baseUrl}}/api/auth/login`

```json
{
  "email": "ana@inventario.local",
  "password": "ClaveSegura1"
}
```

Respuesta **200**:

```json
{
  "token": "eyJ...",
  "expiresAt": "2026-10-22T18:00:00Z",
  "usuario": {
    "usuariosId": 1,
    "nombreCompleto": "Ana Pérez",
    "email": "ana@inventario.local",
    "rol": "Administrador"
  }
}
```

Copia `token` a la variable de Postman o Bruno.

### Listar

`GET {{baseUrl}}/api/usuarios`

### Consultar uno

`GET {{baseUrl}}/api/usuarios/1`

### Actualizar

`PUT {{baseUrl}}/api/usuarios/1`

```json
{
  "nombreCompleto": "Ana Pérez",
  "email": "ana@inventario.local",
  "roleId": 1,
  "usuarioStatus": true
}
```

Esta ruta no cambia la contraseña. Respuesta **204**.

### Eliminar

`DELETE {{baseUrl}}/api/usuarios/1`

Respuesta **204**. El usuario queda inactivo.

## 3. Categorías

Requiere token.

### Crear

`POST {{baseUrl}}/api/categorias`

```json
{
  "categoriaName": "Bebidas",
  "categoriaDescription": "Productos líquidos",
  "categoriasStatus": true
}
```

Respuesta **201** con el mensaje `Categoría creada.` El alta siempre la deja activa. El id lo ves al listar.

### Listar

`GET {{baseUrl}}/api/categorias`

### Consultar una

`GET {{baseUrl}}/api/categorias/1`

### Actualizar

`PUT {{baseUrl}}/api/categorias/1`

```json
{
  "categoriaName": "Bebidas",
  "categoriaDescription": "Bebidas y refrescos",
  "categoriasStatus": true
}
```

Respuesta **200** con la categoría y `fechaModificacion` en formato `yyyy-MM-dd HH:mm`.

### Eliminar

`DELETE {{baseUrl}}/api/categorias/1`

Respuesta **204**. No trae cuerpo. La categoría deja de salir en el listado. Si repites el delete, responde **404**.

## 4. Productos

Requiere token. La categoría debe existir y estar activa. El stock no se envía aquí: entra y sale con los movimientos.

### Crear

`POST {{baseUrl}}/api/productos`

```json
{
  "codigoProducto": "BEB-001",
  "productoName": "Agua 600 ml",
  "productoDescription": "Agua purificada",
  "categoriaId": 1,
  "unitPrice": 12.50,
  "minimumStock": 10,
  "productoStatus": true
}
```

Respuesta **201** con el mensaje `Producto creado.`

### Listar

`GET {{baseUrl}}/api/productos`

### Consultar uno

`GET {{baseUrl}}/api/productos/1`

### Actualizar

`PUT {{baseUrl}}/api/productos/1`

```json
{
  "codigoProducto": "BEB-001",
  "productoName": "Agua 600 ml",
  "productoDescription": "Agua purificada sin gas",
  "categoriaId": 1,
  "unitPrice": 13.00,
  "minimumStock": 10,
  "productoStatus": true
}
```

Respuesta **200** con el producto actualizado. `productoStatus` en `false` lo deja inactivo, sin eliminarlo.

### Eliminar

`DELETE {{baseUrl}}/api/productos/1`

Respuesta **204**.

## 5. Movimientos de inventario

Requiere token. El producto y el usuario deben estar activos. `movementType` solo acepta `ENTRADA`, `SALIDA` o `AJUSTE`. La cantidad debe ser mayor que cero.

| Tipo | Efecto en el stock |
| --- | --- |
| ENTRADA | Suma la cantidad al stock actual. |
| SALIDA | Resta la cantidad. Si no alcanza, responde 400. |
| AJUSTE | Deja el stock igual a la cantidad enviada. |

### Registrar entrada

`POST {{baseUrl}}/api/movimientos`

```json
{
  "productoId": 1,
  "usuariosId": 1,
  "movementType": "ENTRADA",
  "cantidad": 10,
  "notes": "Compra de mercancía"
}
```

Respuesta **201** con el mensaje `Movimiento registrado.`

### Registrar salida

`POST {{baseUrl}}/api/movimientos`

```json
{
  "productoId": 1,
  "usuariosId": 1,
  "movementType": "SALIDA",
  "cantidad": 2,
  "notes": "Venta"
}
```

### Ajuste

`POST {{baseUrl}}/api/movimientos`

```json
{
  "productoId": 1,
  "usuariosId": 1,
  "movementType": "AJUSTE",
  "cantidad": 25,
  "notes": "Conteo físico"
}
```

### Listar

`GET {{baseUrl}}/api/movimientos`

El listado viene del más reciente al más antiguo e incluye stock previo y stock nuevo.

## Si algo falla al conectar

- `ECONNRESET` o la petición tarda mucho: la API no está corriendo o SQL no aceptó la conexión. Arranca de nuevo con el comando de arriba.
- **401** en una ruta protegida: falta el encabezado `Authorization: Bearer {token}` o el token ya venció.
- **400** al crear un producto: la categoría no está activa.
- **404** al repetir un delete: el registro ya fue desactivado. Eso es lo esperado.
