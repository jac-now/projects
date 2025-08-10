<#
.SYNOPSIS
    A user-friendly script to manage Windows updates and Winget packages.

.DESCRIPTION
    This script provides a menu-driven interface to check for, install, and manage Windows updates using the PSWindowsUpdate module. It also includes functionality to update applications using the Winget package manager.

.EXAMPLE
    ./windows-update.ps1
    This command will start the script and display the main menu.

.NOTES
    Author: Jac-Now (https://github.com/jac-now)
    Requires:   PSWindowsUpdate module and Winget package manager.
    This script must be run with administrator privileges.
#>

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


function Install-SingleUpdate {
    Clear-Host
    Write-Host "This function allows you to install a single update by its KB number. You will need to provide the KB number of the update you wish to install." -ForegroundColor Yellow
    
    # Prompt user for KB number
    $kbNumber = Read-Host "Enter the KB number of the update including the 'KB' prefix (e.g., KB5005565)"

    # Check if the KB number is valid
    if ($kbNumber -match "^KB\d+$") {
        # Check for and create the log directory
        if (-not (Test-Path -Path "C:\logs")) {
            New-Item -Path "C:\logs" -ItemType Directory -Force | Out-Null
        }
        
        # Define the log file path
        $logFile = "C:\logs\$(Get-Date -Format yyyy-MM-dd)-WindowsUpdate.log"
        
        Write-Host "Attempting to install update $kbNumber..." -ForegroundColor Green
        try {
            # Use Get-WindowsUpdate with the -Install and -KBArticleID parameters
            Get-WindowsUpdate -Install -KBArticleID $kbNumber -AcceptAll | Tee-Object -FilePath $logFile -Append
            Write-Host "Installation attempt for update $kbNumber has completed. Check the log file for details." -ForegroundColor Green
        }
        catch {
            Write-Host "An error occurred while trying to install the update. Please check the KB number and try again." -ForegroundColor Red
        }
    }
    else {
        Write-Host "Invalid KB number format. Please ensure it starts with 'KB' followed by digits." -ForegroundColor Red
    }

    # Pause the script until the user is ready to continue
    Read-Host "`nPress Enter to return to the Windows Update menu..."
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


function Install-WingetUpdates {
    Clear-Host
    Write-Host "Starting installation of all Winget updates..." -ForegroundColor Green

    # Check for and create the log directory
    if (-not (Test-Path -Path "C:\logs")) {
        New-Item -Path "C:\logs" -ItemType Directory -Force | Out-Null
    }

    # Define the log file path
    $logFile = "C:\logs\$(Get-Date -Format yyyy-MM-dd)-WingetUpgrade.log"

    # Check if winget is installed
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "winget is not found. Please install it to use this feature." -ForegroundColor Red
        Read-Host "`nPress Enter to return to the Winget Updates menu..."
        return
    }

    try {
        Write-Host "Displaying all upgradable packages..." -ForegroundColor Yellow
        winget upgrade
        $confirm = Read-Host "Proceed with installing all available winget updates? (Y/N)"

        if ($confirm -match "^y$") {
            # Log the list of upgradable packages BEFORE the update
            "$(Get-Date): The following packages were available for an update:" | Out-File $logFile -Append
            "---------------------------------------------------------------------------------------------------" | Out-File $logFile -Append
            winget upgrade | Out-File $logFile -Append
            "---------------------------------------------------------------------------------------------------`n" | Out-File $logFile -Append

            Write-Host "Upgrading packages via winget. Please wait for the process to complete..." -ForegroundColor Green
            # Run the winget command and allow its output to display normally
            winget upgrade --all --accept-source-agreements --accept-package-agreements
            
            # Log the list of upgradable packages AFTER the update
            "$(Get-Date): Update process completed. The following packages are still available for update:" | Out-File $logFile -Append
            "---------------------------------------------------------------------------------------------------" | Out-File $logFile -Append
            winget upgrade | Out-File $logFile -Append
            "---------------------------------------------------------------------------------------------------" | Out-File $logFile -Append
            
            Write-Host "Update process completed. A before-and-after log has been saved to '$logFile'." -ForegroundColor Green
        }
        else {
            Write-Host "Winget updates cancelled." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "An error occurred during the upgrade process and has been logged." -ForegroundColor Red
        "$(Get-Date): An error occurred during the upgrade process: $_" | Out-File $logFile -Append
    }

    Read-Host "`nPress Enter to return to the Winget Updates menu..."
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