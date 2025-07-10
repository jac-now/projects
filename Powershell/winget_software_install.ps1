<#
.SYNOPSIS
    A script to install software using winget, organized by category.
.DESCRIPTION
    This script builds an installation plan based on user choices for software categories
    and choice groups, asks for a final confirmation, and then executes the installations.
.NOTES
    Requires winget to be installed on the system and administrator privileges.
#>

# --- Data Structures ---

# Define software categories, direct installs, and choice groups in one structure.
$categories = @{
    "IT Tools" = @{
        Direct = @("7zip.7zip", "Microsoft.PowerToys", "Teamviewer.Teamviewer", "Wireshark.Wireshark", "Angryziber.AngryIPScanner", "Insecure.Nmap", "PuTTY.PuTTY", "Microsoft.RemoteDesktopClient", "Microsoft.Sysinternals.Suite", "Veeam.VeeamAgent");
        Choices = @("VNC Clients");
    };
    "Productivity & Office" = @{
        Direct = @("Microsoft.Teams", "SlackTechnologies.Slack", "Notion.Notion", "Obsidian.Obsidian", "Adobe.Acrobat.Reader.64-bit", "Proton.ProtonDrive", "Proton.ProtonVPN", "Proton.ProtonMail", "Microsoft.OneNote", "ShareX.ShareX", "Discord.Discord");
        Choices = @("Office Suites", "Password Managers", "Web Browsers");
    };
    "Multimedia & Design" = @{
        Direct = @("Audacity.Audacity", "VideoLAN.VLC", "GIMP.GIMP.3", "Inkscape.Inkscape", "IrfanSkiljan.IrfanView");
        Choices = @(); # No choices in this category
    };
    "Developer Tools" = @{
        Direct = @("Microsoft.VisualStudioCode", "Oracle.VirtualBox", "Git.Git");
        Choices = @();
    }
}

# Define the items within each choice group.
$choiceGroups = @{
    "VNC Clients" = @("RealVNC.VNCViewer", "RealVNC.VNCServer", "TigerVNC.TigerVNC");
    "Office Suites" = @("Microsoft.Office", "LibreOffice.LibreOffice", "OnlyOffice.OnlyOffice");
    "Password Managers" = @("Bitwarden.Bitwarden", "Proton.ProtonPass", "KeePassXCTeam.KeePassXC");
    "Web Browsers" = @("Google.Chrome", "Mozilla.Firefox")
}

# --- Core Functions ---

# Main function to drive the installation planning and execution.
function Start-InstallationWorkflow {
    param (
        [array]$categoryNames
    )
    Clear-Host
    Write-Host "Building installation plan..."
    $installQueue = [System.Collections.Generic.List[string]]::new()
    $processedGroups = [System.Collections.Generic.List[string]]::new()

    # Gather software from the selected categories
    foreach ($categoryName in $categoryNames) {
        $category = $categories[$categoryName]
        $installQueue.AddRange($category.Direct)

        foreach ($groupName in $category.Choices) {
            if (-not $processedGroups.Contains($groupName)) {
                $userChoices = Get-ChoiceGroupSelection -groupName $groupName -groupItems $choiceGroups[$groupName]
                $installQueue.AddRange($userChoices)
                $processedGroups.Add($groupName)
            }
        }
    }

    $uniqueQueue = $installQueue | Sort-Object -Unique
    Execute-Installation -installQueue $uniqueQueue
}

# Prompts the user to select software from a choice group.
function Get-ChoiceGroupSelection {
    param (
        [string]$groupName,
        [array]$groupItems
    )
    while ($true) {
        Write-Host "`nChoose for $($groupName):" -ForegroundColor Cyan
        1..$groupItems.Count | ForEach-Object { Write-Host "$_. $($groupItems[$_ - 1])" }
        Write-Host "A. All of the above"
        Write-Host "N. None of the above"
        $choice = (Read-Host "Enter your choice (e.g., 1, A, N)").Trim()

        if ($choice -ieq 'A') { return $groupItems }
        if ($choice -ieq 'N') { return @() }
        if ($choice -match '^\d+$' -and [int]$choice -ge 1 -and [int]$choice -le $groupItems.Count) {
            return @($groupItems[[int]$choice - 1])
        }
        Write-Host "Invalid input. Please try again." -ForegroundColor Red
    }
}

# Confirms and runs the installation for the queued items.
function Execute-Installation {
    param (
        [array]$installQueue
    )
    if ($installQueue.Count -eq 0) {
        Write-Host "Nothing to install." -ForegroundColor Yellow; return
    }

    Clear-Host
    Write-Host "PLAN: The following $($installQueue.Count) packages will be installed:" -ForegroundColor Green
    $installQueue | ForEach-Object { Write-Host " - $_" }
    if ((Read-Host "`nProceed with installation? (y/n)").Trim() -ne 'y') {
        Write-Host "Installation cancelled."; return
    }

    Write-Host "`nStarting installation..."
    foreach ($softwareId in $installQueue) {
        Write-Host "`nInstalling $($softwareId)..."
        try {
            winget install --id $softwareId --accept-package-agreements --accept-source-agreements --scope machine -h
            Write-Host "Successfully installed $($softwareId)." -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to install $($softwareId)." -ForegroundColor Red
        }
    }
}

# --- Menu Functions ---

function Show-Menu {
    Clear-Host
    Write-Host "========================================"
    Write-Host "    Winget Software Installer Menu"
    Write-Host "========================================"
    Write-Host "1. Install by Category"
    Write-Host "2. Install ALL Software"
    Write-Host "3. List All Available Software"
    Write-Host "4. Exit"
    Write-Host "----------------------------------------"
}

# --- Main Script Body ---

while ($true) {
    Show-Menu
    $choice = (Read-Host "Enter your choice").Trim()
    switch ($choice) {
        '1' {
            Write-Host "Select a category:"
            $categoryKeys = $categories.Keys | Sort-Object
            1..$categoryKeys.Count | ForEach-Object { Write-Host "$_. $($categoryKeys[$_ - 1])" }
            $catChoice = (Read-Host "Enter number").Trim()
            if ($catChoice -match '^\d+$' -and [int]$catChoice -ge 1 -and [int]$catChoice -le $categoryKeys.Count) {
                Start-InstallationWorkflow -categoryNames @($categoryKeys[[int]$catChoice - 1])
            } else {
                Write-Host "Invalid selection." -ForegroundColor Red
            }
        }
        '2' { Start-InstallationWorkflow -categoryNames $categories.Keys }
        '3' { 
            List-SoftwareByCategory
            Read-Host "`nPress Enter to return to the main menu..."
        }
        '4' { Write-Host "Exiting."; return }
        default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red }
    }
    Read-Host "`nOperation finished. Press Enter to return to the main menu..."
}
