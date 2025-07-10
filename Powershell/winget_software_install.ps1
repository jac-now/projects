<#
.SYNOPSIS
    A script to install a list of common software using winget, organized by category.
.DESCRIPTION
    This script provides a menu-driven interface to install software using winget.
    Users can view software by category, install all software, install a full category,
    or select individual applications to install from a numbered list.
.NOTES
    Requires winget to be installed on the system.
    The script must be run with administrator privileges.
#>

# Define software categories and their corresponding packages in a hashtable
$softwareCategories = @{
    "IT Tools" = @(
        "7zip.7zip",
        "Microsoft.PowerToys",
        "Teamviewer.Teamviewer",
        "Wireshark.Wireshark",
        "Angryziber.AngryIPScanner",
        "Insecure.Nmap",
        "PuTTY.PuTTY",
        "Microsoft.RemoteDesktopClient",
        "Microsoft.Sysinternals.Suite",
        "Veeam.VeeamAgent"
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
        "Discord.Discord"
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
    )
}

$choiceGroups = @{
    "VNC Clients" = @("RealVNC.VNCViewer", "RealVNC.VNCServer", "TigerVNC.TigerVNC");
    "Office Suites" = @("Microsoft.Office", "LibreOffice.LibreOffice", "OnlyOffice.OnlyOffice");
    "Password Managers" = @("Bitwarden.Bitwarden", "Proton.ProtonPass", "KeePassXCTeam.KeePassXC");
    "Web Browsers" = @("Google.Chrome", "Mozilla.Firefox")
}

# --- Function Definitions ---

# Function to display all software, sorted by category
function List-SoftwareByCategory {
    Clear-Host
    Write-Host "Available Software by Category:"
    Write-Host "--------------------------------"
    foreach ($category in $softwareCategories.Keys) {
        Write-Host "`n$($category.ToUpper())"
        $softwareCategories[$category].ForEach({ Write-Host "  - $_" })
    }
    foreach ($group in $choiceGroups.Keys) {
        Write-Host "`n$($group.ToUpper()) (Choose one)"
        $choiceGroups[$group].ForEach({ Write-Host "  - $_" })
    }
    Read-Host "`nPress Enter to return to the main menu..."
}

# Function to install a single software package
function Install-Software {
    param (
        [string]$softwareId
    )
    Write-Host "Attempting to install $($softwareId)..."
    try {
        winget install --id $softwareId --accept-package-agreements --accept-source-agreements --scope machine -h
        Write-Host "Successfully installed $($softwareId)." -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to install $($softwareId). Please check the package name and try again." -ForegroundColor Red
    }
    Write-Host "--------------------------------"
}

# Function to handle choice groups
function Handle-ChoiceGroup {
    param (
        [string]$groupName,
        [array]$groupItems
    )
    Write-Host "`nPlease choose an option for $($groupName):"
    for ($i = 0; $i -lt $groupItems.Count; $i++) {
        Write-Host "$($i + 1). $($groupItems[$i])"
    }
    Write-Host "A. Install All"
    Write-Host "N. None"
    $choice = Read-Host "Enter your choice"

    switch ($choice) {
        "A" {
            foreach ($item in $groupItems) {
                Install-Software -softwareId $item
            }
        }
        "N" { Write-Host "Skipping $($groupName)." }
        default {
            try {
                $index = [int]$choice - 1
                if ($index -ge 0 -and $index -lt $groupItems.Count) {
                    Install-Software -softwareId $groupItems[$index]
                }
                else {
                    Write-Host "Invalid choice." -ForegroundColor Yellow
                }
            }
            catch {
                Write-Host "Invalid input. Please enter a number, 'A', or 'N'." -ForegroundColor Yellow
            }
        }
    }
}

# Function to install all software from all categories
function Install-AllSoftware {
    Clear-Host
    Write-Host "Installing all available software..."
    foreach ($category in $softwareCategories.Keys) {
        Write-Host "`nInstalling software from the '$category' category..."
        foreach ($software in $softwareCategories[$category]) {
            Install-Software -softwareId $software
        }
    }
    foreach ($group in $choiceGroups.Keys) {
        Handle-ChoiceGroup -groupName $group -groupItems $choiceGroups[$group]
    }
    Read-Host "`nAll installations complete. Press Enter to return to the main menu..."
}

# Function to let the user choose and install a category
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
            Write-Host "`nInstalling software from the '$selectedCategory' category..."
            foreach ($software in $softwareCategories[$selectedCategory]) {
                Install-Software -softwareId $software
            }
            foreach ($group in $choiceGroups.Keys) {
                if ($softwareCategories[$selectedCategory].Contains($choiceGroups[$group][0])) {
                    Handle-ChoiceGroup -groupName $group -groupItems $choiceGroups[$group]
                }
            }
        } else {
            Write-Host "Invalid choice." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Invalid input. Please enter a number." -ForegroundColor Yellow
    }
    Read-Host "`nCategory installation process finished. Press Enter to return to the main menu..."
}

# Function to let the user select and install a single software package
function Select-AndInstallSingleSoftware {
    Clear-Host
    Write-Host "Select a software package to install:"
    $allSoftware = $softwareCategories.Values | ForEach-Object { $_ } | Sort-Object
    $allSoftware += $choiceGroups.Values | ForEach-Object { $_ }
    $allSoftware = $allSoftware | Sort-Object -Unique

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
            Install-Software -softwareId $selectedSoftware
        } else {
            Write-Host "Invalid choice." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Invalid input. Please enter a number." -ForegroundColor Yellow
    }
    Read-Host "`nPress Enter to return to the main menu..."
}

# Function to display the main menu
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
