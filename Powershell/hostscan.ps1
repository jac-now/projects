<#
.SYNOPSIS
    Scans a range of IP addresses and returns the hostnames of the ones that are online.
.DESCRIPTION
    This script scans a range of IP addresses and returns the hostnames of the ones that are online.
.NOTES
    Author: Jac-Now (https://github.com/jac-now)
.EXAMPLE
    PS C:\> .\hostscan.ps1
    This command will execute the script and scan the 192.168.1.0/24 network.
#>

# Define the range of IP addresses to scan
1..254 | ForEach-Object {
    $ip = "192.168.1.$_"
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        try {
            $hostname = [System.Net.Dns]::GetHostEntry($ip).HostName
            Write-Output "Host at $ip ($hostname) is online."
        } catch {
            Write-Output "Host at $ip is online but hostname could not be resolved."
        }
    }
}
#Add user input for network octets in future
