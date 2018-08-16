Param(
    [string] $AdminID,
    [string] $AdminPWD,
    [bool] $AccountEnabled = $true,
    [bool] $OverWrite = $true
)

Clear-Host


# Include our libraries
. "./lib/Util.ps1"
. "./lib/AzureAdLib.ps1"
. "./lib/ExchangeOnlineLib.ps1"
#. "./lib/SharePointOnlineLib.ps1"


$CREDENTIAL = GetYourCredential $AdminID $AdminPWD

# Init AAD
$TENANT = ConnectToAzureAD $CREDENTIAL
$TENANT_DOMAIN = $tenant.TenantDomain
$DEFAULT_PASSWORD = GetARandomPassword
$MANAGERS = [ordered]@{}

# Init Exo
ConnectToExo $CREDENTIAL

Write-Output ( "Connected to tenant $TENANT_DOMAIN" )
Write-Output ( "The password for users will be $DEFAULT_PASSWORD"  )

Import-Csv -Path "personas.csv" | ForEach-Object{

    # Grab some commonly used values
    [string] $alias = $_.Alias
    [string] $managerAlias = $_.Manager
 
    # Add more needed properties for Azure AD
    $_ | Add-Member UniversalPrincipalName  ( FormatUPN -alias $alias -TenantDomain $TENANT_DOMAIN )    # UPN
    $_ | Add-Member UserPassword $DEFAULT_PASSWORD

    # Create the user in Azure AD
    Write-Host "Creating user $alias in Azure AD..."
    $newUser = CreateUserInAzureAD -UserData $_ -OverWrite $OverWrite

    if ($managerAlias) {
        $manager = $MANAGERS[$managerAlias]
        Write-Host "Setting manager for user $alias to $managerAlias..."
        Set-AzureADUserManager -ObjectID $newUser.ObjectID -RefObjectId $manager.ObjectID
    } else {
        $MANAGERS.Add($alias, $newUser)
    }

    # Licensing
    ApplyLicensingToUser -UserData $_

}