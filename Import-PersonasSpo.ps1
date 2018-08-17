Param(
    [string] $AdminID,
    [string] $AdminPWD
)

# Include our libraries
. "./lib/Util.ps1"
. "./lib/AzureAdLib.ps1"

# Grab credentials
$g_credentials = GetYourCredential -AdminID $AdminID -AdminPWD $AdminPWD

# Log into Azure AD. This will give us some details about our tenant.
$g_tenant = ConnectToAzureAD -Credentials $g_credentials
$g_tenantDomain = $g_tenant.TenantDomain
$g_tenantName = $g_tenantDomain.Split(".")[0]
$g_adminSiteUrl = "https://" + $g_tenantName + "-admin.sharepoint.com"

# Connect to PnPOnline so we can use their nifty utilities
Connect-PnPOnline -Url $g_adminSiteUrl -Credentials $g_credentials 

Import-Csv -Path "./personas.csv" | ForEach-Object {
    # Calculate & add more needed properties for SharePoint
    $_ | Add-Member UniversalPrincipalName  ( FormatUPN -alias $_.Alias -TenantDomain $g_tenantDomain )    # UPN

    [bool] $canResume = $true

    $account = $_.UniversalPrincipalName
    $skills = SplitToArray -value $_.Skills -delim ";"
    $school = SplitToArray -value $_.School -delim ";"

    
    

    try {
        Write-Output "Setting SPS-Skills for $account..."
        Set-PnPUserProfileProperty -Account $account -PropertyName "SPS-Skills" -Values $skills

        Write-Output "Setting SPS-School for $account..."
        Set-PnPUserProfileProperty -Account $account -PropertyName "SPS-School" -Values $school
    } 
    catch { 
        Write-Warning "No user profile has been provisioned for user $account. Please wait a few minutes before trying again."
    }
    
}