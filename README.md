# SmartterHealth Personas

<img src="sm-logo.png" width="200" height="200"/>

# Prerequisites

The following libraries are required to be installed in order for the Personas scripts to run.

## Azure Active Directory for Graph

You can use the [Azure Active Directory PowerShell for Graph module](https://docs.microsoft.com/powershell/azuread/v2/azureactivedirectory) for Azure AD administrative tasks such as user management, domain management and for configuring single sign-on. You can find installation instructions [here](https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0)

## SharePoint Online Management Shell

The [SharePoint Online Management Shell](https://support.office.com/en-us/article/Introduction-to-the-SharePoint-Online-Management-Shell-C16941C3-19B4-4710-8056-34C034493429) is used to manage users, sites, and site collections. You can download it [here](https://www.microsoft.com/en-us/download/details.aspx?id=35588).

## PnP PowerShell

[SharePoint Patterns and Practices (PnP)](https://docs.microsoft.com/en-us/powershell/sharepoint/sharepoint-pnp/sharepoint-pnp-cmdlets?view=sharepoint-ps) contains a library of PowerShell commands (PnP PowerShell) that allows you to perform complex provisioning and artifact management actions towards SharePoint.  You can download it [here](https://docs.microsoft.com/en-us/powershell/sharepoint/sharepoint-pnp/sharepoint-pnp-cmdlets?view=sharepoint-ps)

# Customization

## Customize Persona Data

You are free to customize the Persona Data to suit your needs. Persona data is contained within the Personas.csv file. An Excel Workbook (Personas.xlsx) has been provided to make it easier to work with the CSV data - modify persona data within the Excel Workbook, and export as CSV. Photos are stored in the [./photos](./photos) directory. The scripts expect the name of the photo to match the user's alias.

## Customize PowerShell Scripts

If you wish to modify the scripts, then it is recommended to install [Visual Studio Code](https://code.visualstudio.com/) along with the [PowerShell Extension](https://github.com/PowerShell/PowerShell/blob/master/docs/learning-powershell/using-vscode.md).

# Importing Personas

1. Run the Import-PersonasAzureAD.ps1 script.
```
Import-PersonasAzureAD.ps1 -AdminID <youradminaccount> -AdminPWD <youradminpassword>
```

2. Wait 5-10 minutes for the Exchange Mailboxes SharePoint Profiles to get created by Office 365. The following step witll fail if these items have not been provisioned.
3. Run the Import-PersonasSpo.ps1
```
Import-PersonasSpo.ps1 -AdminID <youradminaccount> -AdminPWD <youradminpassword>
```

