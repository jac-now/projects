# PowerShell Scripts

This directory contains a collection of PowerShell scripts for various system administration and automation tasks.

## Scripts

- **CitrixWorkspaceLTSRInstallSelector.ps1**: Downloads and installs specific Citrix Workspace LTSR versions, with an option to run the Receiver Cleanup Utility.
- **Disable_IPv6_All_Adapters.ps1**: Disables IPv6 on all network adapters.
- **DL-Bulk-Import.ps1**: Bulk imports mail contacts from a CSV and adds them to a distribution list.
- **emailmodifier.ps1**: Generates modified email addresses with a `+` and a custom string (or a hash of the string) for tracking and filtering.
- **hostscan.ps1**: Scans a /24 network, pings each host, and attempts to resolve its hostname.
- **Inactive_Account_Audit.ps1**: Audits Active Directory for user accounts that have been inactive for a specified period and exports the results to a CSV.
- **ipscan.ps1**: A simple IP scanner that pings all addresses in a /24 network to find online hosts.
- **M365-LicenseList.ps1**: Connects to Microsoft 365 and exports a list of all licensed users and their assigned licenses to a CSV file.
- **MFA_Audit.ps1**: Audits Azure Active Directory for user MFA status and exports a report to a CSV file.
- **ostremoval.ps1**: Deletes Outlook OST files from user profiles to free up disk space.
- **Password_audit.ps1**: Audits Active Directory for users whose passwords have not been changed in a specified number of days and exports the list to a CSV.
- **Shared_Mailbox_Audit.ps1**: Audits shared mailboxes for delegation and forwarding rules, exporting the results to a CSV.
- **windows-update.ps1**: Installs all available Windows updates, including optional driver and Microsoft product updates.
- **winget_software_install.ps1**: Installs a predefined list of software on a new machine using the winget package manager.
