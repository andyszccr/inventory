
CREATE PROCEDURE dbo.RolesGet
    @RoleID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            RoleID                              [Roles ID]          ,
            RolesName                           [Nombre ROl]        ,
            RolesDescription                    [Descripción]       ,
            case
            when IsActive=1 then 'Activo'
            else    'Inactivo'
            end                                 [Estado]                    ,
            CONVERT(varchar,CreateDate,103)     [Fecha de creacion]         ,
            CONVERT(varchar,ModifiedDate,103)    [Fecha de modificacion]    ,
            CONVERT(varchar,DeletedDate,103)     [Fecha de desactivacion]   
        FROM dbo.Roles
        WHERE DeletedDate IS NULL

    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;