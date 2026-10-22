CREATE TABLE [dbo].[Usuarios] (
    [UsuariosID]     INT           IDENTITY (1, 1) NOT NULL,
    [NombreCompleto] VARCHAR (150) NOT NULL,
    [Email]          VARCHAR (150) NOT NULL,
    [PasswordHash]   VARCHAR (500) NOT NULL,
    [RoleId]         INT           NOT NULL,
    [UsuarioStatus]  BIT           DEFAULT ((1)) NOT NULL,
    [CreateDate]     DATETIME      NULL,
    [ModifiedDate]   DATETIME      NULL,
    [DeletedDate]    DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([UsuariosID] ASC),
    CONSTRAINT [FK_Usuarios_Roles] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([RoleID]),
    UNIQUE NONCLUSTERED ([Email] ASC)
);

