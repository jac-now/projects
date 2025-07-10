# Winget Software Installer

This PowerShell script automates the installation of a specific software package using the Windows Package Manager (Winget). It's designed for quick, unattended installation of a single, predefined application.

## Features

*   Installs a specified software package using Winget.
*   Includes basic error handling for Winget commands.
*   Provides feedback on the installation process.

## Prerequisites

*   **Windows 10/11:** This script is designed for Windows operating systems that support Winget.
*   **Winget (Windows Package Manager):** Ensure Winget is installed and up-to-date on your system. You can usually get it from the Microsoft Store or by installing the App Installer package.
*   **PowerShell:** The script must be run in a PowerShell environment.

## How to Use

1.  **Open PowerShell as Administrator:** Right-click on the PowerShell icon and select "Run as Administrator."
2.  **Navigate to the Script Directory:**
    ```powershell
    Set-Location -Path "C:\path\to\your\scripts\Powershell" # Adjust this path
    ```
3.  **Unblock the Script (if downloaded):** If you downloaded this script from the internet, PowerShell might block its execution. Unblock it using:
    ```powershell
    Unblock-File -Path ".\winget_software_install.ps1"
    ```
4.  **Execute the Script:**
    ```powershell
    .\winget_software_install.ps1
    ```

## Configuration

Currently, the script is hardcoded to install a specific programs. These can be edited within the Data Structures section. The catergory names can be changed along with the winget IDs contained within them without issue.
Example:
```powershell
$softwareCategories = @{
    "IT Tools" = @(
        "7zip.7zip",
        "M2Team.NanaZip",
        "Microsoft.PowerToys",
        "Teamviewer.Teamviewer",
    <SNIP>
    );
```

## Example Usage

When you run the script, it will attempt to install the programs specified during menu slection. You will see output similar to this:

```
Attempting to install: Visual Studio Code (Microsoft.VisualStudioCode)
Found Visual Studio Code [Microsoft.VisualStudioCode]
This application is licensed to you by its owner.
Microsoft is not responsible for, nor does it grant any licenses to, third-party packages.
Downloading https://az764295.vo.msecnd.net/stable/6445d93c81632fe792b339fba7a5a4943d67ee84/VSCodeUserSetup-x64-1.89.1.exe
  ██████████████████████████████   100%
Successfully verified installer hash
Starting package install...
Successfully installed
```
