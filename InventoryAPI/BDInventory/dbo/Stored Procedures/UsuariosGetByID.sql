CREATE   PROCEDURE dbo.UsuariosGetByID
    @UsuariosID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            U.UsuariosID        [Codigo Usuario]                            ,
            U.NombreCompleto    [Nombre de Usuario]                         ,
            U.Email             [Correo electronico]                        ,
            R.RolesName         [Rol]                                       ,    
            case
            when  U.UsuarioStatus=1 then 'Activo'
            else    'Inactivo'
            end                                 [Estado]                     ,
            CONVERT(varchar,U.CreateDate,103)     [Fecha de creacion]        , 
            CONVERT(varchar,U.ModifiedDate,103)    [Fecha de modificacion]   ,
            CONVERT(varchar,U.DeletedDate,103)     [Fecha de desactivacion]   
        FROM dbo.Usuarios U
        INNER JOIN dbo.Roles R
            ON U.RoleId = R.RoleID
        WHERE U.UsuariosID = @UsuariosID
          AND U.DeletedDate IS NULL;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;