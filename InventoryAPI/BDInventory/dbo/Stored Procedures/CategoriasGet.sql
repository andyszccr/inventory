
CREATE  PROCEDURE dbo.CategoriasGet
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            CategoriaID                 [Codigo Categoria],
            CategoriaName               [Categoria],
            CategoriaDescription        [Descripcion],
            case
            when CategoriasStatus  =1 then 'Activo'
            else    'Inactivo'
            end   [Estado]                    ,     
            CONVERT(varchar,CreateDate,103)     [Fecha de creacion]         ,
            CONVERT(varchar,ModifiedDate,103)    [Fecha de modificacion]    ,
            CONVERT(varchar,DeletedDate,103)     [Fecha de desactivacion]   
        FROM dbo.Categorias
        WHERE DeletedDate IS NULL
        ORDER BY CategoriaName ASC;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;