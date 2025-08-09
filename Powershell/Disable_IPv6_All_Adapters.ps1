<#
.SYNOPSIS
    Disables IPv6 on all network adapters.
.DESCRIPTION
    This script disables IPv6 on all network adapters by using the Disable-NetAdapterBinding cmdlet.
.NOTES
    Author: Jac-Now (https://github.com/jac-now)
.EXAMPLE
    PS C:\> .\Disable_IPv6_All_Adapters.ps1
    This command will execute the script and disable IPv6 on all network adapters.
#>
Get-NetAdapterBinding -ComponentID ms_tcpip6 | Disable-NetAdapterBinding -ComponentID ms_tcpip6 -PassThru