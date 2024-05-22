import hashlib

#Asks user for email, string to append, and if extra protection should be taken
#Splits email into 2 portions with '@' delimiter and appends the string with a '+' and reforms the email address
#If account requires extra protection the string is hashed and the first 8 characters of the hash is used instead of the string
def modify_email():
    email = input("Enter your email address: ")
    append_str = input("Enter a string to append to your email: ")
    req_hash = input("Does this account require extra protection? (yes/no): ").lower()

    email_modded = email.split('@')[0]+ "+" + append_str + "@" + email.split('@')[1]

    if req_hash == "yes":
        hash_object = hashlib.md5(append_str.encode())  #Create MD5 hash
        hash_only = hash_object.hexdigest() #Pass MD5 hash only
        email_modded = email.split('@')[0] + "+" + hash_only[:8] + "@" + email.split('@')[1] #Append first 8 characters of MD5 hash to email

    return("Your modified email address is:", email_modded)

print(modify_email())


###ToDo###
#Add input validation
#Create Powershell version for Windows environments that lack Python
