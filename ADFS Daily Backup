$limit = (Get-Date).AddDays(-14)
$path = "C:\ADFSBackup\"

# Delete files older than the $limit.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

# Delete any empty directories left behind after deleting the old files.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

#ADFS Backup Script
import-module 'C:\Program Files (x86)\ADFS Rapid Recreation Tool\ADFSRapidRecreationTool.dll'
Backup-ADFS -StorageType "FileSystem" -StoragePath "C:\ADFSBackup\" -EncryptionPassword "Check LP for: ADFS Rapid Restore Password - Shared-IT" -BackupComment "Clean Install of ADFS (FS)" -BackupDKM

#Copy contents of ADFS Backup from local storage to Azure Cloud

RoboCopy C:\ADFSBackup\ \\yourcompanyazurecloudstorage.file.core.windows.net\adfs-config-backup\Daily-Backup  /mir
