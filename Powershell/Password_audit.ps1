Import-Module ActiveDirectory

$timePeriod = (Get-Date).AddDays(-90) # Adjust the number of days as needed; Currently set to look for passwords older than 90 days

# Get all enabled users with passwords older than the specified time period
Get-ADUser -Filter {Enabled -eq $true} -Property PasswordLastSet | Where-Object { $_.PasswordLastSet -lt $timePeriod } | Select-Object Name, PasswordLastSet | Export-CSV -Path 'C:\Temp\password-audit.csv' -NoTypeInformation # Replace with your desired path