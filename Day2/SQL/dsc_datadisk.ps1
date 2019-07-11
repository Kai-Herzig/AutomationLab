Configuration DataDisk
{
    Import-DSCResource -ModuleName StorageDsc
    Node localhost

    {
        WaitForDisk Disk1
        {
            DiskId = 2
            RetryIntervalSec = 60
            RetryCount = 60
            }  

        Disk FVolume
        {
            AllowDestructive = $true
            ClearDisk = $true
            DiskId = 2
            DriveLetter = 'N'
            FSLabel = 'Data'
            }
        }
    }

DataDisk
Start-DscConfiguration -Path C:\tmp\DataDisk -Wait -Force -Verbose
