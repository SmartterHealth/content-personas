Function ApplyLicensingToUser{

    Param(
        [object] $csvUser
    )

     # Licensing    
     $plans = $csvUser.Office365Plans.split(";")  # TODO: Handle this better... could get an empty/null value
    
     #Create the AssignedLicenses Object 
     $AssignedLicenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
     
     foreach($plan in $plans)
     {
         [string] $upn = $csvUser.UniversalPrincipalName
         #Create the AssignedLicense object with the License and DisabledPlans earlier created
         $License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
         $License.SkuId = ( Get-AzureADSubscribedSku | Where-Object {$_.SkuPartNumber -eq $plan}  ).SkuId
         $AssignedLicenses.AddLicenses = $License
 
         #Assign the license to the user
         $result = Set-AzureADUserLicense -ObjectId  $csvUser.UniversalPrincipalName -AssignedLicenses $AssignedLicenses

         return $result
     }

}
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
        [string] $AdminPWD,
        [switch] $SpoCsom
    )

    if ( $SpoCsom.IsPresent -eq $true ) {
        
        $credential = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($AdminID , (ConvertTo-SecureString -String $AdminPWD -AsPlainText -Force))
        return $credential

    } else {

        $credential = New-Object System.Management.Automation.PSCredential $AdminID, ( ConvertTo-SecureString -String $AdminPWD -AsPlainText -Force )
        
        return $credential
    }
}

Function PrintMessage{
    Param(
        [string] $message,
        $level = 0
    )

    Write-Host $('--' * $level ) -NoNewline
    Write-Host $message
}