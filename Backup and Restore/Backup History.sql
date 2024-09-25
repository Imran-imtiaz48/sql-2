/*
Get backup history
source: https://www.mssqltips.com/sqlservertip/1601/script-to-retrieve-sql-server-database-backup-history-and-no-backups/
date: 4/12/2019

notes:
* change the Where clause for database_name


*/

SELECT 
    CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
    bs.database_name, 
    bs.backup_start_date, 
    bs.backup_finish_date, 
    bs.expiration_date, 
    CASE 
        WHEN bs.type = 'D' THEN 'Database' 
        WHEN bs.type = 'L' THEN 'Log' 
    END AS backup_type, 
    bs.backup_size, 
    bmf.logical_device_name, 
    bmf.physical_device_name, 
    bs.name AS backupset_name, 
    bs.description
FROM 
    msdb.dbo.backupmediafamily AS bmf
INNER JOIN 
    msdb.dbo.backupset AS bs ON bmf.media_set_id = bs.media_set_id 
WHERE 
    CONVERT(DATETIME, bs.backup_start_date, 102) >= DATEADD(DAY, -7, GETDATE()) 
    AND bs.database_name = 'TestAG2'
ORDER BY 
    bs.database_name, 
    bs.backup_finish_date;

