
CREATE  PROCEDURE dbo.MovimientosInventarioGet
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            M.MovimientoID      [codigo de movimiento]          ,
            P.CodigoProducto    [codigo de producto]            ,
            P.ProductoName      [Nombre de producto]            ,
            M.UsuariosID        [codigo de usuario]             ,
            U.NombreCompleto    [Nombre de usuario]             ,
            M.MovementType      [tipo de movimiento]            ,
            M.Cantidad          [cantidad]                      ,
            M.PreviousStock     [stock previo]                  ,
            M.NewStock,
            M.Notes,
            CONVERT(varchar,M.CreatedAt,103)    [Fecha de desactivacion]   
        FROM dbo.MovimientosInventario  M with(nolock)
        INNER JOIN dbo.Productos        P with(nolock)
            ON M.ProductoID = P.ProductoID
        INNER JOIN dbo.Usuarios         U with(nolock)
            ON M.UsuariosID = U.UsuariosID
        ORDER BY 
            M.CreatedAt DESC, 
            M.MovimientoID DESC;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;