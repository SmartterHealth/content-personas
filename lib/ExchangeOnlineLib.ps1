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