#Domain Join
Add-Computer -DomainName "automationlab.com" -Restart

#Packages and Modules for DSC
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$true
Install-Module -Name StorageDsc -Confirm:$true
Install-Module -Name SqlServerDsc

#SQL Binaries
New-Item -Path C:\SQL2017 -ItemType Directory
$mountResult = Mount-DiskImage -ImagePath 'C:\tmp\en_sql_server_2017_standard_x64_dvd_11294407.iso' -PassThru
$volumeInfo = $mountResult | Get-Volume
$driveInfo = Get-PSDrive -Name $volumeInfo.DriveLetter
Copy-Item -Path ( Join-Path -Path $driveInfo.Root -ChildPath '*' ) -Destination C:\SQL2017\ -Recurse
Dismount-DiskImage -ImagePath 'C:\tmp\en_sql_server_2017_standard_x64_dvd_11294407.iso'

#dot source the dsc files before running the following commands
#Start-DscConfiguration -Path C:\tmp\DataDisk -Wait -Force -Verbose
#Start-DscConfiguration -Path C:\tmp\SQLFile -Wait -Force -Verbose
#Start-DscConfiguration -Path C:\tmp\SQLInstall -Wait -Force -Verbose