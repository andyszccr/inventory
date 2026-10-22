
CREATE   PROCEDURE dbo.UsuariosDelete
    @UsuariosID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM dbo.Usuarios WHERE UsuariosID = @UsuariosID AND DeletedDate IS NULL)
            THROW 50006, 'El usuario no existe o ya fue eliminado.', 1;

        UPDATE u
        SET
            u.UsuarioStatus = 0,
            u.DeletedDate = GETDATE()
        From 
            Usuarios u with(nolock)
        WHERE 
            UsuariosID = @UsuariosID;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;