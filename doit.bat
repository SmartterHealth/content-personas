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

-AdminID tyler@smartterhealth.com -AdminPWD 72%JNKyfK%