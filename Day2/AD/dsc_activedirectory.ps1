configuration NewDomain             
{             
   param             
    (             
        [Parameter(Mandatory)]             
        [pscredential]$safemodeAdministratorCred,             
        [Parameter(Mandatory)]            
        [pscredential]$domainCred            
    )             
            
    Import-DscResource -ModuleName xActiveDirectory             
            
    Node $AllNodes.Where{$_.Role -eq "Primary DC"}.Nodename             
    {             
            
        LocalConfigurationManager            
        {            
            ActionAfterReboot = 'ContinueConfiguration'            
            ConfigurationMode = 'ApplyOnly'            
            RebootNodeIfNeeded = $true            
        }            
            
        File ADFiles            
        {            
            DestinationPath = 'N:\NTDS'            
            Type = 'Directory'            
            Ensure = 'Present'            
        }            
                    
        WindowsFeature ADDSInstall             
        {             
            Ensure = "Present"             
            Name = "AD-Domain-Services"             
        }            
        $domainContainer="DC=$($Node.DomainName.Split('.') -join ',DC=')"
            
        # Optional GUI tools            
        WindowsFeature ADDSTools            
        {             
            Ensure = "Present"             
            Name = "RSAT-ADDS"             
        }            
            
        # No slash at end of folder paths            
        xADDomain FirstDS             
        {             
            DomainName = $Node.DomainName             
            DomainAdministratorCredential = $domainCred             
            SafemodeAdministratorPassword = $safemodeAdministratorCred            
            DatabasePath = 'N:\NTDS'            
            LogPath = 'N:\NTDS'            
            DependsOn = "[WindowsFeature]ADDSInstall","[File]ADFiles"            
        }       

        xADOrganizationalUnit OuSharePoint 
        {
            Name = 'Sharepoint'
            Path = $DomainContainer
            Ensure = 'Present'
            Credential = $domainCred
            DependsOn = '[xWaitForADDomain]WaitForDomainInstall'
        }
        xADUser FirstUser 
        { 
            DomainName = $Node.DomainName 
            DomainAdministratorCredential = $domainCred 
            UserName = "sp_admin" 
            Password = "Welcome2019!" #$NewADUserCred 
            Ensure = "Present" 
            DependsOn = "[xWaitForADDomain]DscForestWait" 
        }    
    }             
}            
            
# Configuration Data for AD              
$ConfigData = @{             
    AllNodes = @(             
        @{             
            Nodename = "localhost"             
            Role = "Primary DC"             
            DomainName = "automationlab.com"             
            RetryCount = 20              
            RetryIntervalSec = 30            
            PsDscAllowPlainTextPassword = $true            
        }            
    )             
}             
            
NewDomain -ConfigurationData $ConfigData `
    -safemodeAdministratorCred (Get-Credential -UserName '(Password Only)' `
        -Message "New Domain Safe Mode Administrator Password") `
    -domainCred (Get-Credential -UserName automationlab\administrator `
        -Message "New Domain Admin Credential") 
    # -NewADUserCred (Get-Credential -Message "New AD User Credentials")            
            
# Make sure that LCM is set to continue configuration after reboot            
Set-DSCLocalConfigurationManager -Path .\NewDomain –Verbose            
            
# Build the domain            
Start-DscConfiguration -Wait -Force -Path .\NewDomain -Verbose