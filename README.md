# ADUserOULookup

## Overview
`ADUserOULookup` is a PowerShell script for querying Active Directory to determine the Organizational Unit (OU) of users based on Payroll IDs provided in a CSV file. It's designed for environments where Active Directory usernames correspond with payroll or employee IDs. The script also allows excluding specific OUs from the results.

## Prerequisites
- PowerShell 5.1 or higher.
- Active Directory module for PowerShell.
- Required permissions to query user accounts in Active Directory.

## Installation
This script does not require installation. However, ensure the Active Directory module is available in your PowerShell environment:

```powershell
Import-Module ActiveDirectory

## Configuration
Before running the script, configure the following elements:

CSV File Path: Update the $csvPath variable with the path to your CSV file.
Excluded OUs: Modify the $excludedOUs array with the Distinguished Names (DNs) of OUs to exclude.
ID Formatting: Adjust the Pad-PayrollID function to match your specific ID formatting requirements.

## CSV File Format
Your CSV file should have the following headers: FirstName, Surname, PayrollID. Ensure adherence to this format:
FirstName,Surname,PayrollID
John,Doe,12345678
Jane,Smith,87654321

## Usage
To use the script:

Open PowerShell.
Navigate to the script's directory.
Execute the script: .\ADUserOULookup.ps1
Output
The script outputs a list of users with their respective OUs, excluding users in the specified OUs.

## Troubleshooting
Confirm that the AD employeeID attribute matches the ID format in your CSV.
Check the accessibility and correctness of the CSV file path.
Ensure you have the necessary permissions to query Active Directory.
