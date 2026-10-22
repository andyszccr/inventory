

CREATE PROCEDURE dbo.RolesInsert
    @RolesName VARCHAR(50),
    @RolesDescription VARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NULLIF(LTRIM(RTRIM(@RolesName)), '') IS NULL
        BEGIN
            THROW 50001, 'El nombre del rol es obligatorio.', 1;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.Roles
            WHERE RolesName = LTRIM(RTRIM(@RolesName))
        )
        BEGIN
            THROW 50002, 'El nombre del rol ya existe.', 1;
        END;

        INSERT INTO dbo.Roles
        (
            RolesName,
            RolesDescription,
            IsActive,
            CreateDate
        )
        VALUES
        (
            @RolesName,
            @RolesDescription,
            1,
            GETDATE()
        );

        DECLARE @RoleID INT = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SELECT
            RoleID,
            RolesName,
            RolesDescription,
            IsActive,
            CreateDate
        FROM dbo.Roles
        WHERE RoleID = @RoleID;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;