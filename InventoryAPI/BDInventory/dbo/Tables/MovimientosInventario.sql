CREATE TABLE [dbo].[MovimientosInventario] (
    [MovimientoID]  INT             IDENTITY (1, 1) NOT NULL,
    [ProductoID]    INT             NOT NULL,
    [UsuariosID]    INT             NOT NULL,
    [MovementType]  VARCHAR (20)    NOT NULL,
    [Cantidad]      DECIMAL (18, 2) NOT NULL,
    [PreviousStock] DECIMAL (18, 2) NOT NULL,
    [NewStock]      DECIMAL (18, 2) NOT NULL,
    [Notes]         VARCHAR (500)   NULL,
    [CreatedAt]     DATETIME        DEFAULT (sysdatetime()) NOT NULL,
    PRIMARY KEY CLUSTERED ([MovimientoID] ASC),
    CONSTRAINT [FK_Movimientos_Productos] FOREIGN KEY ([ProductoID]) REFERENCES [dbo].[Productos] ([ProductoID]),
    CONSTRAINT [FK_Movimientos_Usuarios] FOREIGN KEY ([UsuariosID]) REFERENCES [dbo].[Usuarios] ([UsuariosID])
);

