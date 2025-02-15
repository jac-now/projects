# Get all shared mailboxes
$sharedMailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited

# Initialize an array to store the results
$results = @()

foreach ($mailbox in $sharedMailboxes) {
    # Check for mailbox permissions
    $permissions = Get-MailboxPermission -Identity $mailbox.UserPrincipalName | Where-Object {
        $_.User -ne "NT AUTHORITY\SELF" -and $_.AccessRights -eq "FullAccess"
    }

    # Check for internal forwarding rules
    $internalForwarding = Get-Mailbox -Identity $mailbox.UserPrincipalName | Select-Object -ExpandProperty ForwardingAddress

    # Check for external forwarding rules
    $externalForwarding = Get-Mailbox -Identity $mailbox.UserPrincipalName | Select-Object -ExpandProperty ForwardingSmtpAddress

    if ($permissions.Count -eq 0 -and -not $internalForwarding -and -not $externalForwarding) {
        $results += [PSCustomObject]@{
            UserPrincipalName = $mailbox.UserPrincipalName
            Status = "No delegation or forwarding"
        }
    } elseif ($permissions.Count -eq 1 -and $permissions[0].User -eq "NT AUTHORITY\SELF" -and -not $internalForwarding -and -not $externalForwarding) {
        $results += [PSCustomObject]@{
            UserPrincipalName = $mailbox.UserPrincipalName
            Status = "Only delegation to itself and no forwarding"
        }
    } elseif ($internalForwarding -or $externalForwarding) {
        $results += [PSCustomObject]@{
            UserPrincipalName = $mailbox.UserPrincipalName
            Status = "No delegation but has forwarding"
            ForwardingAddress = $internalForwarding
            ForwardingSmtpAddress = $externalForwarding
        }
    }
}

#Write the results to screen
echo $results

# Export the results to a CSV file
$results | Export-Csv -Path "C:\Temp\sharedmailbox-audit.csv" -NoTypeInformation
