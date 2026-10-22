# Inventory

Sistema de inventario con API en ASP.NET Core, cliente en Angular y base de datos en SQL Server.

El esquema ya define productos, categorías, usuarios, roles y movimientos de stock. La API registra la conexión a SQL Server; el cliente es el esqueleto de Angular.

## Estructura

```
Inventory/
├── InventoryAPI/
│   ├── InventoryAPI/       API HTTP (controladores, configuración)
│   ├── Application/        Casos de uso
│   ├── Infraestructure/    Acceso a datos (Dapper, SQL Server)
│   └── BDInventory/        Proyecto de base de datos (SSDT)
└── InventoryManagement.Client/   Aplicación Angular
```

| Proyecto | Rol |
| --- | --- |
| `InventoryAPI` | Punto de entrada HTTP. .NET 10. |
| `Application` | Lógica de aplicación. |
| `Infraestructure` | Fábrica de conexiones SQL (`IDbConnectionFactory`) con Dapper y `Microsoft.Data.SqlClient`. |
| `BDInventory` | Tablas versionadas para publicar en SQL Server. |
| `InventoryManagement.Client` | Interfaz web. Angular 22. |

## Base de datos

Base esperada por la API: `InventoryManagementDB`.

| Tabla | Contenido |
| --- | --- |
| `Roles` | Roles de usuario. |
| `Usuarios` | Cuentas (correo único, hash de contraseña, rol). |
| `Categorias` | Categorías de producto. |
| `Productos` | Código único, precio, stock, stock mínimo y categoría. |
| `MovimientosInventario` | Entradas y salidas: tipo, cantidad, stock anterior y stock nuevo. |

Publica el proyecto `InventoryAPI/BDInventory/BDInventory.sqlproj` desde Visual Studio (SQL Server Data Tools) hacia una instancia local. El nombre de la base publicada debe coincidir con la cadena de conexión.

## Requisitos

- [.NET SDK 10](https://dotnet.microsoft.com/download)
- [Node.js](https://nodejs.org/) con npm 11
- SQL Server local
- Visual Studio con SSDT, para publicar `BDInventory`

## Configuración

La cadena de conexión está en `InventoryAPI/InventoryAPI/appsettings.json`, bajo el nombre `InventoryManagementDB`:

```json
"ConnectionStrings": {
  "InventoryManagementDB": "Server=localhost;Database=InventoryManagementDB;Trusted_Connection=True;TrustServerCertificate=True;"
}
```

Usa autenticación de Windows. Si la cadena falta o queda vacía, la API no arranca.

## Cómo ejecutarlo

API (perfil HTTPS, puertos `https://localhost:7156` y `http://localhost:5184`):

```bash
cd InventoryAPI
dotnet run --project InventoryAPI --launch-profile https
```

En desarrollo, el documento OpenAPI queda en `/openapi/v1.json`.

Cliente (http://localhost:4200):

```bash
cd InventoryManagement.Client
npm install
npm start
```

Pruebas del cliente:

```bash
npm test
```

## Estado actual

- Esquema de inventario definido en `BDInventory`.
- Infraestructura de conexión a SQL Server registrada en el arranque de la API.
- El controlador de ejemplo `WeatherForecast` sigue en la plantilla de ASP.NET Core.
- El cliente Angular aún no consume la API.
