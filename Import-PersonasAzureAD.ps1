Param(
    [string] $AdminID,
    [string] $AdminPWD,
    [bool] $AccountEnabled = $true,
    [bool] $OverWrite = $true
)

Clear-Host

# Include our libraries
. "./lib/Util.ps1"
. "./lib/AzureAdLib.ps1"
. "./lib/ExchangeOnlineLib.ps1"
#. "./lib/SharePointOnlineLib.ps1"

$CREDENTIAL = GetYourCredential $AdminID $AdminPWD

# Init AAD
$TENANT = ConnectToAzureAD $CREDENTIAL
$TENANT_DOMAIN = $tenant.TenantDomain
$DEFAULT_PASSWORD = GetARandomPassword
$MANAGERS = [ordered]@{}

# Init Exo
ConnectToExo $CREDENTIAL

Write-Output ( "Connected to tenant $TENANT_DOMAIN" )
Write-Output ( "The password for users will be $DEFAULT_PASSWORD"  )

$USERLIST = Import-Csv -Path "personas.csv" | Sort-Object -Property Manager

function ProcessUserHeirarchy() {
    Param(
        [object] $csvUserParent,
        [object] $csvUserCurrent,
        $level
    )
    
    # Calculate some often used properties
    $alias = $csvUserCurrent.Alias
    
    # Add more needed properties for Azure AD
    $csvUserCurrent | Add-Member UniversalPrincipalName  ( FormatUPN -alias $alias -TenantDomain $TENANT_DOMAIN )    # UPN
    $csvUserCurrent | Add-Member UserPassword $DEFAULT_PASSWORD
    $csvUserCurrent | Add-Member ObjectID $null

    # Create the user in Azure AD
    PrintMessage -message "Creating user $alias in Azure AD..." -level $level
    $newUser = CreateUserInAzureAD -UserData $_ -OverWrite $OverWrite
    $csvUserCurrent.ObjectID = $newUser.ObjectID    
    
    if( $null -ne $csvUserParent) {
        $csvUserParentAlias = $csvUserParent.Alias
        Write-Host $('--' * $level ) -NoNewline
        PrintMessage -message "Setting  $alias's manager to $csvUserParentAlias in Azure AD..." -level $level
        Set-AzureADUserManager -ObjectID $newUser.ObjectID -RefObjectId $csvUserParent.ObjectID
    }  

    # Licensing
    PrintMessage -message "Assigning plan(s) to $alias..." -level $level
    ApplyLicensingToUser -csvUser $csvUserCurrent

    # Process the direct reports (if any) for this user
    $USERLIST | Where-Object { $_.Manager -eq $alias } | ForEach-Object {
        ProcessUserHeirarchy -csvUserParent $csvUserCurrent -csvUserCurrent $_ -level ( $level + 1 )
    }

    Write-Host $('--' * $level ) -NoNewline
    Write-Host "Successfully created user $alias in Azure AD!"
}

# Grab the first level of users (users W) a manager, as they should be top-level objects with 0 or mre direct reports
$USERLIST| Where-Object { $_.Manager -eq "" } | ForEach-Object {
    ProcessUserHeirarchy -csvUserParent $null -csvUserCurrent $_ -level $nextLevel
}
