Import-Module ActiveDirectory

$timePeriod = (Get-Date).AddDays(-90) # Adjust the number of days as needed; Currently set to look for inactive accounts older than 90 days

# Get all enabled users with last logon older than the specified time period
Get-ADUser -Filter {Enabled -eq $true} -Property LastLogon | Where-Object { $_.LastLogon -lt $timePeriod } | Select-Object Name, LastLogon | Export-CSV -Path 'C:\Temp\inactivity-audit.csv' -NoTypeInformation # Replace with your desired path