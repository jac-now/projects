<#
.NOTES  

    File Name  : Citrix Workspace LTSR Install Combined
    Author     : Jac-now
    Requires   : PowerShell V3.0
	Intructions: Place .ps1 in C:\Temp and open an administrator shell and run:
					powershell -ExecutionPolicy Bypass -File C:\Temp\CitrixWorkspaceLTSRInstallSelector.ps1
				  Choose appropriate option between 1-4
#>

if (!(Test-Path -Path C:\Temp)) {
    New-Item -ItemType Directory -Path C:\Temp
};  #Tests is C:\Temp exists, and creates if not
cd \Temp

Write-Host " "
Write-Host "1. For Store 1"
Write-Host "2. For Store 2"
Write-Host "3. For Both Stores"
Write-Host "4. Run ReceiverCleanupUtility for a cleaner uninstall"
Write-Host "   Or Ctrl+c to exit"
Write-Host " "
$choice = Read-Host "Please enter your choice (1-4)"

switch ($choice) {
    '1' {
        $download = Invoke-WebRequest -UseBasicParsing -Uri ("https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-windows-ltsr/workspace-app-for-windows-LTSR-CU6-HF2.html") -SessionVariable websession
        $href = $download.Links|Where-Object {$_.rel -like "*CitrixWorkspaceApp.exe*"}
        $DLurl = "https:" + $href.rel

        Write-Host "Downloading Citrix Workspace 2203 Installer"
        Invoke-WebRequest -Uri ($DLurl) -WebSession $websession -UseBasicParsing -OutFile "C:\Temp\CitrixWorkspaceApp.exe" #dynamically parses the page for a valid download url and retrieves the installer to C:\Temp


        $uninstallChoice = Read-Host "Would you like to uninstall the current version before installing? (y/n)" #Allows option to bypass uninstall for if clean up tool was already run or no Citrix currently installed
        if ($uninstallChoice -eq 'y') {
            Write-Host "Uninstalling currently installed version of Citrix Workspace"
            .\CitrixWorkspaceApp.exe /silent /uninstall #Uninstalls the previous installed citrix version
            Start-Sleep -Seconds 150 #sleep added to allow uninstall to finish before installer launches
        }

        Write-Host "Installing Citrix Workspace 2203 with Store 1"
        .\CitrixWorkspaceApp.exe AutoUpdateCheck=disabled /silent /CleanInstall STORE0="Store name;storeurl;On;Store Description" ALLOWADDSTORE=S #silently installs,and sets store, disables update checks
        Start-Sleep -Second 30
        Write-Host " "
        Write-Host "Script Completed"
        Write-Host " "
        Exit 0
    }

    '2' {
        $download = Invoke-WebRequest -UseBasicParsing -Uri ("https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-windows-ltsr/workspace-app-for-windows-LTSR-CU6-HF2.html") -SessionVariable websession
        $href = $download.Links|Where-Object {$_.rel -like "*CitrixWorkspaceApp.exe*"}
        $DLurl = "https:" + $href.rel

        Write-Host "Downloading Citrix Workspace 2203 Installer"
        Invoke-WebRequest -Uri ($DLurl) -WebSession $websession -UseBasicParsing -OutFile "C:\Temp\CitrixWorkspaceApp.exe"; #dynamically parses the page for a valid download url and retrieves the installer to C:\Temp
        
        $uninstallChoice = Read-Host "Would you like to uninstall the current version before installing? (y/n)" #Allows option to bypass uninstall for if clean up tool was already run or no Citrix currently installed
        if ($uninstallChoice -eq 'y') {
        Write-Host "Uninstalling currently installed version of Citrix Workspace"
        .\CitrixWorkspaceApp.exe /silent /uninstall; #Uninstalls the previous installed citrix version
        Start-Sleep -Seconds 150;#sleep added to allow uninstall to finish before installer launches
        }

		Write-Host "Installing Citrix Workspace 2203 with Store 2"
        .\CitrixWorkspaceApp.exe AutoUpdateCheck=disabled /silent /CleanInstall STORE0="Store name;storeurl;On;Store Description" ALLOWADDSTORE=S #silently installs,and sets store, disables update checks
        Start-Sleep -Second 30
        Write-Host " "
        Write-Host "Script Completed"
        Write-Host " "
        Exit 0
    }
    '3' {
        $download = Invoke-WebRequest -UseBasicParsing -Uri ("https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-windows-ltsr/workspace-app-for-windows-1912ltsr1.html") -SessionVariable websession
        $href = $download.Links|Where-Object {$_.rel -like "*CitrixWorkspaceApp.exe*"}
        $DLurl = "https:" + $href.rel

        Write-Host "Downloading Citrix Workspace 1912 Installer"
        Invoke-WebRequest -Uri ($DLurl) -WebSession $websession -UseBasicParsing -OutFile "C:\Temp\CitrixWorkspaceApp.exe"; #dynamically parses the page for a valid download url and retrieves the installer to C:\Temp

        $uninstallChoice = Read-Host "Would you like to uninstall the current version before installing? (y/n)" #Allows option to bypass uninstall for if clean up tool was already run or no Citrix currently installed
        if ($uninstallChoice -eq 'y') {
        Write-Host "Uninstalling currently installed version of Citrix Workspace"
        .\CitrixWorkspaceApp.exe /silent /uninstall; #Uninstalls the previous installed citrix version
        Start-Sleep -Seconds 150;#sleep added to allow uninstall to finish before installer launches
        }

		Write-Host "Installing Citrix Workspace 1912 with Both Stores"
        .\CitrixWorkspaceApp.exe AutoUpdateCheck=disabled /silent /CleanInstall STORE0="Store name;storeurl;On;Store Description" STORE1="Store name;storeurl;On;Store Description" ALLOWADDSTORE=S #silently installs,and sets store, disables update checks
        Start-Sleep -Second 30
        Write-Host " "
        Write-Host "Script Completed"
        Write-Host " "
        Exit 0
    }

    '4' {
        $versions = Get-ChildItem -Path "C:\Program Files (x86)\Citrix\" -Filter "Citrix WorkSpace *" -Directory
        $found = $false

        #Checks to see if ReceiverCleanupUtility already exists in a current Citrix Install and runs it if so
        Write-Host "Checking for ReceiverCleanupUtility"
        foreach ($version in $versions) {
         $filePath = Join-Path -Path $version.FullName -ChildPath "ReceiverCleanupUtility.exe"
            if (Test-Path -Path $filePath) {
             Write-Host "File exists at path: $filePath"
                Start-Process -FilePath $filePath
                $found = $true
                Write-Host "Cleanup utility launched, when finished press Enter to continue"
                $null = Read-Host
                # Delete the Citrix folder from Program Files
                $CitrixFolderPath = "C:\Program Files (x86)\Citrix"
                if (Test-Path -Path $CitrixFolderPath) {
                    Write-Host "Deleting Citrix folder from Program Files"
                    Remove-Item -Path $CitrixFolderPath -Recurse -Force
                }
                .\CitrixWorkspaceLTSRInstallSelector.ps1 #Restarts script from beginning to start install
            }
        }
        $tempPath = "C:\Temp\ReceiverCleanupUtility.exe"
        if (-not $found) {
            Write-Host "Cleanup utility not found in Program Files, please place it in C:\Temp and press Enter to continue"
            $null = Read-Host
            if (Test-Path -Path $tempPath) {
                Write-Host "Running cleanup utility from C:\Temp. Press Enter when complete:"
                Start-Process -FilePath $tempPath
                 $null = Read-Host
                 # Delete the Citrix folder from Program Files
                    $CitrixFolderPath = "C:\Program Files (x86)\Citrix"
                    if (Test-Path -Path $CitrixFolderPath) {
                        Write-Host "Deleting Citrix folder from Program Files"
                     Remove-Item -Path $CitrixFolderPath -Recurse -Force
                 }
                .\CitrixWorkspaceLTSRInstallSelector.ps1 #Restarts script from beginning to start install
            } else {
                Write-Host "Cleanup utility not found in C:\Temp, starting script from beginning."
                .\CitrixWorkspaceLTSRInstallSelector.ps1 #Restarts script from beginning to start install
            }          
        }
    
    }
    default {
        Write-Host "Invalid choice. Please enter a number between 1 and 4."
    }
}

