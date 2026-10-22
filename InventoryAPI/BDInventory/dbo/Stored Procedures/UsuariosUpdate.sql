
CREATE PROCEDURE dbo.UsuariosUpdate
    @UsuariosID INT,
    @NombreCompleto VARCHAR(150),
    @Email VARCHAR(150),
    @RoleId INT,
    @UsuarioStatus BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Usuarios
            WHERE UsuariosID = @UsuariosID
              AND DeletedDate IS NULL
        )
            THROW 50006, 'El usuario no existe o fue eliminado.', 1;

        IF NULLIF(@NombreCompleto, '') IS NULL
            THROW 50001, 'El nombre completo es obligatorio.', 1;

        IF NULLIF(@Email, '') IS NULL
            THROW 50002, 'El correo electrónico es obligatorio.', 1;

        IF EXISTS (
            SELECT 1
            FROM dbo.Usuarios
            WHERE Email = LTRIM(RTRIM(@Email))
              AND UsuariosID <> @UsuariosID
        )
            THROW 50004, 'El correo electrónico ya está registrado.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Roles
            WHERE RoleID = @RoleId
              AND IsActive = 1
              AND DeletedDate IS NULL
        )
            THROW 50005, 'El rol no existe o no está activo.', 1;

        UPDATE U
        SET
            U.NombreCompleto = @NombreCompleto,
            U.Email = @Email,
            U.RoleId = @RoleId,
            U.UsuarioStatus = @UsuarioStatus,
            U.ModifiedDate = GETDATE()
        FROM 
            Usuarios U with(nolock) 
        WHERE U.UsuariosID = @UsuariosID;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;