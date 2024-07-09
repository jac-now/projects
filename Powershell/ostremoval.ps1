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
				#Remove-Item $OstFile.FullName -Force
				#Write-Host "Deleted OST file: $($OstFile.FullName)"
				Write-Host "OST file that would be deleted: $($OstFile.FullName)"
				}
			catch {
				Write-Host = "Error occured: $_"
			}
        }
    } else {
        Write-Host "No OST files found for user: $($User.Name)"
    }
}
