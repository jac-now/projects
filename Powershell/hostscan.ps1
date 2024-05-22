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