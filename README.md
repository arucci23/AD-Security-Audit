Active Directory Security Audit Script

Overview
This PowerShell script audits an Active Directory (AD) environment for potential security risks. The script identifies inactive user accounts, users with "Password Never Expires" enabled, privileged users in high-level AD groups, and stale computer accounts. The results are exported to a CSV file for further analysis.

Features

Identifies inactive user accounts (90+ days)

Detects users with "Password Never Expires" enabled

Lists members of privileged AD groups (Domain Admins, Enterprise Admins)

Finds stale computer accounts (inactive for 180+ days)

Exports findings to a CSV report

Prerequisites

PowerShell must be running with Administrator privileges.

The script must be executed in a domain environment with appropriate permissions to query Active Directory.

The Active Directory PowerShell module must be installed and imported (Import-Module ActiveDirectory).

Usage

Open PowerShell as Administrator.

Run the script:
.\AD_Security_Audit.ps1

The script will generate a report and save it to:
C:\AD_Audit_Report.csv

Open the CSV file in a spreadsheet application for review.

Output
The script exports a CSV file containing the following columns:

Name: The name of the user or computer account.

SamAccountName: The AD username.

Issue: The identified security issue (e.g., "Inactive User", "Password Never Expires", "Stale Computer").

Group: (If applicable) The high-privilege group a user belongs to.

Notes

Modify the $InactiveDays and $ComputerInactiveDays variables to adjust inactivity thresholds.

Ensure the script is run with proper domain administrative privileges for accurate results.

This script does not modify any accounts; it only reports potential security risks.
