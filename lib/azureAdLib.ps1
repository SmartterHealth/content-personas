Function ConnectToAzureAD
{
    Param(
        $credentials
    )

    $tenant = Connect-AzureAD -Credential $credentials

    return $tenant
}

Function CreateUserInAzureAD
{

    Param (
        [object] $UserData,
        [bool] $OverWrite = $true
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
    $accountEnabled = $true
    $adUser = $null

    try {
        $adUser = Get-AzureADUser -ObjectId $ud.UniversalPrincipalName
    } catch {
        $adUser = New-AzureADUser -AccountEnabled $accountEnabled -UserPrincipalName $ud.UniversalPrincipalName -MailNickName $ud.Alias -UsageLocation $ud.UsageLocation -DisplayName $ud.DisplayName -PasswordProfile $PasswordProfile
    }

    # Update the user
    Set-AzureADUser -ObjectId $ud.UniversalPrincipalName -AccountEnabled $accountEnabled -DisplayName $ud.DisplayName -JobTitle $ud.JobTitle -Department $ud.Department -PhysicalDeliveryOfficeName $ud.Office -City $ud.City -State $ud.State
    if ($ud.Manager) {
        $ud.Manager
    }
    
    return $adUser
}