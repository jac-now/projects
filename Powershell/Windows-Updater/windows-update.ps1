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
Start-Sleep -Seconds 1 # This gives the user time to read the message

# --- Main Menu Function ---

function Show-Menu {
    Clear-Host
    Write-Host "========================================"
    Write-Host "       Main Updater Menu"
    Write-Host "========================================"
    Write-Host "1. Windows Update Menu"
    Write-Host "2. Winget Application Updates"
    Write-Host "3. Exit"
    Write-Host "----------------------------------------"
}


# --- Windows Update Sub-Menu Function ---

function WindowsUpdatesMenu {
    while ($true) {
        Clear-Host
        Write-Host "========================================"
        Write-Host "    Windows Update Sub-Menu"
        Write-Host "========================================"
        Write-Host "1. Check for updates"
        Write-Host "2. Install Windows updates"
        Write-Host "3. Display Windows Update history"
        Write-Host "4. Install a single update by KB number"
        Write-Host "5. Back to Main Menu"
        Write-Host "----------------------------------------"

        $choice = Read-Host "Enter your choice"
        switch ($choice) {
            "1" { Show-Updates }
            "2" { Install-Updates }
            "3" { Show-UpdateHistory }
            "4" { Install-SingleUpdate }
            "5" { return } # Return to the main menu
            default {
                Clear-Host
                Write-Host "Invalid choice. Please try again." -ForegroundColor Yellow
                Read-Host "`nPress Enter to return to the sub-menu..."
            }
        }
    }
}


# --- Winget Updates Sub-Menu Function ---

function WingetUpdatesMenu {
    while ($true) {
        Clear-Host
        Write-Host "========================================"
        Write-Host "   Winget Updates Sub-Menu"
        Write-Host "========================================"
        Write-Host "1. Show available winget updates"
        Write-Host "2. Install all winget updates"
        Write-Host "3. Back to Main Menu"
        Write-Host "----------------------------------------"

        $choice = Read-Host "Enter your choice"
        switch ($choice) {
            "1" { Show-WingetUpdates }
            "2" { Install-WingetUpdates }
            "3" { return } # Return to the main menu
            default {
                Clear-Host
                Write-Host "Invalid choice. Please try again." -ForegroundColor Yellow
                Read-Host "`nPress Enter to return to the Winget Updates menu..."
            }
        }
    }
}

# --- Windows Update Functions ---

# Show Available Updates Function
function Show-Updates {
    Clear-Host
    Write-Host "Fetching the available updates for this system, this may take a moment..." -ForegroundColor Green
    Get-WindowsUpdate | Format-Table -AutoSize
    # Pause the script until the user is ready to continue
    Read-Host "`nPress Enter to return to the Windows Update menu..."
}

# Show Update History Function
function Show-UpdateHistory {
    Clear-Host
    Write-Host "Here is the Windows Update history for this system:"
    Get-WUHistory | Format-Table -AutoSize
    # Pause the script until the user is ready to continue
    Read-Host "`nPress Enter to return to the Windows Update menu..."
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
    $logFile = "C:\logs\$(Get-Date -Format yyyy-MM-dd)-WindowsUpdate.log"

# Execute the update command with dynamically created parameters
    try {
        Write-Host "This may take some time. Please wait...."
        Get-WindowsUpdate @params | Tee-Object -FilePath $logFile -Append
        Write-Host "Update process completed. Check the log file $logFile for details." -ForegroundColor Green
    }

    catch {
        Write-Host "An error occured during the update process. Check the log file $logFile for details." -ForegroundColor Red
    }

# Pause the script until the user is ready to continue
    Read-Host "`nPress Enter to return to the Windows Update menu..."
}


# Install a Single Update Function - Not yet implemented
function Install-SingleUpdate {
    Write-Host "This feature is not yet implemented. Please select another option." -ForegroundColor Yellow
    Start-Sleep -Seconds 3 # This gives the user time to read the message
}


# ---- Winget Software Installer Functions ---

# Show Available Winget Updates Function

function Show-WingetUpdates {
    Clear-Host
    Write-Host "Checking for available application updates via Winget..." -ForegroundColor Green

    # Check if winget is installed
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "winget is not found. Please install it to use this feature." -ForegroundColor Red
        Read-Host "`nPress Enter to return to the Winget Updates menu..."
        return
    }

    # Use winget to list upgradable packages
    try {
        Write-Host "Listing all available winget updates:"
        winget upgrade | Out-Host
    }
    catch {
        Write-Host "An error occured while trying to list winget updates." -ForegroundColor Red
    }

    # Pause the script until the user is ready to continue
    Read-Host "`nPress Enter to return to the Winget Updates menu..."
}


# Install Winget Updates Function
function Install-WingetUpdates {
    Clear-Host
    Write-Host "Starting installation of all Winget updates..." -ForegroundColor Green

    # Define the log file path
    $logFile = "C:\logs\$(Get-Date -Format yyyy-MM-dd)-WingetUpgrade.log"

    # Check if winget is installed
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "winget is not found. Please install it to use this feature." -ForegroundColor Red
        Read-Host "`nPress Enter to return to the Winget Updates menu..."
        return
    }

    # Use winget to upgrade all packages
    try { 
        Write-Host "Displaying all upgradable packages..."
        winget upgrade | Out-Host
        # Provide opportunity for user to review updates and cancel if necessary
        Write-Host "Waiting 6 seconds before proceeding with the installation, press Ctrl+C to cancel..." -ForegroundColor Yellow
        Start-Sleep -Seconds 6

        # Check for and create the log directory
        if (-not (Test-Path -Path "C:\logs")) {
            New-Item -Path "C:\logs" -ItemType Directory -Force | Out-Null
        }

        Write-Host "Upgrading packages via winget, this may take a while..." -ForegroundColor Green
        winget upgrade --all --silent --accept-source-agreements --accept-package-agreements | Tee-Object -FilePath $logFile -Append
        Write-Host "Update process completed. Check the log file $logFile for details." -ForegroundColor Green
    }

    catch {
        Write-Host "An error occured during the upgrade process. Check the log file $logFile for details." -ForegroundColor Red
    }
}

# --- Main Script Loop ---

while ($true) {
    Show-Menu
    $choice = Read-Host "Enter your choice"
    switch ($choice) {
        "1" { WindowsUpdatesMenu }
        "2" { WingetUpdatesMenu }
        "3" { Write-Host "Exiting..."; exit }
        default {
            Clear-Host
            Write-Host "Invalid choice. Please try again." -ForegroundColor Yellow
            Read-Host "`nPress Enter to return to the main menu..."
        }
    }
}
