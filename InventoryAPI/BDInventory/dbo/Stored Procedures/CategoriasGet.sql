
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
            CONVERT(varchar(16), CreateDate, 120)    [Fecha de creacion],
            CONVERT(varchar(16), ModifiedDate, 120) [Fecha de modificacion],
            CONVERT(varchar(16), DeletedDate, 120)  [Fecha de desactivacion]   
        FROM dbo.Categorias
        WHERE DeletedDate IS NULL
        ORDER BY CategoriaName ASC;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;