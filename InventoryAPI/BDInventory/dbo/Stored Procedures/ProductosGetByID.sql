
CREATE   PROCEDURE dbo.ProductosGetByID
    @ProductoID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            P.ProductoID                        [Producto ID]       ,
            P.CodigoProducto                    [Codigo de producto],
            P.ProductoName                      [Nombre de Producto],
            P.ProductoDescription               [Descripcion]       ,
            C.CategoriaName                     [Categoria]         ,
            P.UnitPrice                         [Precio Unitario]   ,
            P.Stock                             [Stock]             ,
            P.MinimumStock                      [Stock minimo]      ,
            case
            when
                P.ProductoStatus=1 then 'Activo'
            else 'Inactivo'
            end [Estado],
            CONVERT(varchar,P.CreatedAt,103)    [Fecha de creacion]         ,
            CONVERT(varchar,P.UpdatedAt,103)    [Fecha de modificacion]    ,
            CONVERT(varchar,P.DeletedDate,103)  [Fecha de desactivacion]   
        FROM 
            dbo.Productos P WITH(nolock)
        INNER JOIN dbo.Categorias C WITH(nolock)
            ON P.CategoriaID = C.CategoriaID
        WHERE 
            P.ProductoID = @ProductoID and
            P.DeletedDate IS NULL
        ORDER BY 
            P.ProductoName ASC;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;