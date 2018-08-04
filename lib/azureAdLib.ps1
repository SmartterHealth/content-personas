Function ConnectToAzureAD
{
    Param(
        [string] $AdminID,
        [string] $AdminPWD
    )

    $secureAdminPWD = ConvertTo-SecureString -String $AdminPWD -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential $AdminID, $secureAdminPWD
    $tenant = Connect-AzureAD -Credential $credential

    #$exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $credential -Authentication "Basic" -AllowRedirection
    #Import-PSSession $ExchangeSession -AllowClobber

    return $tenant
}

Function CreateUserInAzureAD
{

    Param (
        [object] $UserData
    )

    try 
    { 
        $var = Get-AzureADTenantDetail 
    } 
    catch [Microsoft.Open.Azure.AD.CommonLibrary.AadNeedAuthenticationException]  { 
        Write-Host "Please connect to Azure AD before running this script" -ForegroundColor White -BackgroundColor Red
        throw;
    }

    $ud = $UserData

    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $UserData.UserPassword
    $accountEnabled = ([System.Convert]::ToBoolean($ud.AccountEnabled))
    $newUser = New-AzureADUser -AccountEnabled $accountEnabled -UserPrincipalName $ud.UniversalPrincipalName -MailNickName $ud.Alias -UsageLocation $ud.UsageLocation -DisplayName $ud.DisplayName -PasswordProfile $PasswordProfile -JobTitle $ud.JobTitle -Department $ud.Department -PhysicalDeliveryOfficeName $ud.Office -City $ud.City -State $ud.State

    # Licensing    
    $plans = $ud.Office365Plans.split(";")  # TODO: Handle this better... could get an empty/null value
    
    #Create the AssignedLicenses Object 
    $AssignedLicenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
    
    foreach($plan in $plans)
    {
        Write-Output "Assining plan $plan to ($ud.Alias)"
        #Create the AssignedLicense object with the License and DisabledPlans earlier created
        $License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
        $License.SkuId = ( Get-AzureADSubscribedSku | Where-Object {$_.SkuPartNumber -eq $plan}  ).SkuId
        $AssignedLicenses.AddLicenses = $License

        #Assign the license to the user
        Set-AzureADUserLicense -ObjectId  $ud.UniversalPrincipalName -AssignedLicenses $AssignedLicenses
    }
    
    return $newUser
}