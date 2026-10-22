CREATE TABLE [dbo].[Productos] (
    [ProductoID]          INT             IDENTITY (1, 1) NOT NULL,
    [CodigoProducto]      VARCHAR (50)    NOT NULL,
    [ProductoName]        VARCHAR (150)   NOT NULL,
    [ProductoDescription] VARCHAR (500)   NULL,
    [CategoriaID]         INT             NOT NULL,
    [UnitPrice]           DECIMAL (18, 2) NOT NULL,
    [Stock]               DECIMAL (18, 2) DEFAULT ((0)) NOT NULL,
    [MinimumStock]        DECIMAL (18, 2) DEFAULT ((0)) NOT NULL,
    [ProductoStatus]      BIT             DEFAULT ((1)) NOT NULL,
    [CreatedAt]           DATETIME        NULL,
    [UpdatedAt]           DATETIME        NULL,
    [DeletedDate]         DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([ProductoID] ASC),
    CONSTRAINT [FK_Productos_Categorias] FOREIGN KEY ([CategoriaID]) REFERENCES [dbo].[Categorias] ([CategoriaID]),
    UNIQUE NONCLUSTERED ([CodigoProducto] ASC)
);

