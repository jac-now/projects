<#
.SYNOPSIS
    Deletes all OST files for all users on a machine.
.DESCRIPTION
    This script iterates through all user profiles on a machine and deletes all OST files found in the user's AppData folder.
.NOTES
    Author: Jac-Now (https://github.com/jac-now)
    The script is currently in a testing state and will only print the files that would be deleted. To run the script live, uncomment the appropriate lines.
.EXAMPLE
    PS C:\> .\ostremoval.ps1
    This command will execute the script and list all OST files that would be deleted.
#>

#Get all user profiles

$UserProfiles = Get-ChildItem "C:\Users\" -Directory

# Iterate through each user profile
foreach ($User in $UserProfiles) {
    #Concatenate the path to the OST files
    $OstFilePath = "C:\Users\" + $User.Name + "\AppData\Local\Microsoft\Outlook\*.ost"

    #Check if OST file exists for current user
    if (Test-Path $OstFilePath) {
        # Get all OST files
        $OstFiles = Get-ChildItem $OstFilePath

        #Iterate through loop for each OST file and print action to screen
        foreach ($OstFile in $ostFiles) {
            # Delete the OST file
			try {
				#Remove-Item $OstFile.FullName -Force #Uncomment line to run live
				#Write-Host "Deleted OST file: $($OstFile.FullName)" #Uncomment line to run live
				Write-Host "OST file that would be deleted: $($OstFile.FullName)" #Comment line out when running live
				}
			catch {
				Write-Host = "Error occured: $_"
			}
        }
    } else {
        Write-Host "No OST files found for user: $($User.Name)"
    }
}
