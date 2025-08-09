<#
.SYNOPSIS
    Audits for inactive user accounts in Active Directory.
.DESCRIPTION
    This script queries Active Directory for user accounts that have not logged in for a specified period of time and exports the results to a CSV file.
.NOTES
    Author: Jac-Now (https://github.com/jac-now)
    Requires: ActiveDirectory module
.EXAMPLE
    PS C:\> .\Inactive_Account_Audit.ps1
    This command will execute the script and export a list of inactive users to C:\Temp\inactivity-audit.csv.
#>

Import-Module ActiveDirectory

$timePeriod = (Get-Date).AddDays(-90) # Adjust the number of days as needed; Currently set to look for inactive accounts older than 90 days

# Get all enabled users with last logon older than the specified time period
Get-ADUser -Filter {Enabled -eq $true} -Property LastLogon | Where-Object { $_.LastLogon -lt $timePeriod } | Select-Object Name, LastLogon | Export-CSV -Path 'C:\Temp\inactivity-audit.csv' -NoTypeInformation # Replace with your desired path