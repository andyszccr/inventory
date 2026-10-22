CREATE TABLE [dbo].[Categorias] (
    [CategoriaID]          INT           IDENTITY (1, 1) NOT NULL,
    [CategoriaName]        VARCHAR (100) NOT NULL,
    [CategoriaDescription] VARCHAR (250) NULL,
    [CategoriasStatus]     BIT           DEFAULT ((1)) NOT NULL,
    [CreateDate]           DATETIME      NULL,
    [ModifiedDate]         DATETIME      NULL,
    [DeletedDate]          DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([CategoriaID] ASC)
);

