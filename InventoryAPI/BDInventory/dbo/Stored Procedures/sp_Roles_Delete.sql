
CREATE   PROCEDURE dbo.sp_Roles_Delete
    @RoleID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS 
        (
            SELECT 1
            FROM dbo.Roles
            WHERE RoleID = @RoleID
        )
        BEGIN
            THROW 50003, 'El rol no existe.', 1;
        END;

        IF EXISTS 
        (
            SELECT 1
            FROM dbo.Roles
            WHERE RoleID = @RoleID
              AND DeletedDate IS NOT NULL
        )
        BEGIN
            THROW 50004, 'El rol ya fue eliminado.', 1;
        END;

        UPDATE r
        SET
            r.IsActive = 0,
            r.DeletedDate = GETDATE()
        from dbo.Roles r
        WHERE RoleID = @RoleID;

        COMMIT TRANSACTION;

        SELECT
            RoleID,
            RolesName,
            IsActive,
            DeletedDate
        FROM dbo.Roles
        WHERE RoleID = @RoleID;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;