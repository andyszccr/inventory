# Inventory

Sistema de inventario con API en ASP.NET Core, cliente en Angular y base de datos en SQL Server.

Cubre roles, usuarios, categorías, productos y movimientos de stock. El stock de un producto no se edita en su ficha: un alta lo deja en 0 y las existencias cambian solo al registrar un movimiento.

## Estructura

```
Inventory/
├── InventoryAPI/
│   ├── InventoryAPI/       API HTTP (controladores, JWT, configuración)
│   ├── Application/        Casos de uso
│   ├── Infraestructure/    Acceso a datos (Dapper y procedimientos almacenados)
│   └── BDInventory/        Proyecto de base de datos (SSDT)
└── InventoryManagement.Client/   Aplicación Angular
```

| Proyecto | Rol |
| --- | --- |
| `InventoryAPI` | Punto de entrada HTTP. .NET 10. |
| `Application` | Validación y reglas de negocio. |
| `Infraestructure` | Conexión a SQL Server y repositorios. |
| `BDInventory` | Tablas y procedimientos para publicar en SQL Server. |
| `InventoryManagement.Client` | Pantallas de roles, categorías, productos, movimientos y usuarios. Angular 22. |

## Funcionalidad

| Módulo | Operaciones |
| --- | --- |
| Roles | Listar, crear, editar y baja lógica. |
| Categorías | Listar, crear, editar y baja lógica. |
| Productos | Listar, crear, editar y baja lógica. El alta deja el stock en 0. |
| Movimientos | Listar y registrar entrada, salida o ajuste. |
| Usuarios | Iniciar sesión, listar activos, crear, editar y baja lógica. |

Tipos de movimiento:

- **ENTRADA** suma la cantidad al stock.
- **SALIDA** resta la cantidad. No deja el stock en negativo.
- **AJUSTE** deja el stock en la cantidad indicada. Esa cantidad tiene que ser mayor que cero, así que el ajuste no puede dejar el stock en 0.

La baja de categorías, productos y usuarios no borra la fila: marca el registro como inactivo y guarda la fecha. La lista de usuarios muestra solo cuentas activas.

## API

La API escucha en `https://localhost:7156` y `http://localhost:5184` con el perfil HTTPS. En desarrollo, OpenAPI queda en `/openapi/v1.json`.

| Método | Ruta | Sesión |
| --- | --- | --- |
| `POST` | `/api/auth/login` | Pública. Devuelve el token JWT. |
| `GET` `POST` `PUT` `DELETE` | `/api/roles` | Requiere token. |
| `GET` `POST` `PUT` `DELETE` | `/api/categorias` | Requiere token. |
| `GET` `POST` `PUT` `DELETE` | `/api/productos` | Requiere token. El cuerpo no incluye stock. |
| `GET` `POST` | `/api/movimientos` | Requiere token. |
| `POST` | `/api/usuarios` | Pública. Alta de la primera cuenta. |
| `GET` `PUT` `DELETE` | `/api/usuarios` | Requiere token. |

El token dura 120 minutos. `PUT` y `DELETE` de usuarios responden **204** sin cuerpo.

## Base de datos

Base esperada por la API: `InventoryManagementDB`, en la instancia local `localhost\DEVELOPER`.

| Tabla | Contenido |
| --- | --- |
| `Roles` | Roles de usuario. |
| `Usuarios` | Cuentas (correo único, hash de contraseña, rol). |
| `Categorias` | Categorías de producto. |
| `Productos` | Código único, precio, stock, stock mínimo y categoría. |
| `MovimientosInventario` | Entrada, salida o ajuste: cantidad, stock anterior y stock nuevo. |

Publica `InventoryAPI/BDInventory/BDInventory.sqlproj` desde Visual Studio (SQL Server Data Tools). El nombre de la base publicada debe coincidir con la cadena de conexión. Los procedimientos de productos ya no reciben el stock: `ProductosInsert` lo guarda en 0 y `ProductosUpdate` no lo modifica.

## Requisitos

- [.NET SDK 10](https://dotnet.microsoft.com/download)
- [Node.js](https://nodejs.org/) con npm 11
- SQL Server local
- Visual Studio con SSDT, para publicar `BDInventory`

## Configuración

La cadena de conexión y el JWT están en `InventoryAPI/InventoryAPI/appsettings.json`.

```json
"ConnectionStrings": {
  "InventoryManagementDB": "Server=lpc:localhost\\DEVELOPER;Database=InventoryManagementDB;Trusted_Connection=True;TrustServerCertificate=True;Connect Timeout=8;"
},
"Jwt": {
  "Issuer": "InventoryAPI",
  "Audience": "InventoryAPI",
  "Key": "ReemplazaEstaLlaveJwtPorUnaSecretaDe32+",
  "ExpiresMinutes": 120
}
```

Usa autenticación de Windows. Si la cadena falta, o si la llave JWT tiene menos de 32 bytes, la API no arranca.

## Cómo ejecutarlo

API, con el perfil HTTPS. El cliente depende de `https://localhost:7156`:

```bash
cd InventoryAPI
dotnet run --project InventoryAPI --launch-profile https
```

Cliente en http://localhost:4200. Sin sesión abre la pantalla de entrada. Con sesión, **Cerrar sesión** queda en la barra. `ng serve` reenvía `/api` a `https://localhost:7156`:

```bash
cd InventoryManagement.Client
npm install
npm start
```

Pruebas del cliente:

```bash
npm test
```

## Referencias

- [Angular](https://angular.dev/): framework del cliente.
- [AlertifyJS](https://alertifyjs.com/): diálogos y avisos del cliente.
- [Funciones y formatos de SQL CONVERT para fechas](https://www.sqlshack.com/es/funciones-y-formatos-de-sql-convert-date/): estilos de `CONVERT` usados en los procedimientos que devuelven fechas.
