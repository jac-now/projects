<#
.SYNOPSIS
    Scans a range of IP addresses and returns the ones that are online.
.DESCRIPTION
    This script scans a range of IP addresses and returns the ones that are online.
.NOTES
    Author: Jac-Now (https://github.com/jac-now)
.EXAMPLE
    PS C:\> .\ipscan.ps1
    This command will execute the script and scan the 192.168.1.0/24 network.
#>

# Ping each IP address in the range
1..254 | ForEach-Object {
    if ((New-Object System.Net.NetworkInformation.Ping).Send("192.168.1.$_").Status -eq [System.Net.NetworkInformation.IPStatus]::Success) {
        Write-Output "Host at 192.168.1.$_ is online."
    }
}
#Add user input for network octets in future
