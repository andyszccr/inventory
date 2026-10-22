
CREATE PROCEDURE dbo.MovimientosInventarioInsert
    @ProductoID INT,
    @UsuariosID INT,
    @MovementType VARCHAR(20),
    @Cantidad DECIMAL(18,2),
    @Notes VARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        SET @MovementType = @MovementType;

        IF @MovementType NOT IN ('ENTRADA', 'SALIDA', 'AJUSTE')
            THROW 50001, 'Tipo de movimiento inválido.', 1;

        IF @Cantidad <= 0
            THROW 50002, 'La cantidad debe ser mayor que cero.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Usuarios
            WHERE UsuariosID = @UsuariosID
              AND UsuarioStatus = 1
              AND DeletedDate IS NULL
        )
            THROW 50003, 'El usuario no existe o está inactivo.', 1;

        DECLARE @StockActual DECIMAL(18,2);
        DECLARE @NuevoStock DECIMAL(18,2);

        SELECT @StockActual = Stock
        FROM dbo.Productos WITH (UPDLOCK, HOLDLOCK)
        WHERE ProductoID = @ProductoID
          AND ProductoStatus = 1
          AND DeletedDate IS NULL;

        IF @StockActual IS NULL
            THROW 50004, 'El producto no existe o está inactivo.', 1;

        SET @NuevoStock =
            CASE @MovementType
                WHEN 'ENTRADA' THEN @StockActual + @Cantidad
                WHEN 'SALIDA'  THEN @StockActual - @Cantidad
                WHEN 'AJUSTE'  THEN @Cantidad
            END;

        IF @NuevoStock < 0
            THROW 50005, 'Stock insuficiente para realizar la salida.', 1;

        UPDATE dbo.Productos
        SET
            Stock = @NuevoStock,
            UpdatedAt = SYSDATETIME()
        WHERE ProductoID = @ProductoID;

        INSERT INTO dbo.MovimientosInventario
        (
            ProductoID,
            UsuariosID,
            MovementType,
            Cantidad,
            PreviousStock,
            NewStock,
            Notes
        )
        VALUES
        (
            @ProductoID,
            @UsuariosID,
            @MovementType,
            @Cantidad,
            @StockActual,
            @NuevoStock,
            @Notes
        );

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;