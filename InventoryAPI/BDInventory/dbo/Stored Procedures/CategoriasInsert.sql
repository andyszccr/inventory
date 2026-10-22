
CREATE   PROCEDURE dbo.CategoriasInsert
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