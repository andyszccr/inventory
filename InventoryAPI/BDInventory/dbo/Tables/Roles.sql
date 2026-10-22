CREATE TABLE [dbo].[Roles] (
    [RoleID]           INT           IDENTITY (1, 1) NOT NULL,
    [RolesName]        VARCHAR (50)  NOT NULL,
    [RolesDescription] VARCHAR (200) NULL,
    [IsActive]         BIT           DEFAULT ((1)) NOT NULL,
    [CreateDate]       DATETIME      NULL,
    [ModifiedDate]     DATETIME      NULL,
    [DeletedDate]      DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([RoleID] ASC),
    UNIQUE NONCLUSTERED ([RolesName] ASC)
);

