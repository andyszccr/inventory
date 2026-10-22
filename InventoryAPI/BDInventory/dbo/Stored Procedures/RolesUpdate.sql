
CREATE PROCEDURE dbo.RolesUpdate
    @RoleID INT,
    @RolesName VARCHAR(50),
    @RolesDescription VARCHAR(200) = NULL,
    @IsActive BIT
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

        IF NULLIF(LTRIM(RTRIM(@RolesName)), '') IS NULL
        BEGIN
            THROW 50001, 'El nombre del rol es obligatorio.', 1;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.Roles
            WHERE RolesName = LTRIM(RTRIM(@RolesName))
              AND RoleID <> @RoleID
        )
        BEGIN
            THROW 50002, 'El nombre del rol ya existe.', 1;
        END;

        UPDATE r
        SET
            r.RolesName = LTRIM(RTRIM(@RolesName)),
            r.RolesDescription = @RolesDescription,
            r.IsActive = @IsActive,
            r.ModifiedDate = GETDATE()
        from 
            dbo.Roles r with(nolock)
        WHERE RoleID = @RoleID;

        COMMIT TRANSACTION;


    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;