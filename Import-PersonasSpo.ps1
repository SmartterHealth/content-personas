Param(
    [string] $AdminID,
    [string] $AdminPWD
)

Clear-Host

Write-Output "This script will set user profile fields and upload user photos... It will take a minute or two to run..."

# Include our libraries
. "./lib/Util.ps1"
. "./lib/AzureAdLib.ps1"
. "./lib/ExchangeOnlineLib.ps1"

# Grab credentials
$g_credentials = GetYourCredential -AdminID $AdminID -AdminPWD $AdminPWD

# Log into Azure AD. This will give us some details about our tenant.
$g_tenant = ConnectToAzureAD -Credentials $g_credentials
$g_tenantDomain = $g_tenant.TenantDomain
$g_tenantName = $g_tenantDomain.Split(".")[0]
$g_adminSiteUrl = "https://" + $g_tenantName + "-admin.sharepoint.com"

# Connect to PnPOnline so we can use their nifty utilities
Connect-PnPOnline -Url $g_adminSiteUrl -Credentials $g_credentials 

if (-not (Get-Command Get-Mailbox*) )
{
    $exoCredentials = GetYourCredential -AdminID $AdminID -AdminPWD $AdminPWD
    $session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/?proxymethod=rps -Credential $exoCredentials -Authentication Basic -AllowRedirection  #New-PSSession -Credential $credentials -ConfigurationName Microsoft.Exchange #-Authentication Basic -AllowRedirection
    Import-PSSession $session -AllowClobber
}

Import-Csv -Path "./personas.csv" | ForEach-Object {

    $alias =  ($_.Alias + "").Trim()

    if ($alias -ne "") {
        # Calculate & add more needed properties for SharePoint
        $_ | Add-Member UniversalPrincipalName  ( FormatUPN -alias $alias -TenantDomain $g_tenantDomain )    # UPN

        $account = $_.UniversalPrincipalName
        $skills = SplitToArray -value $_.Skills -delim ";"
        $school = SplitToArray -value $_.School -delim ";"
        $interests = SplitToArray -value $_.Interests -delim ";"
        $askMeAbout = SplitToArray -value $_.AskMeAbout -delim ";"

        Write-Output "Setting SPS-Skills for $account..."
        Set-PnPUserProfileProperty -Account $account -PropertyName "SPS-Skills" -Values $skills

        Write-Output "Setting SPS-School for $account..."
        Set-PnPUserProfileProperty -Account $account -PropertyName "SPS-School" -Values $school

        Write-Output "Setting SPS-Interests for $account..."
        Set-PnPUserProfileProperty -Account $account -PropertyName "SPS-Interests" -Values $interests

        Write-Output "Setting SPS-Responsibility (Ask Me About) for $account..."
        Set-PnPUserProfileProperty -Account $account -PropertyName "SPS-Responsibility" -Values $askMeAbout

        Write-Output "Setting photo for $account... This will take several seconds..."
        $pathToPhoto = Resolve-Path -Path "./photos/$alias.jpg"
        $photoData = [System.IO.File]::ReadAllBytes($pathToPhoto)
        Set-UserPhoto -Identity $account -PictureData $photoData -Confirm:$false
    }
    
}

Write-Output "`n"
Write-Output "FINISHED!"
Write-Output "`n"