
CREATE   PROCEDURE dbo.ProductosDelete
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