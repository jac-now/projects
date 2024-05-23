Just some projects I've created in the past.

DL-Bulk-Import.ps1 requires variables to be configured as needed. Uses CSV files to bulk import mail contacts for external users, as well as CSV to add users to a DL

hostscan.ps1 scans a /24 network for hosts and tries to resolve the hostname. Subnet should be configured to the required subnet

ipscan.ps1 a quicker version of the above that does not include hostname resolution.

expenses.py a simple budget calculator in desperate need to improvement (my first coding project)

magic8ball.py you provide a question, and the magic 8 ball decides if it's a good idea or not

passwordgenerator.py generates a simple password consisting of an adjective and a noun with a special character delimiter and a random number added to the end. Looking to add more functionality to this in the near future. Updated version provides prompt to ask for minimum password length, and runs through iterations adding more words or numbers and special characters until minimum length achieved. Random weight variable added to allow tweaking between likeliness of adding additional word pairs or digit/special characters depending on preference.

emailmodifier.py generates email addresses with a + string appended to assist in the creation of unique logins and determine source of email leaks. Looking to make a PowerShell variant.

ipscan.py scans a /24 network for hosts and tries to resolve the hostname. Prompts user for the first 3 octets of the network to scan and prompts for Windows or *nix based system. Timeout and sleep variables can be adjusted as needed. Debugging lines can be uncommented if issues encountered to assist with troubleshooting.
