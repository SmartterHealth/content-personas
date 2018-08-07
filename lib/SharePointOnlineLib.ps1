# Download and install this: http://www.microsoft.com/en-us/download/details.aspx?id=42038

try {
    Import-Module 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.UserProfiles.dll'
    Import-Module 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll'
} catch {
    Write-Error "Failed to load SharePoint Client libraries. Please make sure the client libraries have been installed from https://www.microsoft.com/en-us/download/details.aspx?id=42038"
}

 Function ConnectToSpo
 {
    Param(
        [string] $SiteUrl,
        [object] $Credentials
    )

    Write-Output "Connecting to SharePoint Site at $SiteUrl..."

    #Get the Client Context and Bind the Site Collection
    $context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteUrl)

    #Authenticate
    $credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($AdminID , (ConvertTo-SecureString -String $AdminPWD -AsPlainText -Force))
    $context.Credentials = $credentials
<# 
    
    #Create an Object [People Manager] to retrieve profile information
    $userProfileManager = New-Object Microsoft.SharePoint.Client.UserProfiles.PeopleManager($context)

    $userProfile = $userProfileManager.GetPropertiesFor($AdminID)
    $context.Load($userprofile)
    $context.ExecuteQuery() #>

    return $context
 }

 Function GetUserProfile {
     Param(
        [object] $Context,
        [string] $UniversalPrincipalName
     )

     $userProfileManager = New-Object Microsoft.SharePoint.Client.UserProfiles.PeopleManager($context)

 }