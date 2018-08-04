
Param(
    [string] $TenantName,
    [string] $AdminID
)

$credential = Get-Credential $AdminID

Write-Output "Connecting to Azure AD..."
Connect-AzureAD -Credential $credential