Param(
    [string] $AdminID,
    [string] $AdminPWD
)

# Include our libraries
. "./lib/Util.ps1"
. "./lib/AzureAdLib.ps1"

$CREDENTIAL = GetYourCredential $AdminID $AdminPWD
$TENANT = ConnectToAzureAD $CREDENTIAL
$TENANT_DOMAIN = $TENANT.TenantDomain

Write-Output ("Connected to tenant " + $tenantDomain)

Import-Csv -Path "personas.csv" | ForEach-Object{
    $upn = ( FormatUPN -Alias $_.Alias -TenantDomain $TENANT_DOMAIN ) 
    Write-Output "Removing user $upn from Azure AD..."
    Remove-AzureADUser -ObjectId $upn
}