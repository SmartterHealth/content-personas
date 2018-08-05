Function ConnectToExo
{
    Param(
        $credential
    )

    if (-not (Get-Command Get-Mailbox*) )
    {
        $session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $credential -Authentication "Basic" -AllowRedirection
        Import-PSSession $session -AllowClobber
    }
}

Function SetupMailbox
{
    Param(
        [object] $UserData,
        [bool] $OverWrite = $true
    )

    $ud = $UserData

    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $UserData.UserPassword
    $accountEnabled = ([System.Convert]::ToBoolean($ud.AccountEnabled))
    
    # Mailbox
    New-Mailbox -Name $UserData.DisplayName -DisplayName $UserData.DisplayName -MicrosoftOnlineServicesID $UserData.UniversalPrincipalName -Password ( ConvertTo-SecureString -String $UserData.UserPassword -AsPlainText -Force ) -ResetPasswordOnNextLogon $false
}