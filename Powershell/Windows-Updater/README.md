# Windows Updater Script

This PowerShell script provides a user-friendly, menu-driven interface to manage Windows updates on a local machine. It leverages the `PSWindowsUpdate` module to check for, install, and review update history.

## Features
 
*   **Automatic Module Management**: Checks if the `PSWindowsUpdate` module is installed and, if not, installs it for the current user.
*   **Menu-Driven Interface**: Simplifies complex update commands into easy-to-understand options.
*   **Flexible Installation Options**:
    *   Install all available updates, including drivers and Microsoft product updates.
    *   Install updates while excluding drivers.
    *   Check for available updates without installing.
*   **Update History**: Quickly view the history of installed updates.
*   **Logging**: Installation actions are logged to `C:\logs\YYYY-MM-DD-WindowsUpdate.log`.

## Prerequisites

*   **Windows 10/11**: The script is designed for modern Windows operating systems.
*   **PowerShell 5.1 or higher**: Required to run the script and install modules.
*   **Administrator Privileges**: Essential for installing updates and managing system modules.
*   **Internet Connection**: To download the `PSWindowsUpdate` module and the updates themselves.

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

5.  **Follow the On-Screen Menu**: Once the script is running, you will be presented with a menu. Enter the number corresponding to your desired action.

## Menu Options

1.  **Check for updates**: Lists all available updates without installing them.
2.  **Install ALL updates**: Installs all available updates, including drivers, optional updates, and updates for other Microsoft products (like Office).
3.  **Install Windows updates except drivers**: Installs all updates but skips any that are categorized as "Drivers".
4.  **Install Windows updates by category**: (Placeholder) This feature is not yet implemented.
5.  **Install a single update by KB number**: (Placeholder) This feature is not yet implemented.
6.  **Display Windows Update history**: Shows a formatted table of past update installations.
7.  **Exit**: Closes the script.

## Important Notes

*   The script will automatically attempt to install the `PSWindowsUpdate` module from the PowerShell Gallery if it is not found on your system. This requires an internet connection.
*   Update installations (Options 2 and 3) are logged to a file in `C:\logs\`. You may need to create this directory manually if it doesn't exist.
*   Some updates may require a system restart to complete. The script will accept all prompts, but you may need to manually restart your computer afterward.
