<#
.SYNOPSIS
    Activates Windows using a product key from a file.

.DESCRIPTION
    This script reads a product key from a 'key.txt' file located in the same directory.
    It then uses the 'slmgr.vbs' command-line tool to install the product key and activate Windows.
    The script requires administrative privileges to run.

.AUTHOR
    Jac-Now (https://github.com/jac-now)

.NOTES
    Date: 2025-08-02
    This script is for legitimate purposes only.
    Ensure you have a legitimate license for the version of Windows you are activating.

.EXAMPLE
    PS C:\> .\windows-activation.ps1
    This command will execute the script, read the key from key.txt, install it, and attempt activation.
#>

# Get the path of the directory the script is running from
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Define the file path for the key
$keyFile = Join-Path -Path $scriptPath -ChildPath "key.txt"

# Read the product key from the text file
try {
    $productKey = Get-Content -Path $keyFile -Raw
    if ([string]::IsNullOrEmpty($productKey)) {
        Write-Host "Error: The key file is empty." -ForegroundColor Red
        return
    }
}
catch {
    Write-Host "Error: Could not read the key file. Make sure 'key.txt' exists in the same directory as the script." -ForegroundColor Red
    return
}

# Install the product key silently and check the exit code
Write-Host "Attempting to install the product key..." -ForegroundColor Yellow
$installResult = Start-Process -FilePath "cscript.exe" -ArgumentList "C:\Windows\System32\slmgr.vbs", "/ipk", $productKey -Wait -PassThru -NoNewWindow
if ($installResult.ExitCode -eq 0) {
    Write-Host "Product key installation successful." -ForegroundColor Green
} else {
    Write-Host "Failed to install the product key. Exit code: $($installResult.ExitCode)" -ForegroundColor Red
}

# Activate Windows silently and check the exit code
Write-Host "`nAttempting to activate Windows..." -ForegroundColor Yellow
$activationResult = Start-Process -FilePath "cscript.exe" -ArgumentList "C:\Windows\System32\slmgr.vbs", "/ato" -Wait -PassThru -NoNewWindow
if ($activationResult.ExitCode -eq 0) {
    Write-Host "Windows activation successful." -ForegroundColor Green
} else {
    Write-Host "Failed to activate Windows. Exit code: $($activationResult.ExitCode)" -ForegroundColor Red
}

# Display detailed license information to confirm activation
Write-Host "`nDisplaying current license information..."
cscript.exe C:\Windows\System32\slmgr.vbs /dlv

# Pause the script to allow the user to see the output
Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
