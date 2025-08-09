<#
.SYNOPSIS
    Adds users to a distribution list from a CSV file.
.DESCRIPTION
    This script reads a list of users from a CSV file and adds them to a specified distribution list.
    It also has a section to add users as mail contacts.
.NOTES
    Author: Jac-Now (https://github.com/jac-now)
    Instructions: The script is divided into two parts. Comment out the section that is not needed.
.EXAMPLE
    PS C:\> .\DL-Bulk-Import.ps1
    This command will execute the script.
#>
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
#Import the CSV file
$csv = Import-Csv -Path $csvPath

foreach ($row in $csv) {
    $email = $row.Email
    try {
        # Check if the email already exists in the distribution list
        $existingContact = Get-DistributionGroupMember -Identity $distList | Where-Object {$_.PrimarySmtpAddress -eq $email}
        if ($null -eq $existingContact) {
            # Add the email to the distribution list
            Add-DistributionGroupMember -Identity $distList -Member $email
            # Verify if the user was added
            $verification = Get-DistributionGroupMember -Identity $distList | Where-Object {$_.PrimarySmtpAddress -eq $email}
            if ($null -ne $verification) {
                Add-Content -Path $logPath -Value "$email added to $distList"
            } else {
                Add-Content -Path $logPath -Value "Failed to add $email to $distList"
            }
        } else {
            Add-Content -Path $logPath -Value "User with email $email already exists in DL."
        }
    } catch {
        # Log error details
        Add-Content -Path $logPath -Value ("Error adding user with email {0}: {1}" -f $email, $_.Exception.Message)
    }
}

####TO DO###
#Split into two scripts with first half for import of mail contacts, 2nd for bulk import to DL
#Error message capturing
