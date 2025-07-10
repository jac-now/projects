<#
.SYNOPSIS
    A script to install a list of common software using winget, organized by category.
.DESCRIPTION
    This script provides a menu-driven interface to install software using winget.
    It builds an installation plan based on user choices, asks for final confirmation,
    and then executes the installations without further user interaction.
.NOTES
    Requires winget to be installed on the system.
    The script must be run with administrator privileges.
#>

# --- Data Structures ---

# Define software that can be installed directly
$softwareCategories = @{
    "IT Tools" = @(
        "7zip.7zip",
        "Microsoft.PowerToys",
        "Teamviewer.Teamviewer",
        "PuTTY.PuTTY",
        "Microsoft.RemoteDesktopClient",
        "Microsoft.Sysinternals.Suite",
        "Veeam.VeeamAgent",
        "RealVNC.VNCViewer",
        "RealVNC.VNCServer",
        "TigerVNC.TigerVNC",
        "Symless.Synergy",
        "JAMSoftware.TreeSizeFree",
        "WinDirStat.WinDirStat",
        "NoMachine.NoMachine",
        "Splahtop.SplashtopBusiness",
        "Splashtop.SOS",
        "AnyDesk.AnyDesk",
        "Citrix.CitrixWorkspace.LTSR"
    );
    "Productivity & Office" = @(
        "Microsoft.Teams",
        "SlackTechnologies.Slack",
        "Notion.Notion",
        "Obsidian.Obsidian",
        "Adobe.Acrobat.Reader.64-bit",
        "Proton.ProtonDrive",
        "Proton.ProtonVPN",
        "Proton.ProtonMail",
        "Microsoft.OneNote",
        "ShareX.ShareX",
        "Discord.Discord",
        "Microsoft.Office",
        "LibreOffice.LibreOffice",
        "OnlyOffice.OnlyOffice",
        "Bitwarden.Bitwarden",
        "Proton.ProtonPass",
        "KeePassXCTeam.KeePassXC",
        "Google.Chrome",
        "Mozilla.Firefox",
        "Brave.Brave"
    );
    "Multimedia & Design" = @(
        "Audacity.Audacity",
        "VideoLAN.VLC",
        "GIMP.GIMP.3",
        "Inkscape.Inkscape",
        "IrfanSkiljan.IrfanView"
    );
    "Developer Tools" = @(
        "Microsoft.VisualStudioCode",
        "Oracle.VirtualBox",
        "Git.Git"
        "RedHat.VirtIO",
        "SoftwareFrededomConservancy.QEMUGuestAgent",
        "Notepad++.Notepad++"
    )
    "Security Tools" = @(
        "Malwarebytes.Malwarebytes",
        "ESET.Nod32",
        "Bitdefender.Bitdefender",
        "SUPERAntiSpyware.SUPERAntiSpyware",
        "Wazuh.WazuhAgent",
        "Tenable.Nessus",
        "Sandboxie.Classic",
        "Wireshark.Wireshark",
        "Angryziber.AngryIPScanner",
        "Insecure.Nmap",
        "osquery.osquery"
    )
    "Gaming" = @(
        "Valve.Steam",
        "EpicGames.EpicGamesLauncher",
        "GOG.Galaxy",
        "Blizzard.BattleNet",
        "Ubisoft.Connect",
        "Amazon.Games",
        "NexusMods.Vortex"
    )
}

# --- Function Definitions ---

# Function to display all available software
function List-SoftwareByCategory {
    Clear-Host
    Write-Host "Available Software by Category:"
    Write-Host "--------------------------------"
    foreach ($category in ($softwareCategories.Keys | Sort-Object)) {
        Write-Host "`n$($category.ToUpper())"
        foreach ($item in $softwareCategories[$category]) {
            Write-Host "  - $item"
        }
    }
    Read-Host "`nPress Enter to return to the main menu..."
}

# Function to build the list of software to install based on user choices
function Build-InstallQueue {
    param (
        [array]$categoriesToProcess
    )
    $installQueue = [System.Collections.Generic.List[string]]::new()

    foreach ($category in $categoriesToProcess) {
        foreach ($item in $softwareCategories[$category]) {
            $installQueue.Add($item)
        }
    }
    return $installQueue | Sort-Object -Unique
}

# Function to execute the installation of queued software
function Execute-Installation {
    param (
        [array]$installQueue
    )
    if ($installQueue.Count -eq 0) {
        Write-Host "Nothing to install." -ForegroundColor Yellow
        return
    }

    Clear-Host
    Write-Host "The following $($installQueue.Count) packages will be installed:"
    $installQueue | ForEach-Object { Write-Host " - $_" }
    $confirmation = Read-Host "`nDo you want to proceed? (y/n)"

    if ($confirmation -ieq 'y') {
        Write-Host "`nStarting installation..."
        foreach ($softwareId in $installQueue) {
            Write-Host "`nAttempting to install $($softwareId)..."
            try {
                winget install --id $softwareId --accept-package-agreements --accept-source-agreements --scope machine -h
                Write-Host "Successfully installed $($softwareId)." -ForegroundColor Green
            }
            catch {
                Write-Host "Failed to install $($softwareId)." -ForegroundColor Red
            }
            Write-Host "--------------------------------"
        }
    } else {
        Write-Host "Installation cancelled."
    }
}

# --- Menu Functions ---

function Install-AllSoftware {
    Clear-Host
    Write-Host "Planning installation for ALL software..."
    $queue = Build-InstallQueue -categoriesToProcess $softwareCategories.Keys
    Execute-Installation -installQueue $queue
    Read-Host "`nInstallation process finished. Press Enter to return to the main menu..."
}

function Install-Category {
    Clear-Host
    Write-Host "Select a category to install:"
    $categories = $softwareCategories.Keys | Sort-Object
    for ($i = 0; $i -lt $categories.Count; $i++) {
        Write-Host "$($i + 1). $($categories[$i])"
    }
    Write-Host "0. Back to Main Menu"

    $choice = Read-Host "`nEnter your choice"
    if ($choice -eq '0') { return }

    try {
        $index = [int]$choice - 1
        if ($index -ge 0 -and $index -lt $categories.Count) {
            $selectedCategory = $categories[$index]
            Write-Host "`nPlanning installation for the '$selectedCategory' category..."
            $queue = Build-InstallQueue -categoriesToProcess @($selectedCategory)
            Execute-Installation -installQueue $queue
        } else {
            Write-Host "Invalid choice." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Invalid input. Please enter a number." -ForegroundColor Yellow
    }
    Read-Host "`nInstallation process finished. Press Enter to return to the main menu..."
}

function Select-AndInstallSingleSoftware {
    Clear-Host
    Write-Host "Select a software package to install:"
    $allSoftware = ($softwareCategories.Values | ForEach-Object { $_ }) | Sort-Object -Unique

    for ($i = 0; $i -lt $allSoftware.Count; $i++) {
        Write-Host "$($i + 1). $($allSoftware[$i])"
    }
    Write-Host "0. Back to Main Menu"

    $choice = Read-Host "`nEnter your choice"
    if ($choice -eq '0') { return }

    try {
        $index = [int]$choice - 1
        if ($index -ge 0 -and $index -lt $allSoftware.Count) {
            $selectedSoftware = $allSoftware[$index]
            Execute-Installation -installQueue @($selectedSoftware)
        } else {
            Write-Host "Invalid choice." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Invalid input. Please enter a number." -ForegroundColor Yellow
    }
    Read-Host "`nPress Enter to return to the main menu..."
}

function Show-Menu {
    Clear-Host
    Write-Host "========================================"
    Write-Host "    Winget Software Installer Menu"
    Write-Host "========================================"
    Write-Host "1. List all available software by category"
    Write-Host "2. Install ALL software"
    Write-Host "3. Install a specific category"
    Write-Host "4. Install a single software package"
    Write-Host "5. Exit"
    Write-Host "----------------------------------------"
}

# --- Main Script Body ---

while ($true) {
    Show-Menu
    $choice = Read-Host "Enter your choice"
    switch ($choice) {
        "1" { List-SoftwareByCategory }
        "2" { Install-AllSoftware }
        "3" { Install-Category }
        "4" { Select-AndInstallSingleSoftware }
        "5" {
            Write-Host "Exiting."
            Exit
        }
        default {
            Write-Host "Invalid choice. Please select a valid option." -ForegroundColor Yellow
            Read-Host "Press Enter to continue..."
        }
    }
}