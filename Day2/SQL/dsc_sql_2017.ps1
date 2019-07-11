
Configuration SQLInstall
{
     Import-DscResource -ModuleName SqlServerDsc

     node localhost
     {
          WindowsFeature 'NetFramework45'
          {
               Name   = 'NET-Framework-45-Core'
               Ensure = 'Present'
          }

          SqlSetup 'InstallDefaultInstance'
          {
               InstanceName        = 'MSSQLSERVER'
               Features            = 'SQLENGINE'
               SourcePath          = 'C:\SQL2017'
               SQLSysAdminAccounts = @('Administrators')
               DependsOn           = '[WindowsFeature]NetFramework45'
          }
          SqlDatabaseDefaultLocation 'ConfigureDatabaseLocationData'
          {
               ServerName = 'localhost'
               InstanceName = 'MSSQLSERVER'
               Type = 'Data'
               Path = 'N:\Data\'
               RestartService = $true
          }
          SqlDatabaseDefaultLocation 'ConfigureDatabaseLocationLog'
          {
               ServerName = 'localhost'
               InstanceName = 'MSSQLSERVER'
               Type = 'Log'
               Path = 'N:\Log\'
               RestartService = $true
          }
          SqlDatabaseDefaultLocation 'ConfigureDatabaseLocationBackup'
          {
               ServerName = 'localhost'
               InstanceName = 'MSSQLSERVER'
               Type = 'Backup'
               Path = 'N:\Backup\'
               RestartService = $true
          }
     }
}