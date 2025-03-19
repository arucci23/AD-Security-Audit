<#
.SYNOPSIS
	Active Directory Security Audit Script

.DESCRIPTION
	This PowerShell script audits Active Directory for potential security risks, including:
	-Inactive user accounts (90+ days)
	-Users with "Password Never Expires" set
	-Users in high-privilege groups (Domain Admins, Enterprise Admins)
	-Stale computer accounts (180+ days inactive)
	-Exports findings to a CSV report

.AUTHOR
	Adam Rucci

.NOTES
	Run this script with Administrator privileges in a domain environment.
#>

# Define output file path
$OutputFile = "C:\AD_Audit_Report.csv"

# Define inactivity thresholds
$InactiveDays = 90
$ComputerInactiveDays = 180

# Calculate date cutoffs
$DateCutoff = (Get-Date).AddDays(-$InactiveDays)
$ComputerDateCutoff = (Get-Date).AddDays(-$ComputerInactiveDays)

Write-Output "Starting Active Directory Security Audit..."

# Find Inactive User Accounts

Write-Output "Finding inactive user accounts..."
$InactiveUsers = Get-ADUser -Filter {LastLogonDate -lt $DateCutoff} -Properties LastLogonDate | Select-Object Name, SamAccountName, LastLogonDate

# Find Users with Password Never Expires

Write-Output "Identifying users with 'Password Never Expires'..."
$PasswordNeverExpires = Get-ADUser -Filter * -Properties PasswordNeverExpires | Where-Object { $_.PasswordNeverExpires -eq $true } | Select-Object Name, SamAccountName

# Find privileged users (Admin Groups)

Write-Output "Checking for privileged users..."
$AdminGroups = @("Domain Admins", "Enterprise Admins")

$PrivilegedUsers = foreach ($Group in $AdminGroups) {
	Get-ADGroupMember -Identity $Group | Select-Object Name, SamAccountName, @{Name="Group"; Expression={$Group}}
}

# Find Stale Computer Accounts

Write-Output "Identifying stale computer accounts..."
$StaleComputers = Get-ADComputer -Filter {LastLogonDate -lt $ComputerDateCutoff} -Properties LastLogonDate | Select-Object Name, SamAccountName, LastLogonDate

# Export Results to CSV

Write-Output "Exporting results to CSV..."

# Combine all data into a single object array
$ReportData = @()
$ReportData += $InactiveUsers | Select-Object Name, SamAccountName, @{Name="Issue"; Expression={"Inactive User"}}
$ReportData += $PasswordNeverExpires | Select-Object Name, SamAccountName, @{Name="Issue"; Expression={"Password Never Expires"}}
$ReportData += $PrivilegedUsers | Select-Object Name, SamAccountName, Group
$ReportData += $StaleComputers | Select-Object Name, SamAccountName, @{Name="Issue"; Expression={"Stale Computer"}}

# Export to CSV file
$ReportData | Export-CSV -Path $OutputFile -NoTypeInformation

Write-Output "AD Security Audit completed! Report saved to $OutputFile"


