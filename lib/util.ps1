
function FormatUPN{
    Param( [string] $Alias,
    [string] $TenantDomain)

    $upn = $alias + "@" + $tenantDomain

    return $upn
}

Function GetARandomPassword
{
    $alpha = -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
    $numeric = Get-Random -Minimum 1000 -Maximum 9999

    return $alpha + $numeric
}

Function GetYourCredential
{
    Param(

        [string] $AdminID,
        [string] $AdminPWD
    )

    $secureAdminPWD = ConvertTo-SecureString -String $AdminPWD -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential $AdminID, $secureAdminPWD
    
    return $credential
}