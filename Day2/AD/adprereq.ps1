Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$true
Install-Module -Name StorageDsc -Confirm:$true
Install-Module -Name xActiveDirectory -Confirm:$true