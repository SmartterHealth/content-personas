Param(
    [string] $AdminID,
    [string] $AdminPWD
)

# Include our libraries
. "./lib/Util.ps1"
. "./lib/AzureAdLib.ps1"
. "./lib/ExchangeOnlineLib.ps1"
. "./lib/SharePointOnlineLib.ps1"

# Init AAD
$CREDENTIAL = GetYourCredential $AdminID $AdminPWD
$TENANT = ConnectToAzureAD $CREDENTIAL

# Init SPO
$adminSiteURL = "https://" + ($TENANT.TenantDomain.Split("."))[0] + "-admin.sharepoint.com"
$SPCREDENTIAL = GetYourCredential -AdminID $AdminID -AdminPWD $AdminPWD -SpoCsom
$SPCONTEXT = ConnectToSpo -SiteUrl $adminSiteURL -Credential $SPCREDENTIAL

Get-AzureADUser | ForEach-Object{
    $_.DisplayName
}


