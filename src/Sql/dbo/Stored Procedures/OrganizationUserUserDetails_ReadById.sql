﻿CREATE PROCEDURE [dbo].[OrganizationUserUserDetails_ReadById]
    @Id UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON

    SELECT
        *
    FROM
        [dbo].[OrganizationUserUserDetailsView]
    WHERE
        [Id] = @Id

    SELECT
        *
    FROM
        [dbo].[SubvaultUserSubvaultDetailsView]
    WHERE
        [OrganizationUserId] = @Id
END