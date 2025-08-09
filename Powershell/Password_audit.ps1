<#
.SYNOPSIS
    Audits user passwords in Active Directory.
.DESCRIPTION
    This script queries Active Directory for user accounts with passwords older than a specified period of time and exports the results to a CSV file.
.NOTES
    Author: Jac-Now (https://github.com/jac-now)
    Requires: ActiveDirectory module
.EXAMPLE
    PS C:\> .\Password_audit.ps1
    This command will execute the script and export a list of users with old passwords to C:\Temp\password-audit.csv.
#>

Import-Module ActiveDirectory

$timePeriod = (Get-Date).AddDays(-90) # Adjust the number of days as needed; Currently set to look for passwords older than 90 days

# Get all enabled users with passwords older than the specified time period
Get-ADUser -Filter {Enabled -eq $true} -Property PasswordLastSet | Where-Object { $_.PasswordLastSet -lt $timePeriod } | Select-Object Name, PasswordLastSet | Export-CSV -Path 'C:\Temp\password-audit.csv' -NoTypeInformation # Replace with your desired path