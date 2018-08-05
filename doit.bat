PowerShell.exe -Command ".\Import-Personas.ps1"


# UID admin@M365x664893.onmicrosoft.com
# PWD tdurham@649715

# cd C:\Users\tyler\Development\smartterhealth\content-personas\

# Connect-SmartterHealth -TenantName "M365x664893.onmicrosoft.com" -AdminID admin@M365x664893.onmicrosoft.com

# .\Remove-Personas.ps1 -AdminID admin@M365x664893.onmicrosoft.com -AdminPWD tdurham@649715

$newUser = New-AzureADUser -AccountEnabled $accountEnabled -UserPrincipalName $ud.UniversalPrincipalName -MailNickName $ud.Alias -UsageLocation $ud.UsageLocation -DisplayName $ud.DisplayName -PasswordProfile $PasswordProfile -JobTitle $ud.JobTitle -Department $ud.Department -PhysicalDeliveryOfficeName $ud.Office -City $ud.City -State $ud.State