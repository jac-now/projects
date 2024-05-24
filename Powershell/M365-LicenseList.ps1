# Import the required module
Import-Module MSOnline

# Connect to M365
$cred = Get-Credential
Connect-MsolService -Credential $cred

# Get all licensed users and their licenses
Get-MsolUser -All | Where-Object { $_.isLicensed -eq $true } | ForEach-Object {
    $user = $_
    $licenses = $user.Licenses.AccountSkuId -join ";"
    New-Object PSObject -Property @{
        UserPrincipalName = $user.UserPrincipalName
        DisplayName = $user.DisplayName
        Licenses = $licenses
    }
} | Export-Csv -Path 'LicensedUsers.csv' -NoTypeInformation
