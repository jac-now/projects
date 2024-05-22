# Ping each IP address in the range
1..254 | ForEach-Object {
    if ((New-Object System.Net.NetworkInformation.Ping).Send("192.168.1.$_").Status -eq [System.Net.NetworkInformation.IPStatus]::Success) {
        Write-Output "Host at 192.168.1.$_ is online."
    }
}