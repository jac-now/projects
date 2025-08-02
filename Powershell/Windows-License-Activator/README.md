# Windows License Activator

This PowerShell script automates the process of activating Windows using a product key.

## Description

The script reads a product key from a `key.txt` file, installs it, and then attempts to activate Windows online. It uses the built-in `slmgr.vbs` script for all licensing operations.

## Usage

1.  **Place your product key in `key.txt`:**
    *   Open the `key.txt` file.
    *   Replace the placeholder text with your 25-character Windows product key.
    *   Save the file.

2.  **Run the script with administrative privileges:**

    There are two main ways to run the script:

    **Method 1: Right-click and Run**
    *   Right-click on `windows-activation.ps1`.
    *   Select "Run with PowerShell".
    *   You may need to approve the User Account Control (UAC) prompt.

    **Method 2: Unblock and Run from PowerShell**

    If the script is blocked by your system's execution policy, you can unblock it first.

    1.  Open PowerShell as an Administrator.
    2.  Navigate to the directory where you saved the script.
    3.  Run the following command to unblock the script:
        ```powershell
        Unblock-File -Path .\windows-activation.ps1
        ```
    4.  Now, run the script:
        ```powershell
        .\windows-activation.ps1
        ```

The script will then:
1.  Install the product key from `key.txt`.
2.  Attempt to activate Windows.
3.  Display the current license status.

## Prerequisites

*   A valid Windows product key.
*   An active internet connection for activation.
*   (If not using the `Unblock-File` method) PowerShell execution policy must allow running local scripts. You can set it for the current process by running the following command in an elevated PowerShell window before running the script:
    ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope Process
    ```

## Disclaimer

This script is for educational purposes only. Ensure you have a legitimate license for the version of Windows you are activating. The author is not responsible for any misuse of this script.
