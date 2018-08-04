Param(
    [string] $AdminID,
    [string] $AdminPWD,
    [bool] $Overwrite = $false,
    [bool] $AccountEnabled = $true
)

$DEFAULT_PASSWORD = "Jelp92827"

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

Function CreateUserInAzureAD{
    param(
        [string] $tenantDomain,
        [object] $user,
        [string] $userPassword
    )

    $upn = $user.Alias + "@" + $tenantDomain
    Write-Output "Creating user in Azure AD with a UPN of $upn"
    
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $UserPassword

    $userAzureAD = New-AzureADUser -UserPrincipalName $upn -DisplayName $user.DisplayName -PasswordProfile $PasswordProfile -AccountEnabled $AccountEnabled -MailNickName $user.Alias

    return $userAzureAD
}

function Get-UPN{
    Param( [string] $alias,
    [string] $tenantDomain)

    $upn = $lias + "@" + $tenantDomain

    return $upn
}

$tenant = ConnectToAzureAD $AdminID $AdminPWD
$tenantDomain = $tenant.TenantDomain

Write-Output ("Connected to tenant " + $tenantDomain)

if ($Overwrite -eq $true) {
    Import-Csv -Path "personas.csv" | ForEach-Object{
        $upn = Get-UPN -alias $_.Alias -tenantDomain $tenantDomain
        Write-Output "Removing user $upn from Azure AD..."
        Remove-AzureADUser -ObjectId $upn
    }
}

Import-Csv -Path "personas.csv" | ForEach-Object{
    CreateUserInAzureAD -user $_ -userPassword $DEFAULT_PASSWORD -tenantDomain $tenantDomain
}