PowerShell.exe -Command ".\Import-Personas.ps1"


# UID admin@M365x664893.onmicrosoft.com
# PWD tdurham@649715

# cd C:\Users\tyler\Development\smartterhealth\content-personas\

# Connect-SmartterHealth -TenantName "M365x664893.onmicrosoft.com" -AdminID admin@M365x664893.onmicrosoft.com

# .\Remove-Personas.ps1 -AdminID admin@M365x664893.onmicrosoft.com -AdminPWD tdurham@649715

$newUser = New-AzureADUser -AccountEnabled $accountEnabled -UserPrincipalName $ud.UniversalPrincipalName -MailNickName $ud.Alias -UsageLocation $ud.UsageLocation -DisplayName $ud.DisplayName -PasswordProfile $PasswordProfile -JobTitle $ud.JobTitle -Department $ud.Department -PhysicalDeliveryOfficeName $ud.Office -City $ud.City -State $ud.State


# New-Mailbox -Alias hollyh -Name hollyh -FirstName Holly -LastName Holt -DisplayName "Holly Holt" -MicrosoftOnlineServicesID hollyh@corp.contoso.com -Password (ConvertTo-SecureString -String 'P@ssw0rd' -AsPlainText -Force) -ResetPasswordOnNextLogon $true


.\Import-Personas.ps1 -AdminID admin@M365x664893.onmicrosoft.com -AdminPWD tdurham@649715

#  (Get-UserPhoto "Dr. Strange").PictureData | Set-Content "drstrange.jpg"  -Encoding byte
#  Set-UserPhoto -Identity "Dr. Strange" -PictureData ([System.IO.File]::ReadAllBytes((Resolve-Path ".\photos\drstrange.jpg") )) -Confirm:$Y


$users = Get-AzureADUser

Get-AzureADUser | ForEach-Object { (Get-UserPhoto $_.DisplayName).PictureData | Set-Content ($_.DisplayName + ".jpg")  -Encoding byte }

-AdminID tyler@smartterhealth.com -AdminPWD Jelp@Wonder



The WinRM client cannot process the request. The connection string should be of the form [<transport>://]<host>[:<port>][/<suffix>] where transport is one of "http" or "https". Transport, port and suffix are optional.
The host may be a hostname or an IP address. For IPv6 addresses, enclose the address in brackets - e.g. "http://[1::2]:80/wsman". Change the connection string and try the request again.
[Server=BN6PR05MB3042,RequestId=f14d95d3-a51e-4e2c-af0b-b4a58053431f,TimeStamp=8/18/2018 3:10:54 PM] .
    + CategoryInfo          : NotSpecified: (:) [Set-UserPhoto], CmdletProxyException




    Set-UserPhoto "drstrange@M365x664893.onmicrosoft.com" -PictureData ([Byte[]] $(Get-Content -Path (Resolve-Path ".\photos\z-no-photo.jpg") -Encoding Byte -ReadCount 0)) -Confirm:$false