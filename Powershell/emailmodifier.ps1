<#
.SYNOPSIS
    Creates a modified email address.
.DESCRIPTION
    This script takes an email address and a string from the user and creates a modified email address.
    It can also hash the string for extra protection.
.NOTES
    Author: Jac-Now (https://github.com/jac-now)
.EXAMPLE
    PS C:\> .\emailmodifier.ps1
    This command will execute the script and prompt the user for an email address and a string to append.
#>

#Asks user for email, string to append, and if extra protection should be taken
#Splits email into 2 portions with '@' delimiter and appends the string with a '+' and reforms the email address
#If account requires extra protection the string is hashed and the first 8 characters of the hash is used instead of the string

function Create-ModifiedEmail {
    $email = Read-Host -Prompt "Enter your email address"
    $appendString = Read-Host -Prompt "Enter a string to append to your email"
    $reqHash = Read-Host -Prompt "Does this account require extra protection? (yes/no)"

    $modifiedEmail = ($email.Split('@')[0] + "+" + $appendString + "@" + $email.Split('@')[1])

    if ($reqHash -ieq "yes") {
        $hash = [System.BitConverter]::ToString([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::Default.GetBytes($appendString))).Replace("-","")
        $modifiedEmail = ($email.Split('@')[0] + "+" + $hash.Substring(0,8) + "@" + $email.Split('@')[1]) 
    }

    Write-Host "Your modified email address is: $modifiedEmail"
}

Create-ModifiedEmail
