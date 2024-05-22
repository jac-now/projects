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