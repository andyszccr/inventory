
CREATE  PROCEDURE dbo.CategoriasGetByID
    @CategoriaID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            CategoriaID                         [Codigo Categoria]      ,
            CategoriaName                       [Categoria]             ,
            CategoriaDescription                [Descripcion]           ,
            case
            when CategoriasStatus  =1 then 'Activo'
            else    'Inactivo'
            end                                 [Estado]                ,     
            CONVERT(varchar,CreateDate,103)     [Fecha de creacion]     ,
            CONVERT(varchar,ModifiedDate,103)   [Fecha de modificacion] ,
            CONVERT(varchar,DeletedDate,103)    [Fecha de desactivacion]   
        FROM 
            dbo.Categorias with(nolock)
        WHERE 
            CategoriaID = @CategoriaID
            AND DeletedDate IS NULL;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;