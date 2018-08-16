Param(
    [string] $AdminID,
    [string] $AdminPWD,
    [bool] $AccountEnabled = $true,
    [bool] $OverWrite = $true
)

# Include our libraries
. "./lib/Util.ps1"
. "./lib/AzureAdLib.ps1"
. "./lib/ExchangeOnlineLib.ps1"
. "./lib/SharePointOnlineLib.ps1"

Clear-Host

$CREDENTIAL = GetYourCredential $AdminID $AdminPWD

# Init AAD
$TENANT = ConnectToAzureAD $CREDENTIAL
$TENANT_DOMAIN = $tenant.TenantDomain
$DEFAULT_PASSWORD = GetARandomPassword

# Init Exo
ConnectToExo $CREDENTIAL

Write-Output ( "Connected to tenant $TENANT_DOMAIN" )
Write-Output ( "The password for users will be $DEFAULT_PASSWORD"  )

Import-Csv -Path "personas.csv" | ForEach-Object{
 
    # Add more needed properties for Azure AD
    $_ | Add-Member UniversalPrincipalName  ( FormatUPN -alias $_.Alias -TenantDomain $TENANT_DOMAIN )    # UPN
    $_ | Add-Member UserPassword $DEFAULT_PASSWORD

    # Create the user in Azure AD
    CreateUserInAzureAD -UserData $_ -OverWrite $OverWrite

    # Licensing
    ApplyLicensingToUser -UserData $_

}