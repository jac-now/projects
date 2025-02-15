$cred = get-credential
Connect-MsolService -credential $cred

#MFA account status report 
Write-Host "Finding Azure Active Directory Accounts..."
$Users = Get-MsolUser -All -EnabledFilter EnabledOnly | ? { ($_.UserType -ne "Guest") -and ($_.IsLicensed -eq $true) }
$Report = [System.Collections.Generic.List[Object]]::new() # Create output file
Write-Host "Processing" $Users.Count "accounts..." 
ForEach ($User in $Users) {
    $MFAMethods = $User.StrongAuthenticationMethods.MethodType
    $MFAEnforced = $User.StrongAuthenticationRequirements.State
    $MFAPhone = $User.StrongAuthenticationUserDetails.PhoneNumber
    $DefaultMFAMethod = ($User.StrongAuthenticationMethods | ? { $_.IsDefault -eq "True" }).MethodType
    If (($MFAEnforced -eq "Enforced") -or ($MFAEnforced -eq "Enabled")) {
        Switch ($DefaultMFAMethod) {
            "OneWaySMS" { $MethodUsed = "One-way SMS" }
            "TwoWayVoiceMobile" { $MethodUsed = "Phone call verification" }
            "PhoneAppOTP" { $MethodUsed = "Hardware token or authenticator app" }
            "PhoneAppNotification" { $MethodUsed = "Authenticator app" }
        }
    }
    Else {
        $MFAEnforced = "Not Enabled"
        $MethodUsed = "MFA Not Used" 
    }
    $ReportLine = [PSCustomObject] @{
        User        = $User.UserPrincipalName
        Name        = $User.DisplayName
        MFAUsed     = $MFAEnforced
        MFAMethod   = $MethodUsed 
        PhoneNumber = $MFAPhone
		Licensed	= $User.IsLicensed
    }
    $Report.Add($ReportLine) 
}
Write-Host "Report is in c:\temp\MFAUsers.CSV"
$Report | Select Name, MFAUsed, MFAMethod, PhoneNumber | Sort Name | Out-GridView # Display report
$Report | Sort Name | Export-CSV -NoTypeInformation c:\temp\MFAUsers-Licensed.csv # Replace with your desired path