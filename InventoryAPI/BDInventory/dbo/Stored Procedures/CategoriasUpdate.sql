
CREATE OR ALTER PROCEDURE dbo.CategoriasUpdate
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