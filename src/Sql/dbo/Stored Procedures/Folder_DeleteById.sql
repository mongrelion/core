﻿CREATE PROCEDURE [dbo].[Folder_DeleteById]
    @Id UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @UserId UNIQUEIDENTIFIER = (SELECT TOP 1 [UserId] FROM [dbo].[Folder] WHERE [Id] = @Id)
    DECLARE @UserIdPath VARCHAR(50) = CONCAT('$."', @UserId, '"')

    UPDATE
        C
    SET
        C.[Folders] = JSON_MODIFY(C.[Folders], @UserIdPath, NULL)
    FROM
        [dbo].[Cipher] C
    LEFT JOIN
        [dbo].[Organization] O ON C.[UserId] IS NULL AND O.[Id] = C.[OrganizationId]
    LEFT JOIN
        [dbo].[OrganizationUser] OU ON OU.[OrganizationId] = O.[Id] AND OU.[UserId] = @UserId
    LEFT JOIN
        [dbo].[SubvaultCipher] SC ON C.[UserId] IS NULL AND OU.[AccessAllSubvaults] = 0 AND SC.[CipherId] = C.[Id]
    LEFT JOIN
        [dbo].[SubvaultUser] SU ON SU.[SubvaultId] = SC.[SubvaultId] AND SU.[OrganizationUserId] = OU.[Id]
    WHERE
        C.[UserId] = @UserId
        OR (
            C.[UserId] IS NULL
            AND (OU.[AccessAllSubvaults] = 1 OR SU.[SubvaultId] IS NOT NULL)
        )
        AND C.[Folders] IS NOT NULL
        AND JSON_VALUE(C.[Folders], @UserIdPath) = @Id

    DELETE
    FROM
        [dbo].[Folder]
    WHERE
        [Id] = @Id

    EXEC [dbo].[User_BumpAccountRevisionDate] @UserId
END