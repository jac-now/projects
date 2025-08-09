# Windows Updater and Package Management Script

This PowerShell script provides a user-friendly, menu-driven interface to manage Windows updates and Winget packages on a local machine. It leverages the `PSWindowsUpdate` module for Windows Update functionality and the native `winget` command-line tool for application updates.

## Features

*   **Automatic Module Management**: Checks if the `PSWindowsUpdate` module is installed and, if not, installs it for the current user.
*   **Dual-Function Menu**: A clear main menu separates Windows Update and Winget package management into sub-menus.
*   **Flexible Windows Update Options**:
    *   Check for available updates without installing.
    *   Install all available updates with prompts to include/exclude drivers and other Microsoft product updates.
    *   View the history of installed updates.
    *   Install a single update by its KB number.
*   **Winget Package Management**:
    *   List all available application updates that can be managed by Winget.
    *   Install all available Winget package updates.
*   **Logging**: All update actions are logged to `C:\logs\`.

## Prerequisites

*   **Windows 10/11**: The script is designed for modern Windows operating systems.
*   **PowerShell 5.1 or higher**: Required to run the script and install modules.
*   **Administrator Privileges**: Essential for installing updates and managing system modules.
*   **Internet Connection**: To download the `PSWindowsUpdate` module and the updates themselves.
*   **Winget**: The script checks for `winget` and will notify you if it's not found.

## How to Use

1.  **Open PowerShell as Administrator**: Right-click the PowerShell icon and select "Run as Administrator".

2.  **Navigate to the Script Directory**:
    ```powershell
    Set-Location -Path "C:\path\to\your\scripts\Powershell\Windows-Updater" # Adjust this path
    ```

3.  **Unblock the Script (if downloaded)**: If you downloaded this script from the internet, PowerShell might block it. Unblock it with this command:
    ```powershell
    Unblock-File -Path ".\windows-update.ps1"
    ```

4.  **Execute the Script**:
    ```powershell
    .\windows-update.ps1
    ```

5.  **Follow the On-Screen Menu**: Once the script is running, you will be presented with a main menu. Enter the number corresponding to your desired action to navigate to the appropriate sub-menu.

## Menu Options

### Main Menu

1.  **Windows Update Menu**: Navigate to the sub-menu for Windows Update tasks.
2.  **Winget Application Updates**: Navigate to the sub-menu for Winget package management.
3.  **Exit**: Closes the script.

### Windows Update Sub-Menu

1.  **Check for updates**: Lists all available updates without installing them.
2.  **Install Windows updates**: Installs available updates with prompts for including/excluding drivers and other Microsoft products.
3.  **Display Windows Update history**: Shows a formatted table of past update installations.
4.  **Install a single update by KB number**: Allows you to install a specific update using its KB number.
5.  **Back to Main Menu**: Returns to the main menu.

### Winget Updates Sub-Menu

1.  **Show available winget updates**: Lists all applications with available updates through Winget.
2.  **Install all winget updates**: Installs all available updates for applications managed by Winget.
3.  **Back to Main Menu**: Returns to the main menu.

## Important Notes

*   The script will automatically attempt to install the `PSWindowsUpdate` module from the PowerShell Gallery if it is not found on your system. This requires an internet connection.
*   Update installations are logged to a file in `C:\logs\`. The script will create this directory if it doesn't exist.
*   Some updates may require a system restart to complete. The script will accept all prompts, but you may need to manually restart your computer afterward.