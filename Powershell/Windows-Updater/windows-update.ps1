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

# Show Available Updates Function
function Show-Updates {
  Clear-Host
  Write-Host "Here are the available updates for this system"
  Get-WindowsUpdate -ListAvailable | Format-Table -AutoSize
  Read-Host "`nPress Enter to return to the main menu..."
}

# Show Update History Function
function Show-UpdateHistory {
    Clear-Host
    Write-Host "Here is the Windows Update history for this system:"
    Get-WUHistory | Format-Table -AutoSize
    Read-Host "`nPress Enter to return to the main menu..."
}

# Install Updates Function
function Install-Updates {
  Clear-Host
  Write-Host "Starting installation of Windows Updates..." -ForegroundColor Green

# Prompt user for driver updates
  $includeDrivers = Read-Host "Include driver updates? (Y/N)"

# Prompt user for Microsoft updates
  $includeMicrosoftUpdates = Read-Host "Include other Microsoft product updates (e.g., Office)? (Y/N)"

# Define a hash table with the base parameters
  $params = @{
    Install = $true
    Verbose = $true
    AcceptAll = $true
  }

# Add or Remove parameters based on user input
  if ($includeDrivers -notmatch "^y$") {
    Write-Host "Excluding driver updates..."
    $params.Add("NotCategory", "Drivers")
  }
  if ($includeMicrosoftUpdates -match "^y$") {
    Write-Host "Including Microsoft product updates..."                        
    $params.Add("MicrosoftUpdate", $true)
  }
  else {
    Write-Host "Excluding Microsoft product updates..."
    }

# Check for and create the log directory
  if (-not (Test-Path -Path "C:\logs")) {
    New-Item -Path "C:\logs" -ItemType Directory -Force | Out-Null
  }

# Define the log file path
  $logFile = C:\logs\$(Get-Date -Format yyyy-MM-dd)-WindowsUpdate.log"

# Execute the update command with dynamically created parameters
  try {
    Write-Host "This may take some time. Please wait...."
    Get-WindowsUpdate @params | Tee-Object -FilePath $logFile -Append
    Write-Host "Update process completed. Check the log file for details." -ForegroundColor Green
  }

  catch {
    Write-Host "An error occured during the update process. Check the log file for details." -ForegroundColor Red
  }

# Pause the script until the user is ready to continue
  Read-Host "`nPress Enter to return to the main menu..."
}



# Install a Non Driver Updates Function - Not yet implemented
function Install-NonDriverUpdates {
    Write-Host "This feature is not yet implemented. Please select another option." -ForegroundColor Yellow
    Start-Sleep -Seconds 3 # This gives the user time to read the message
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
        "1" { Show-Updates }
        "2" { Install-Updates }
        "3" { Install-NonDriverUpdates }
        "4" { Install-UpdatesByCategory }
        "5" { Install-SingleUpdate }]
        "6" { Show-UpdateHistory }
        "7" { Write-Host "Exiting..."; exit }
        default { Write-Host "Invalid choice. Please try again." -ForegroundColor Yellow }
    }
}
