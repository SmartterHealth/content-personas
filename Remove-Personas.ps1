Param(
    [string] $AdminID,
    [string] $AdminPWD
)

Function ConnectToAzureAD{
    Param(
        [string] $AdminID,
        [string] $AdminPWD
    )

    $secureAdminPWD = ConvertTo-SecureString -String $AdminPWD -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential $AdminID, $secureAdminPWD
    $tenant = Connect-AzureAD -Credential $credential

    return $tenant
}

function Get-UPN{
    Param( [string] $alias,
    [string] $tenantDomain)

    $upn = $alias + "@" + $tenantDomain

    return $upn
}

$tenant = ConnectToAzureAD $AdminID $AdminPWD
$tenantDomain = $tenant.TenantDomain

Write-Output ("Connected to tenant " + $tenantDomain)

Import-Csv -Path "personas.csv" | ForEach-Object{
    $upn = Get-UPN -alias $_.Alias -tenantDomain $tenantDomain
    Write-Output "Removing user $upn from Azure AD..."
    Remove-AzureADUser -ObjectId $upn
}