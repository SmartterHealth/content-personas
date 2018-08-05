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
    
    <# Write-Output "Removing user mailbox $upn from Exchange Online..."
    Remove-Mailbox -Identity $upn -PermanentlyDelete
    Write-Output "Success! Removed user mailbox $upn from Exchange Online..." #>

    Write-Output "Removing user $upn from Azure AD..."
    try {
    Remove-AzureADUser -ObjectId $upn
        Write-Output "Success! Removed user $upn from Azure AD..."
    } catch {
        Write-Output "Failed! Could not remove user $upn from Azure AD: $_.Exception.Message"
    }
}