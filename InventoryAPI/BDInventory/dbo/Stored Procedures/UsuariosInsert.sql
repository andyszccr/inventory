
CREATE PROCEDURE dbo.UsuariosInsert
    @NombreCompleto VARCHAR(150),
    @Email VARCHAR(150),
    @PasswordHash VARCHAR(500),
    @RoleId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NULLIF(@NombreCompleto, '') IS NULL
            THROW 50001, 'El nombre completo es obligatorio.', 1;

        IF NULLIF(@Email, '') IS NULL
            THROW 50002, 'El correo electrónico es obligatorio.', 1;

        IF NULLIF(@PasswordHash, '') IS NULL
            THROW 50003, 'El hash de la contraseña es obligatorio.', 1;

        IF EXISTS (SELECT 1 FROM dbo.Usuarios WHERE Email = @Email)
            THROW 50004, 'El correo electrónico ya está registrado.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Roles
            WHERE RoleID = @RoleId
              AND IsActive = 1
              AND DeletedDate IS NULL
        )
            THROW 50005, 'El rol no existe o no está activo.', 1;

        INSERT INTO dbo.Usuarios
        (
            NombreCompleto,
            Email,
            PasswordHash,
            RoleId,
            UsuarioStatus,
            CreateDate
        )
        VALUES
        (
            @NombreCompleto,
            @Email,
            @PasswordHash,
            @RoleId,
            1,
            GETDATE()
        );

        COMMIT TRANSACTION;


    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;