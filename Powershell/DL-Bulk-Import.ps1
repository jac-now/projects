###################################
#3rd party vendors
###################################
#Add users from a CSV as mail contacts
$csvPath = "C:\Temp\ExternalEmailList.csv"
$logPath = 'C:\Temp\ExternalEmailList.txt'

# Import the CSV file
$csv = Import-Csv -Path $csvPath

foreach ($row in $csv) {
    $name = $row.Name
    $email = $row.Email
    $existingContact = Get-MailContact -Filter "WindowsEmailAddress -eq '$email'"

    if ($null -eq $existingContact) {
        # If not, create the mail contact
        New-MailContact -Name $name -ExternalEmailAddress $email 
        Add-Content -Path $logPath -Value "Created mail contact with name $name and email $email"
    } else {
        Add-Content -Path $logPath -Value "Mail contact with name $name and email $email already exists."
    }
}
################################## 
#Add users from a CSV to a distribution list
##################################

$distList = "DL"
$csvPath = "C:\Temp\DLEmail.csv"
$logPath = "C:\Temp\DLEmail.txt"

$csv = Import-Csv -Path $csvPath

foreach ($row in $csv) {
    $email = $row.Email
    # Check if the email already exists in the distribution list
    $existingContact = Get-DistributionGroupMember -Identity $distList | Where-Object {$_.PrimarySmtpAddress -eq $email}
    if ($null -eq $existingContact) {
        # Add the email to the distribution list
        Add-DistributionGroupMember -Identity $distList -Member $email
        Add-Content -Path $logPath -Value "$email added to $distList"
    } else {
        Add-Content -Path $logPath -Value "Mail contact with email $email already exists in DL."
    }
}
