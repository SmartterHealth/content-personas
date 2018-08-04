
function FormatUPN{
    Param( [string] $alias,
    [string] $tenantDomain)

    $upn = $alias + "@" + $tenantDomain

    return $upn
}

Function GetA-Random-Password
{
    $alpha = -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
    $numeric = Get-Random -Minimum 1000 -Maximum 9999

    return $alpha + $numeric
}