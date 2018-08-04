Param(
    [string] $AdminID,
    [string] $AdminPWD,
    [bool] $AccountEnabled = $true
)

# Include our libraries
. "./lib/util.ps1"
. "./lib/azureAdLib.ps1"

Clear-Host

$TENANT = ConnectToAzureAD $AdminID $AdminPWD
$TENANT_DOMAIN = $tenant.TenantDomain
$SKU_ID = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value $SkuName -EQ).SkuID
$DEFAULT_PASSWORD = GetA-Random-Password

Write-Output ( "Connected to tenant $TENANT_DOMAIN" )
Write-Output ( "The password for users will be $DEFAULT_PASSWORD"  )

Import-Csv -Path "personas.csv" | ForEach-Object{
 
    # Add more needed properties for Azure AD
    $_ | Add-Member UniversalPrincipalName  ( FormatUPN -alias $_.Alias -TenantDomain $TENANT_DOMAIN )    # UPN
    $_ | Add-Member SkuID (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value $$_.Office365Plan -EQ).SkuID                                                                         # SKU for License Assignment
    $_ | Add-Member UserPassword $DEFAULT_PASSWORD

    # Create the user in Azure AD
    CreateUserInAzureAD -UserData $_   
}