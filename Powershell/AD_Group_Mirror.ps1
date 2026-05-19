Import-Module ActiveDirectory

$s = Read-Host "Source User"
$t = Read-Host "Target User"

$u1 = Get-ADUser $s -Properties MemberOf
$u2 = Get-ADUser $t

Write-Host "`nSource: $($u1.Name) ($($u1.DistinguishedName))"
Write-Host "Target: $($u2.Name) ($($u2.DistinguishedName))`n"

$grps = $u1.MemberOf
$grps | ForEach-Object { Write-Host " - $_" }

if ((Read-Host "`nProceed with mirroring $($grps.Count) groups? (y/n)") -eq 'y') {
    foreach ($g in $grps) {
        try {
            Add-ADGroupMember -Identity $g -Members $u2 -ErrorAction Stop
            Write-Host "SUCCESS: $g"
        } catch {
            Write-Warning "FAILED/SKIPPED: $g"
        }
    }
    Write-Host "`nDone."
}
