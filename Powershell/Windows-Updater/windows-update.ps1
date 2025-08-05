# Check to see if modules are installed and loaded
Write-Host "Checking for required modules..."
if (-not (Get-Module -Name "PSWindowsUpdate" -ErrorAction SilentlyContinue)) {
    Write-Host "Module 'PSWindowsUpdate' is not loaded." -ForegroundColor Yellow

    if (Get-InstalledModule -Name "PSWindowsUpdate" -ErrorAction SilentlyContinue) {
        Write-Host "Module 'PSWindowsUpdate' is installed. Importing now..." -ForegroundColor Green
        Import-Module -Name "PSWindowsUpdate"
    }
    else {
        Write-Host "Module 'PSWindowsUpdate' not found. Installing now..." -ForegroundColor Yellow
        Install-Module -Name "PSWindowsUpdate" -Scope CurrentUser -Force
        Import-Module -Name "PSWindowsUpdate"
    }
}
else {
    Write-Host "Module 'PSWindowsUpdate' is already loaded." -ForegroundColor Green
}

# Menu Functions
function Show-Menu {
    Clear-Host
    Write-Host "========================================"
    Write-Host "    Windows Updater Menu"
    Write-Host "========================================"
    Write-Host "1. Check for updates"
    Write-Host "2. Install ALL updates (includes drivers and optional updates)"
    Write-Host "3. Install Windows updates except drivers"
    Write-Host "4. Install Windows updates by category"
    Write-Host "5. Install a single update by KB number"
    Write-Host "6. Display Windows Update history"
    Write-Host "7. Exit"
    Write-Host "----------------------------------------"
}

# Install Updates by Category Function - Not yet implemented
function Install-UpdatesByCategory {
    Write-Host "This feature is not yet implemented. Please select another option." -ForegroundColor Yellow
    Start-Sleep -Seconds 3 # This gives the user time to read the message
}

# Install a Single Update Function - Not yet implemented
function Install-SingleUpdate {
    Write-Host "This feature is not yet implemented. Please select another option." -ForegroundColor Yellow
    Start-Sleep -Seconds 3 # This gives the user time to read the message
}

# Main script loop
while ($true) {
    Show-Menu
    $choice = Read-Host "Enter your choice"
    switch ($choice) {
        "1" { Get-WindowsUpdate -ListAvailable }
        "2" { Get-WindowsUpdate -Install -Verbose -MicrosoftUpdate -AcceptAll |Out-File "c:\logs\$(get-date -f yyyy-MM-dd)-WindowsUpdate.log" -force }
        "3" { Get-WindowsUpdate -Install -Verbose -MicrosoftUpdate -NotCategory "Drivers" -AcceptAll | Out-File "c:\logs\$(get-date -f yyyy-MM-dd)-WindowsUpdate.log" -force }
        "4" { Install-UpdatesByCategory }
        "5" { Install-SingleUpdate }
        "6" { Get-WUHistory | Format-Table -AutoSize }
        "7" { Write-Host "Exiting..."; exit }
        default { Write-Host "Invalid choice. Please try again." -ForegroundColor Yellow }
    }
}
