# Description: Windows Update script for Windows -- Includes Driver updates
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; Set-ExecutionPolicy RemoteSigned -Force -Confirm:$false; Install-Module -Name PSWindowsUpdate -Force -Confirm:$false; Install-Module kbupdate -Force -Confirm:$false; Import-Module -Name PSWindowsUpdate; Import-Module -Name KBUpdate; Get-WindowsUpdate -Install -Verbose -MicrosoftUpdate -Confirm:$false; Get-KbNeededUpdate -UseWindowsUpdate | ECHO A; Set-ExecutionPolicy Restricted -Force

# Without Drivers
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; Set-ExecutionPolicy RemoteSigned -Force -Confirm:$false; Install-Module -Name PSWindowsUpdate -Force -Confirm:$false; Install-Module kbupdate -Force -Confirm:$false; Import-Module -Name PSWindowsUpdate; Import-Module -Name KBUpdate; Get-WindowsUpdate -Install -Verbose -MicrosoftUpdate -NotCategory "Drivers" -Confirm:$false; Get-KbNeededUpdate -UseWindowsUpdate | ECHO A; Set-ExecutionPolicy Restricted -Force


function Show-Menu {
    Clear-Host
    Write-Host "========================================"
    Write-Host "    Windows Updater Menu"
    Write-Host "========================================"
    Write-Host "1. Check for updates"
    Write-Host "2. Install ALL updates (includes drivers and optional updates)"
    Write-Host "3. Install Windows updates except drivers"
    Write-Host "4. Install Windows updates by category"
    Write-Host "5. Install a single update"
    Write-Host "6. Exit"
    Write-Host "----------------------------------------"
}