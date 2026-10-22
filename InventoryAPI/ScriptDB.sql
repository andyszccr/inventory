USE [InventoryManagementDB]
GO
/****** Objeto: Table [dbo].[Categorias] Fecha de script: 22/10/2026 11:48:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categorias](
	[CategoriaID] [int] IDENTITY(1,1) NOT NULL,
	[CategoriaName] [varchar](100) NOT NULL,
	[CategoriaDescription] [varchar](250) NULL,
	[CategoriasStatus] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[DeletedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoriaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[MovimientosInventario] Fecha de script: 22/10/2026 11:48:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientosInventario](
	[MovimientoID] [int] IDENTITY(1,1) NOT NULL,
	[ProductoID] [int] NOT NULL,
	[UsuariosID] [int] NOT NULL,
	[MovementType] [varchar](20) NOT NULL,
	[Cantidad] [decimal](18, 2) NOT NULL,
	[PreviousStock] [decimal](18, 2) NOT NULL,
	[NewStock] [decimal](18, 2) NOT NULL,
	[Notes] [varchar](500) NULL,
	[CreatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MovimientoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Productos] Fecha de script: 22/10/2026 11:48:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Productos](
	[ProductoID] [int] IDENTITY(1,1) NOT NULL,
	[CodigoProducto] [varchar](50) NOT NULL,
	[ProductoName] [varchar](150) NOT NULL,
	[ProductoDescription] [varchar](500) NULL,
	[CategoriaID] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[Stock] [decimal](18, 2) NOT NULL,
	[MinimumStock] [decimal](18, 2) NOT NULL,
	[ProductoStatus] [bit] NOT NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
	[DeletedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Roles] Fecha de script: 22/10/2026 11:48:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[RolesName] [varchar](50) NOT NULL,
	[RolesDescription] [varchar](200) NULL,
	[IsActive] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[DeletedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Usuarios] Fecha de script: 22/10/2026 11:48:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[UsuariosID] [int] IDENTITY(1,1) NOT NULL,
	[NombreCompleto] [varchar](150) NOT NULL,
	[Email] [varchar](150) NOT NULL,
	[PasswordHash] [varchar](500) NOT NULL,
	[RoleId] [int] NOT NULL,
	[UsuarioStatus] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[DeletedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UsuariosID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Categorias] ON 
GO
INSERT [dbo].[Categorias] ([CategoriaID], [CategoriaName], [CategoriaDescription], [CategoriasStatus], [CreateDate], [ModifiedDate], [DeletedDate]) VALUES (1, N'Bebidas', N'Bebidas y refrescos', 1, CAST(N'2026-10-22T09:45:54.170' AS DateTime), CAST(N'2026-10-22T10:10:59.097' AS DateTime), NULL)
GO
INSERT [dbo].[Categorias] ([CategoriaID], [CategoriaName], [CategoriaDescription], [CategoriasStatus], [CreateDate], [ModifiedDate], [DeletedDate]) VALUES (2, N'Lácteos prueba', N'Descripción cambiada', 0, CAST(N'2026-10-22T09:49:40.223' AS DateTime), CAST(N'2026-10-22T09:50:19.107' AS DateTime), CAST(N'2026-10-22T09:50:45.950' AS DateTime))
GO
INSERT [dbo].[Categorias] ([CategoriaID], [CategoriaName], [CategoriaDescription], [CategoriasStatus], [CreateDate], [ModifiedDate], [DeletedDate]) VALUES (3, N'comidas', N'alimentos', 0, CAST(N'2026-10-22T10:05:19.050' AS DateTime), CAST(N'2026-10-22T10:10:25.513' AS DateTime), CAST(N'2026-10-22T10:22:23.017' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Categorias] OFF
GO
SET IDENTITY_INSERT [dbo].[MovimientosInventario] ON 
GO
INSERT [dbo].[MovimientosInventario] ([MovimientoID], [ProductoID], [UsuariosID], [MovementType], [Cantidad], [PreviousStock], [NewStock], [Notes], [CreatedAt]) VALUES (1, 1, 1, N'ENTRADA', CAST(10.00 AS Decimal(18, 2)), CAST(80.00 AS Decimal(18, 2)), CAST(90.00 AS Decimal(18, 2)), N'Compra de mercancía', CAST(N'2026-10-22T10:43:22.440' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[MovimientosInventario] OFF
GO
SET IDENTITY_INSERT [dbo].[Productos] ON 
GO
INSERT [dbo].[Productos] ([ProductoID], [CodigoProducto], [ProductoName], [ProductoDescription], [CategoriaID], [UnitPrice], [Stock], [MinimumStock], [ProductoStatus], [CreatedAt], [UpdatedAt], [DeletedDate]) VALUES (1, N'BEB-001', N'Agua 600 ml', N'Agua purificada sin gas', 1, CAST(15.00 AS Decimal(18, 2)), CAST(90.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), 1, CAST(N'2026-10-22T10:24:36.527' AS DateTime), CAST(N'2026-10-22T11:11:36.750' AS DateTime), NULL)
GO
INSERT [dbo].[Productos] ([ProductoID], [CodigoProducto], [ProductoName], [ProductoDescription], [CategoriaID], [UnitPrice], [Stock], [MinimumStock], [ProductoStatus], [CreatedAt], [UpdatedAt], [DeletedDate]) VALUES (2, N'PRU-001', N'Prueba editada', N'Solo para probar', 1, CAST(12.50 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)), 0, CAST(N'2026-10-22T10:36:55.500' AS DateTime), CAST(N'2026-10-22T10:37:33.523' AS DateTime), CAST(N'2026-10-22T10:38:10.390' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Productos] OFF
GO
SET IDENTITY_INSERT [dbo].[Roles] ON 
GO
INSERT [dbo].[Roles] ([RoleID], [RolesName], [RolesDescription], [IsActive], [CreateDate], [ModifiedDate], [DeletedDate]) VALUES (1, N'Administrador', N'Acceso completo al sistema', 1, CAST(N'2026-10-21T21:18:58.390' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Roles] ([RoleID], [RolesName], [RolesDescription], [IsActive], [CreateDate], [ModifiedDate], [DeletedDate]) VALUES (2, N'Apilador', N'Acceso cambios de apilador test', 1, CAST(N'2026-10-22T08:52:15.383' AS DateTime), CAST(N'2026-10-22T09:06:49.817' AS DateTime), NULL)
GO
INSERT [dbo].[Roles] ([RoleID], [RolesName], [RolesDescription], [IsActive], [CreateDate], [ModifiedDate], [DeletedDate]) VALUES (3, N'Rol prueba baja', N'Temporal', 0, CAST(N'2026-10-22T11:27:24.910' AS DateTime), NULL, CAST(N'2026-10-22T11:27:25.390' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Roles] OFF
GO
SET IDENTITY_INSERT [dbo].[Usuarios] ON 
GO
INSERT [dbo].[Usuarios] ([UsuariosID], [NombreCompleto], [Email], [PasswordHash], [RoleId], [UsuarioStatus], [CreateDate], [ModifiedDate], [DeletedDate]) VALUES (1, N'admin', N'admin@admin.com', N'PBKDF2-SHA256.100000.Wr/mJCkYTpT1yUo42ps6cg==.fSeTemFknVZsoBXmdDZQAgqh7F0oTHTT/r3h7IODItY=', 1, 1, CAST(N'2026-10-22T09:11:15.883' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Usuarios] ([UsuariosID], [NombreCompleto], [Email], [PasswordHash], [RoleId], [UsuarioStatus], [CreateDate], [ModifiedDate], [DeletedDate]) VALUES (2, N'admin2', N'admin2@admin.com', N'PBKDF2-SHA256.100000.sx9wNjR6xcHGzM6MZFHs2A==.N0Zm2/fStWDhTUpjbng6VYjhpn1iNY8MLhOzXP7bO5Y=', 1, 1, CAST(N'2026-10-22T09:25:31.660' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Usuarios] ([UsuariosID], [NombreCompleto], [Email], [PasswordHash], [RoleId], [UsuarioStatus], [CreateDate], [ModifiedDate], [DeletedDate]) VALUES (3, N'Cuenta de prueba', N'prueba.ui@inventario.local', N'PBKDF2-SHA256.100000.XzRQMv5BSPenZc6jT8m3Fw==.iDw55qTHDn+qHoSY7B8OoXYrzRA1GhUxkPvCmCDojbM=', 2, 0, CAST(N'2026-10-22T09:32:25.077' AS DateTime), NULL, CAST(N'2026-10-22T09:40:54.320' AS DateTime))
GO
INSERT [dbo].[Usuarios] ([UsuariosID], [NombreCompleto], [Email], [PasswordHash], [RoleId], [UsuarioStatus], [CreateDate], [ModifiedDate], [DeletedDate]) VALUES (4, N'Ana Temporal Editada', N'ana.temporal@inventario.local', N'PBKDF2-SHA256.100000.pdrYeW3NFXuATqIIyDW74w==.VsmcZuG4tzLDGZGk9aGQkrmFRZHOd3VBnnQa2Vw2GZI=', 2, 0, CAST(N'2026-10-22T09:38:52.300' AS DateTime), CAST(N'2026-10-22T09:39:32.897' AS DateTime), CAST(N'2026-10-22T09:40:04.617' AS DateTime))
GO
INSERT [dbo].[Usuarios] ([UsuariosID], [NombreCompleto], [Email], [PasswordHash], [RoleId], [UsuarioStatus], [CreateDate], [ModifiedDate], [DeletedDate]) VALUES (5, N'Temporal movimientos', N'mov.temporal@inventario.local', N'PBKDF2-SHA256.100000.GJWMglY3hYhiHwIK2HlM6w==./JFnPXvKZviPPMnsllGEjk145F8teK4Xe2R/70178I4=', 2, 0, CAST(N'2026-10-22T10:50:47.280' AS DateTime), NULL, CAST(N'2026-10-22T10:59:44.590' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [UQ__Producto__785B009FFEB5CABC] Fecha de script: 22/10/2026 11:48:18 ******/
ALTER TABLE [dbo].[Productos] ADD UNIQUE NONCLUSTERED 
(
	[CodigoProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [UQ__Roles__CD1DC953516321C3] Fecha de script: 22/10/2026 11:48:18 ******/
ALTER TABLE [dbo].[Roles] ADD UNIQUE NONCLUSTERED 
(
	[RolesName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [UQ__Usuarios__A9D10534AE444876] Fecha de script: 22/10/2026 11:48:18 ******/
ALTER TABLE [dbo].[Usuarios] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Categorias] ADD  DEFAULT ((1)) FOR [CategoriasStatus]
GO
ALTER TABLE [dbo].[MovimientosInventario] ADD  DEFAULT (sysdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Productos] ADD  DEFAULT ((0)) FOR [Stock]
GO
ALTER TABLE [dbo].[Productos] ADD  DEFAULT ((0)) FOR [MinimumStock]
GO
ALTER TABLE [dbo].[Productos] ADD  DEFAULT ((1)) FOR [ProductoStatus]
GO
ALTER TABLE [dbo].[Roles] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Usuarios] ADD  DEFAULT ((1)) FOR [UsuarioStatus]
GO
ALTER TABLE [dbo].[MovimientosInventario]  WITH CHECK ADD  CONSTRAINT [FK_Movimientos_Productos] FOREIGN KEY([ProductoID])
REFERENCES [dbo].[Productos] ([ProductoID])
GO
ALTER TABLE [dbo].[MovimientosInventario] CHECK CONSTRAINT [FK_Movimientos_Productos]
GO
ALTER TABLE [dbo].[MovimientosInventario]  WITH CHECK ADD  CONSTRAINT [FK_Movimientos_Usuarios] FOREIGN KEY([UsuariosID])
REFERENCES [dbo].[Usuarios] ([UsuariosID])
GO
ALTER TABLE [dbo].[MovimientosInventario] CHECK CONSTRAINT [FK_Movimientos_Usuarios]
GO
ALTER TABLE [dbo].[Productos]  WITH CHECK ADD  CONSTRAINT [FK_Productos_Categorias] FOREIGN KEY([CategoriaID])
REFERENCES [dbo].[Categorias] ([CategoriaID])
GO
ALTER TABLE [dbo].[Productos] CHECK CONSTRAINT [FK_Productos_Categorias]
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD  CONSTRAINT [FK_Usuarios_Roles] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([RoleID])
GO
ALTER TABLE [dbo].[Usuarios] CHECK CONSTRAINT [FK_Usuarios_Roles]
GO
/****** Objeto: StoredProcedure [dbo].[CategoriasDelete] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[CategoriasDelete]
    @CategoriaID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Categorias
            WHERE CategoriaID = @CategoriaID
              AND DeletedDate IS NULL
        )
            THROW 50003, 'La categoría no existe o ya fue eliminada.', 1;

        UPDATE c
        SET
            c.CategoriasStatus = 0,
            c.DeletedDate = GETDATE()
        from 
            dbo.Categorias c
        WHERE CategoriaID = @CategoriaID;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[CategoriasGet] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[CategoriasGet]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            CategoriaID                 [Codigo Categoria],
            CategoriaName               [Categoria],
            CategoriaDescription        [Descripcion],
            case
            when CategoriasStatus  =1 then 'Activo'
            else    'Inactivo'
            end   [Estado]                    ,     
            CONVERT(varchar(16), CreateDate, 120)    [Fecha de creacion],
            CONVERT(varchar(16), ModifiedDate, 120) [Fecha de modificacion],
            CONVERT(varchar(16), DeletedDate, 120)  [Fecha de desactivacion]   
        FROM dbo.Categorias
        WHERE DeletedDate IS NULL
        ORDER BY CategoriaName ASC;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[CategoriasGetByID] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[CategoriasGetByID]
    @CategoriaID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            CategoriaID                         [Codigo Categoria]      ,
            CategoriaName                       [Categoria]             ,
            CategoriaDescription                [Descripcion]           ,
            case
            when CategoriasStatus  =1 then 'Activo'
            else    'Inactivo'
            end                                 [Estado]                ,     
            CONVERT(varchar,CreateDate,103)     [Fecha de creacion]     ,
            CONVERT(varchar,ModifiedDate,103)   [Fecha de modificacion] ,
            CONVERT(varchar,DeletedDate,103)    [Fecha de desactivacion]   
        FROM 
            dbo.Categorias with(nolock)
        WHERE 
            CategoriaID = @CategoriaID
            AND DeletedDate IS NULL;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[CategoriasInsert] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[CategoriasInsert]
    @CategoriaName VARCHAR(100),
    @CategoriaDescription VARCHAR(250) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NULLIF(@CategoriaName, '') IS NULL
            THROW 50001, 'El nombre de la categoría es obligatorio.', 1;

        IF EXISTS (
            SELECT 1
            FROM dbo.Categorias
            WHERE CategoriaName = @CategoriaName
              AND DeletedDate IS NULL
        )
            THROW 50002, 'Ya existe una categoría con ese nombre.', 1;

        INSERT INTO dbo.Categorias
        (
            CategoriaName,
            CategoriaDescription,
            CategoriasStatus,
            CreateDate
        )
        VALUES
        (
            @CategoriaName,
            @CategoriaDescription,
            1,
            GETDATE()
        );

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[CategoriasUpdate] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[CategoriasUpdate]
    @CategoriaID INT,
    @CategoriaName VARCHAR(100),
    @CategoriaDescription VARCHAR(250) = NULL,
    @CategoriasStatus BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS 
        (
            SELECT 1
            FROM dbo.Categorias
            WHERE CategoriaID = @CategoriaID
              AND DeletedDate IS NULL
        )
            THROW 50003, 'La categoría no existe o fue eliminada.', 1;

        IF NULLIF(LTRIM(RTRIM(@CategoriaName)), '') IS NULL
            THROW 50001, 'El nombre de la categoría es obligatorio.', 1;

        IF EXISTS (
            SELECT 1
            FROM dbo.Categorias
            WHERE CategoriaName = @CategoriaName
              AND CategoriaID <> @CategoriaID
              AND DeletedDate IS NULL
        )
            THROW 50002, 'Ya existe una categoría con ese nombre.', 1;

        UPDATE c
        SET
            c.CategoriaName = @CategoriaName,
            c.CategoriaDescription = @CategoriaDescription,
            c.CategoriasStatus = @CategoriasStatus,
            c.ModifiedDate = GETDATE()
        from 
            dbo.Categorias c
        WHERE CategoriaID = @CategoriaID;

        COMMIT TRANSACTION;


    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[MovimientosInventarioGet] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[MovimientosInventarioGet]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            M.MovimientoID      [codigo de movimiento]          ,
            P.CodigoProducto    [codigo de producto]            ,
            P.ProductoName      [Nombre de producto]            ,
            M.UsuariosID        [codigo de usuario]             ,
            U.NombreCompleto    [Nombre de usuario]             ,
            M.MovementType      [tipo de movimiento]            ,
            M.Cantidad          [cantidad]                      ,
            M.PreviousStock     [stock previo]                  ,
            M.NewStock,
            M.Notes,
            CONVERT(varchar,M.CreatedAt,103)    [Fecha de desactivacion]   
        FROM dbo.MovimientosInventario  M with(nolock)
        INNER JOIN dbo.Productos        P with(nolock)
            ON M.ProductoID = P.ProductoID
        INNER JOIN dbo.Usuarios         U with(nolock)
            ON M.UsuariosID = U.UsuariosID
        ORDER BY 
            M.CreatedAt DESC, 
            M.MovimientoID DESC;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[MovimientosInventarioInsert] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[MovimientosInventarioInsert]
    @ProductoID INT,
    @UsuariosID INT,
    @MovementType VARCHAR(20),
    @Cantidad DECIMAL(18,2),
    @Notes VARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        SET @MovementType = @MovementType;

        IF @MovementType NOT IN ('ENTRADA', 'SALIDA', 'AJUSTE')
            THROW 50001, 'Tipo de movimiento inválido.', 1;

        IF @Cantidad <= 0
            THROW 50002, 'La cantidad debe ser mayor que cero.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Usuarios
            WHERE UsuariosID = @UsuariosID
              AND UsuarioStatus = 1
              AND DeletedDate IS NULL
        )
            THROW 50003, 'El usuario no existe o está inactivo.', 1;

        DECLARE @StockActual DECIMAL(18,2);
        DECLARE @NuevoStock DECIMAL(18,2);

        SELECT @StockActual = Stock
        FROM dbo.Productos WITH (UPDLOCK, HOLDLOCK)
        WHERE ProductoID = @ProductoID
          AND ProductoStatus = 1
          AND DeletedDate IS NULL;

        IF @StockActual IS NULL
            THROW 50004, 'El producto no existe o está inactivo.', 1;

        SET @NuevoStock =
            CASE @MovementType
                WHEN 'ENTRADA' THEN @StockActual + @Cantidad
                WHEN 'SALIDA'  THEN @StockActual - @Cantidad
                WHEN 'AJUSTE'  THEN @Cantidad
            END;

        IF @NuevoStock < 0
            THROW 50005, 'Stock insuficiente para realizar la salida.', 1;

        UPDATE dbo.Productos
        SET
            Stock = @NuevoStock,
            UpdatedAt = SYSDATETIME()
        WHERE ProductoID = @ProductoID;

        INSERT INTO dbo.MovimientosInventario
        (
            ProductoID,
            UsuariosID,
            MovementType,
            Cantidad,
            PreviousStock,
            NewStock,
            Notes
        )
        VALUES
        (
            @ProductoID,
            @UsuariosID,
            @MovementType,
            @Cantidad,
            @StockActual,
            @NuevoStock,
            @Notes
        );

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[ProductosDelete] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[ProductosDelete]
    @ProductoID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Productos
            WHERE ProductoID = @ProductoID
              AND DeletedDate IS NULL
        )
            THROW 50007, 'El producto no existe o ya fue eliminado.', 1;

        UPDATE dbo.Productos
        SET
            ProductoStatus  = 0,
            DeletedDate     = GETDATE()
        WHERE ProductoID = @ProductoID;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[ProductosGet] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ProductosGet]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            P.ProductoID                        [Producto ID]       ,
            P.CodigoProducto                    [Codigo de producto],
            P.ProductoName                      [Nombre de Producto],
            P.ProductoDescription               [Descripcion]       ,
            C.CategoriaName                     [Categoria]         ,
            P.UnitPrice                         [Precio Unitario]   ,
            P.Stock                             [Stock]             ,
            P.MinimumStock                      [Stock minimo]      ,
            case
            when
                P.ProductoStatus=1 then 'Activo'
            else 'Inactivo'
            end [Estado],
            CONVERT(varchar,P.CreatedAt,103)    [Fecha de creacion]         ,
            CONVERT(varchar,P.UpdatedAt,103)    [Fecha de modificacion]    ,
            CONVERT(varchar,P.DeletedDate,103)  [Fecha de desactivacion]   
        FROM 
            dbo.Productos P WITH(nolock)
        INNER JOIN dbo.Categorias C WITH(nolock)
            ON P.CategoriaID = C.CategoriaID
        WHERE 
            P.DeletedDate IS NULL
        ORDER BY 
            P.ProductoName ASC;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[ProductosGetByID] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     PROCEDURE [dbo].[ProductosGetByID]
    @ProductoID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            P.ProductoID                        [Producto ID]       ,
            P.CodigoProducto                    [Codigo de producto],
            P.ProductoName                      [Nombre de Producto],
            P.ProductoDescription               [Descripcion]       ,
            C.CategoriaName                     [Categoria]         ,
            P.UnitPrice                         [Precio Unitario]   ,
            P.Stock                             [Stock]             ,
            P.MinimumStock                      [Stock minimo]      ,
            case
            when
                P.ProductoStatus=1 then 'Activo'
            else 'Inactivo'
            end [Estado],
            CONVERT(varchar,P.CreatedAt,103)    [Fecha de creacion]         ,
            CONVERT(varchar,P.UpdatedAt,103)    [Fecha de modificacion]    ,
            CONVERT(varchar,P.DeletedDate,103)  [Fecha de desactivacion]   
        FROM 
            dbo.Productos P WITH(nolock)
        INNER JOIN dbo.Categorias C WITH(nolock)
            ON P.CategoriaID = C.CategoriaID
        WHERE 
            P.ProductoID = @ProductoID and
            P.DeletedDate IS NULL
        ORDER BY 
            P.ProductoName ASC;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[ProductosInsert] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[ProductosInsert]
    @CodigoProducto VARCHAR(50),
    @ProductoName VARCHAR(150),
    @ProductoDescription VARCHAR(500) = NULL,
    @CategoriaID INT,
    @UnitPrice DECIMAL(18,2),
    @MinimumStock DECIMAL(18,2) = 0
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NULLIF(@CodigoProducto, '') IS NULL
            THROW 50001, 'El código del producto es obligatorio.', 1;

        IF NULLIF(@ProductoName, '') IS NULL
            THROW 50002, 'El nombre del producto es obligatorio.', 1;

        IF @UnitPrice < 0
            THROW 50003, 'El precio no puede ser negativo.', 1;

        IF @MinimumStock < 0
            THROW 50004, 'El stock mínimo no puede ser negativo.', 1;

        IF EXISTS (
            SELECT 1
            FROM dbo.Productos
            WHERE CodigoProducto = @CodigoProducto
        )
            THROW 50005, 'El código del producto ya existe.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Categorias
            WHERE CategoriaID = @CategoriaID
              AND CategoriasStatus = 1
              AND DeletedDate IS NULL
        )
            THROW 50006, 'La categoría no existe o no está activa.', 1;

        INSERT INTO dbo.Productos
        (
            CodigoProducto,
            ProductoName,
            ProductoDescription,
            CategoriaID,
            UnitPrice,
            Stock,
            MinimumStock,
            ProductoStatus,
            CreatedAt
        )
        VALUES
        (
            @CodigoProducto,
            @ProductoName,
            @ProductoDescription,
            @CategoriaID,
            @UnitPrice,
            0,
            @MinimumStock,
            1,
            GETDATE()
        );

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[ProductosUpdate] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[ProductosUpdate]
    @ProductoID INT,
    @CodigoProducto VARCHAR(50),
    @ProductoName VARCHAR(150),
    @ProductoDescription VARCHAR(500) = NULL,
    @CategoriaID INT,
    @UnitPrice DECIMAL(18,2),
    @MinimumStock DECIMAL(18,2),
    @ProductoStatus BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Productos
            WHERE ProductoID = @ProductoID
              AND DeletedDate IS NULL
        )
            THROW 50007, 'El producto no existe o fue eliminado.', 1;

        IF NULLIF(@CodigoProducto, '') IS NULL
            THROW 50001, 'El código del producto es obligatorio.', 1;

        IF NULLIF(@ProductoName, '') IS NULL
            THROW 50002, 'El nombre del producto es obligatorio.', 1;

        IF @UnitPrice < 0
            THROW 50003, 'El precio no puede ser negativo.', 1;

        IF @MinimumStock < 0
            THROW 50004, 'El stock mínimo no puede ser negativo.', 1;

        IF EXISTS (
            SELECT 1
            FROM dbo.Productos
            WHERE CodigoProducto = @CodigoProducto
              AND ProductoID <> @ProductoID
        )
            THROW 50005, 'El código del producto ya existe.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Categorias
            WHERE CategoriaID = @CategoriaID
              AND CategoriasStatus = 1
              AND DeletedDate IS NULL
        )
            THROW 50006, 'La categoría no existe o no está activa.', 1;

        UPDATE p
        SET
            p.CodigoProducto        = @CodigoProducto,
            p.ProductoName          = @ProductoName,
            p.ProductoDescription   = @ProductoDescription,
            p.CategoriaID           = @CategoriaID,
            p.UnitPrice             = @UnitPrice,
            p.MinimumStock          = @MinimumStock,
            p.ProductoStatus        = @ProductoStatus,
            p.UpdatedAt             = GETDATE()
        from 
            dbo.Productos p with(nolock)
        WHERE ProductoID = @ProductoID;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[RolesGet] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[RolesGet]
    @RoleID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            RoleID                              [Roles ID]          ,
            RolesName                           [Nombre ROl]        ,
            RolesDescription                    [Descripción]       ,
            case
            when IsActive=1 then 'Activo'
            else    'Inactivo'
            end                                 [Estado]                    ,
            CONVERT(varchar,CreateDate,103)     [Fecha de creacion]         ,
            CONVERT(varchar,ModifiedDate,103)    [Fecha de modificacion]    ,
            CONVERT(varchar,DeletedDate,103)     [Fecha de desactivacion]   
        FROM dbo.Roles
        WHERE DeletedDate IS NULL

    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[RolesGetByID] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RolesGetByID]
    @RoleID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            RoleID                              [Roles ID]          ,
            RolesName                           [Nombre ROl]        ,
            RolesDescription                    [Descripción]       ,
            case
            when IsActive=1 then 'Activo'
            else    'Inactivo'
            end                                 [Estado]                    ,
            CONVERT(varchar,CreateDate,103)     [Fecha de creacion]         ,
            CONVERT(varchar,ModifiedDate,103)    [Fecha de modificacion]    ,
            CONVERT(varchar,DeletedDate,103)     [Fecha de desactivacion]   
        FROM dbo.Roles
        WHERE RoleID = @RoleID
          AND DeletedDate IS NULL;

    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[RolesInsert] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[RolesInsert]
    @RolesName VARCHAR(50),
    @RolesDescription VARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NULLIF(LTRIM(RTRIM(@RolesName)), '') IS NULL
        BEGIN
            THROW 50001, 'El nombre del rol es obligatorio.', 1;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.Roles
            WHERE RolesName = LTRIM(RTRIM(@RolesName))
        )
        BEGIN
            THROW 50002, 'El nombre del rol ya existe.', 1;
        END;

        INSERT INTO dbo.Roles
        (
            RolesName,
            RolesDescription,
            IsActive,
            CreateDate
        )
        VALUES
        (
            @RolesName,
            @RolesDescription,
            1,
            GETDATE()
        );

        DECLARE @RoleID INT = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SELECT
            RoleID,
            RolesName,
            RolesDescription,
            IsActive,
            CreateDate
        FROM dbo.Roles
        WHERE RoleID = @RoleID;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[RolesUpdate] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RolesUpdate]
    @RoleID INT,
    @RolesName VARCHAR(50),
    @RolesDescription VARCHAR(200) = NULL,
    @IsActive BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS 
        (
            SELECT 1
            FROM dbo.Roles
            WHERE RoleID = @RoleID
        )
        BEGIN
            THROW 50003, 'El rol no existe.', 1;
        END;

        IF NULLIF(LTRIM(RTRIM(@RolesName)), '') IS NULL
        BEGIN
            THROW 50001, 'El nombre del rol es obligatorio.', 1;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.Roles
            WHERE RolesName = LTRIM(RTRIM(@RolesName))
              AND RoleID <> @RoleID
        )
        BEGIN
            THROW 50002, 'El nombre del rol ya existe.', 1;
        END;

        UPDATE r
        SET
            r.RolesName = LTRIM(RTRIM(@RolesName)),
            r.RolesDescription = @RolesDescription,
            r.IsActive = @IsActive,
            r.ModifiedDate = GETDATE()
        from 
            dbo.Roles r with(nolock)
        WHERE RoleID = @RoleID;

        COMMIT TRANSACTION;


    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[sp_Roles_Delete] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Roles_Delete]
    @RoleID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS 
        (
            SELECT 1
            FROM dbo.Roles
            WHERE RoleID = @RoleID
        )
        BEGIN
            THROW 50003, 'El rol no existe.', 1;
        END;

        IF EXISTS 
        (
            SELECT 1
            FROM dbo.Roles
            WHERE RoleID = @RoleID
              AND DeletedDate IS NOT NULL
        )
        BEGIN
            THROW 50004, 'El rol ya fue eliminado.', 1;
        END;

        UPDATE r
        SET
            r.IsActive = 0,
            r.DeletedDate = GETDATE()
        from dbo.Roles r
        WHERE RoleID = @RoleID;

        COMMIT TRANSACTION;

        SELECT
            RoleID,
            RolesName,
            IsActive,
            DeletedDate
        FROM dbo.Roles
        WHERE RoleID = @RoleID;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[UsuariosDelete] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[UsuariosDelete]
    @UsuariosID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM dbo.Usuarios WHERE UsuariosID = @UsuariosID AND DeletedDate IS NULL)
            THROW 50006, 'El usuario no existe o ya fue eliminado.', 1;

        UPDATE u
        SET
            u.UsuarioStatus = 0,
            u.DeletedDate = GETDATE()
        From 
            Usuarios u with(nolock)
        WHERE 
            UsuariosID = @UsuariosID;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[UsuariosGet] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[UsuariosGet]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            U.UsuariosID        [Codigo Usuario]                            ,
            U.NombreCompleto    [Nombre de Usuario]                         ,
            U.Email             [Correo electronico]                        ,
            R.RolesName         [Rol]                                       ,    
            case
            when  U.UsuarioStatus=1 then 'Activo'
            else    'Inactivo'
            end                                 [Estado]                    ,
            CONVERT(varchar,U.CreateDate,103)     [Fecha de creacion]         ,
            CONVERT(varchar,U.ModifiedDate,103)    [Fecha de modificacion]    ,
            CONVERT(varchar,U.DeletedDate,103)     [Fecha de desactivacion]   
        FROM 
            dbo.Usuarios U with(nolock)
        INNER JOIN dbo.Roles R with(nolock)
            ON U.RoleId = R.RoleID
        WHERE 
            U.UsuarioStatus =1

        ORDER BY U.UsuariosID DESC;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[UsuariosGetByEmail] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[UsuariosGetByEmail]
    @Email VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            U.UsuariosID,
            U.NombreCompleto,
            U.Email,
            U.PasswordHash,
            U.RoleId,
            R.RolesName,
            U.UsuarioStatus
        FROM dbo.Usuarios U
        INNER JOIN dbo.Roles R
            ON U.RoleId = R.RoleID
        WHERE U.Email = @Email
          AND U.DeletedDate IS NULL;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[UsuariosGetByID] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[UsuariosGetByID]
    @UsuariosID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            U.UsuariosID        [Codigo Usuario]                            ,
            U.NombreCompleto    [Nombre de Usuario]                         ,
            U.Email             [Correo electronico]                        ,
            R.RolesName         [Rol]                                       ,    
            case
            when  U.UsuarioStatus=1 then 'Activo'
            else    'Inactivo'
            end                                 [Estado]                     ,
            CONVERT(varchar,U.CreateDate,103)     [Fecha de creacion]        , 
            CONVERT(varchar,U.ModifiedDate,103)    [Fecha de modificacion]   ,
            CONVERT(varchar,U.DeletedDate,103)     [Fecha de desactivacion]   
        FROM dbo.Usuarios U
        INNER JOIN dbo.Roles R
            ON U.RoleId = R.RoleID
        WHERE U.UsuariosID = @UsuariosID
          AND U.DeletedDate IS NULL;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[UsuariosInsert] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UsuariosInsert]
    @NombreCompleto VARCHAR(150),
    @Email VARCHAR(150),
    @PasswordHash VARCHAR(500),
    @RoleId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NULLIF(@NombreCompleto, '') IS NULL
            THROW 50001, 'El nombre completo es obligatorio.', 1;

        IF NULLIF(@Email, '') IS NULL
            THROW 50002, 'El correo electrónico es obligatorio.', 1;

        IF NULLIF(@PasswordHash, '') IS NULL
            THROW 50003, 'El hash de la contraseña es obligatorio.', 1;

        IF EXISTS (SELECT 1 FROM dbo.Usuarios WHERE Email = @Email)
            THROW 50004, 'El correo electrónico ya está registrado.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Roles
            WHERE RoleID = @RoleId
              AND IsActive = 1
              AND DeletedDate IS NULL
        )
            THROW 50005, 'El rol no existe o no está activo.', 1;

        INSERT INTO dbo.Usuarios
        (
            NombreCompleto,
            Email,
            PasswordHash,
            RoleId,
            UsuarioStatus,
            CreateDate
        )
        VALUES
        (
            @NombreCompleto,
            @Email,
            @PasswordHash,
            @RoleId,
            1,
            GETDATE()
        );

        COMMIT TRANSACTION;


    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
/****** Objeto: StoredProcedure [dbo].[UsuariosUpdate] Fecha de script: 22/10/2026 11:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UsuariosUpdate]
    @UsuariosID INT,
    @NombreCompleto VARCHAR(150),
    @Email VARCHAR(150),
    @RoleId INT,
    @UsuarioStatus BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Usuarios
            WHERE UsuariosID = @UsuariosID
              AND DeletedDate IS NULL
        )
            THROW 50006, 'El usuario no existe o fue eliminado.', 1;

        IF NULLIF(@NombreCompleto, '') IS NULL
            THROW 50001, 'El nombre completo es obligatorio.', 1;

        IF NULLIF(@Email, '') IS NULL
            THROW 50002, 'El correo electrónico es obligatorio.', 1;

        IF EXISTS (
            SELECT 1
            FROM dbo.Usuarios
            WHERE Email = LTRIM(RTRIM(@Email))
              AND UsuariosID <> @UsuariosID
        )
            THROW 50004, 'El correo electrónico ya está registrado.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Roles
            WHERE RoleID = @RoleId
              AND IsActive = 1
              AND DeletedDate IS NULL
        )
            THROW 50005, 'El rol no existe o no está activo.', 1;

        UPDATE U
        SET
            U.NombreCompleto = @NombreCompleto,
            U.Email = @Email,
            U.RoleId = @RoleId,
            U.UsuarioStatus = @UsuarioStatus,
            U.ModifiedDate = GETDATE()
        FROM 
            Usuarios U with(nolock) 
        WHERE U.UsuariosID = @UsuariosID;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
