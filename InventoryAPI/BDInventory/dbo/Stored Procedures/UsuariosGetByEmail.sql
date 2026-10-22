CREATE PROCEDURE dbo.UsuariosGetByEmail
    @Email VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            U.UsuariosID,
            U.NombreCompleto,
            U.Email,
            U.PasswordHash,
            U.RoleId,
            R.RolesName,
            U.UsuarioStatus
        FROM dbo.Usuarios U
        INNER JOIN dbo.Roles R
            ON U.RoleId = R.RoleID
        WHERE U.Email = @Email
          AND U.DeletedDate IS NULL;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
