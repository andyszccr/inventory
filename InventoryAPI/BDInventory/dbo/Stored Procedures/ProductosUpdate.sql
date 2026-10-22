
CREATE   PROCEDURE dbo.ProductosUpdate
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