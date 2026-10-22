# Diccionario de base de datos

Base de datos: `InventoryManagementDB`.

Las tablas se relacionan así: un rol tiene muchos usuarios, una categoría tiene muchos productos, y un movimiento de inventario apunta a un producto y al usuario que lo registró.

## Roles

| Nombre | Tipo | Llave | Descripción |
| --- | --- | --- | --- |
| RoleID | INT IDENTITY | PK | Identificador del rol. |
| RolesName | VARCHAR(50) | | Nombre del rol. No se repite. |
| RolesDescription | VARCHAR(200) | | Descripción del rol. |
| IsActive | BIT | | 1 activo, 0 inactivo. Por defecto 1. |
| CreateDate | DATETIME | | Fecha de creación. |
| ModifiedDate | DATETIME | | Fecha de la última modificación. |
| DeletedDate | DATETIME | | Fecha de desactivación. |

## Usuarios

| Nombre | Tipo | Llave | Descripción |
| --- | --- | --- | --- |
| UsuariosID | INT IDENTITY | PK | Identificador del usuario. |
| NombreCompleto | VARCHAR(150) | | Nombre completo. |
| Email | VARCHAR(150) | | Correo. No se repite. |
| PasswordHash | VARCHAR(500) | | Hash de la contraseña. No se guarda en texto plano. |
| RoleId | INT | FK → Roles.RoleID | Rol asignado al usuario. |
| UsuarioStatus | BIT | | 1 activo, 0 inactivo. Por defecto 1. |
| CreateDate | DATETIME | | Fecha de creación. |
| ModifiedDate | DATETIME | | Fecha de la última modificación. |
| DeletedDate | DATETIME | | Fecha de desactivación. |

## Categorias

| Nombre | Tipo | Llave | Descripción |
| --- | --- | --- | --- |
| CategoriaID | INT IDENTITY | PK | Identificador de la categoría. |
| CategoriaName | VARCHAR(100) | | Nombre de la categoría. |
| CategoriaDescription | VARCHAR(250) | | Descripción de la categoría. |
| CategoriasStatus | BIT | | 1 activa, 0 inactiva. Por defecto 1. |
| CreateDate | DATETIME | | Fecha de creación. |
| ModifiedDate | DATETIME | | Fecha de la última modificación. |
| DeletedDate | DATETIME | | Fecha de desactivación. |

## Productos

| Nombre | Tipo | Llave | Descripción |
| --- | --- | --- | --- |
| ProductoID | INT IDENTITY | PK | Identificador del producto. |
| CodigoProducto | VARCHAR(50) | | Código del producto. No se repite. |
| ProductoName | VARCHAR(150) | | Nombre del producto. |
| ProductoDescription | VARCHAR(500) | | Descripción del producto. |
| CategoriaID | INT | FK → Categorias.CategoriaID | Categoría a la que pertenece. |
| UnitPrice | DECIMAL(18, 2) | | Precio unitario. |
| Stock | DECIMAL(18, 2) | | Existencia actual. Por defecto 0. |
| MinimumStock | DECIMAL(18, 2) | | Stock mínimo. Por defecto 0. |
| ProductoStatus | BIT | | 1 activo, 0 inactivo. Por defecto 1. |
| CreatedAt | DATETIME | | Fecha de creación. |
| UpdatedAt | DATETIME | | Fecha de la última modificación. |
| DeletedDate | DATETIME | | Fecha de desactivación. |

## MovimientosInventario

| Nombre | Tipo | Llave | Descripción |
| --- | --- | --- | --- |
| MovimientoID | INT IDENTITY | PK | Identificador del movimiento. |
| ProductoID | INT | FK → Productos.ProductoID | Producto afectado. |
| UsuariosID | INT | FK → Usuarios.UsuariosID | Usuario que registró el movimiento. |
| MovementType | VARCHAR(20) | | Tipo: ENTRADA, SALIDA o AJUSTE. |
| Cantidad | DECIMAL(18, 2) | | Cantidad del movimiento. |
| PreviousStock | DECIMAL(18, 2) | | Stock antes del movimiento. |
| NewStock | DECIMAL(18, 2) | | Stock después del movimiento. |
| Notes | VARCHAR(500) | | Nota opcional. |
| CreatedAt | DATETIME | | Fecha del movimiento. Por defecto la fecha actual. |

## Procedimientos almacenados

| Procedimiento | Descripción |
| --- | --- |
| dbo.RolesGet | Lista los roles. |
| dbo.RolesGetByID | Devuelve un rol por su identificador. |
| dbo.RolesInsert | Crea un rol. |
| dbo.RolesUpdate | Actualiza nombre, descripción y estado de un rol. |
| dbo.sp_Roles_Delete | Desactiva un rol. |
| dbo.UsuariosGet | Lista los usuarios activos. |
| dbo.UsuariosGetByID | Devuelve un usuario por su identificador. |
| dbo.UsuariosGetByEmail | Devuelve el usuario y el hash para el login. |
| dbo.UsuariosInsert | Crea un usuario con el hash de la contraseña. |
| dbo.UsuariosUpdate | Actualiza nombre, correo, rol y estado. |
| dbo.UsuariosDelete | Desactiva un usuario. |
| dbo.CategoriasGet | Lista las categorías no eliminadas. |
| dbo.CategoriasGetByID | Devuelve una categoría por su identificador. |
| dbo.CategoriasInsert | Crea una categoría activa. |
| dbo.CategoriasUpdate | Actualiza nombre, descripción y estado. |
| dbo.CategoriasDelete | Desactiva una categoría. |
| dbo.ProductosGet | Lista los productos no eliminados. |
| dbo.ProductosGetByID | Devuelve un producto por su identificador. |
| dbo.ProductosInsert | Crea un producto activo. |
| dbo.ProductosUpdate | Actualiza los datos y el estado del producto. |
| dbo.ProductosDelete | Desactiva un producto. |
| dbo.MovimientosInventarioGet | Lista los movimientos, del más reciente al más antiguo. |
| dbo.MovimientosInventarioInsert | Registra una entrada, salida o ajuste y actualiza el stock. |
