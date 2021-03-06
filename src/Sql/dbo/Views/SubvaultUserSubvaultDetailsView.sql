﻿CREATE VIEW [dbo].[SubvaultUserSubvaultDetailsView]
AS
SELECT
    SU.[Id],
    SU.[OrganizationUserId],
    S.[Name],
    S.[Id] SubvaultId,
    SU.[ReadOnly]
FROM
    [dbo].[SubvaultUser] SU
INNER JOIN
    [dbo].[Subvault] S ON S.[Id] = SU.[SubvaultId]