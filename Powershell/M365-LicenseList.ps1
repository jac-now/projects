<#
.SYNOPSIS
    Lists all licensed users in M365 and their licenses.
.DESCRIPTION
    This script connects to M365 and exports a list of all licensed users and their licenses to a CSV file.
.NOTES
    Author: Jac-Now (https://github.com/jac-now)
    Requires: MSOnline module
.EXAMPLE
    PS C:\> .\M365-LicenseList.ps1
    This command will execute the script and export a list of licensed users to LicensedUsers.csv.
#>

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
