Param(
    [string] $AdminID,
    [string] $AdminPWD
)

# Include our libraries
. "./lib/Util.ps1"
. "./lib/AzureAdLib.ps1"
. "./lib/ExchangeOnlineLib.ps1"
. "./lib/SharePointOnlineLib.ps1"

# Get our credentials
$g_credentials = GetYourCredential -AdminID $AdminID -AdminPWD $AdminPWD

# Log into Azure AD. This will give us some details about our tenant.
$g_tenant = ConnectToAzureAD -Credentials $g_credentials
$g_tenantDomain = $g_tenant.TenantDomain
$g_tenantName = $g_tenantDomain.Split(".")[0]
$g_adminSiteUrl = "https://" + $g_tenantName + "-admin.sharepoint.com"

# Connect to PnPOnline so we can use their nifty utilities
try {
Connect-PnPOnline -Credentials $g_credentials -Url $g_adminSiteUrl
} catch {
    Connect-PnPOnline -Url $g_adminSiteUrl -SPOManagementShell
}

$rows = @()

Get-AzureADUser -Filter "UserType eq 'Member'" | Where-Object { $_.JobTitle -ne $null } | ForEach-Object{
    $userProfile = Get-PnPUserProfileProperty  -Account $_.UserPrincipalName

    $rows += New-Object PSObject -Property @{
        Skills = $userProfile.UserProfileProperties["SPS-Skills"]
        School = $userProfile.UserProfileProperties["SPS-School"]
        AboutMe = $userProfile.UserProfileProperties["AboutMe"]
    }
}

$rows | Export-Csv -Path "Exported-Personas.csv"

