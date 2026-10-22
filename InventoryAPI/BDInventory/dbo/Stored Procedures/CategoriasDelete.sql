
CREATE   PROCEDURE dbo.CategoriasDelete
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