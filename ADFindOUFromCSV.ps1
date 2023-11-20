# Import the Active Directory module - required for Get-ADUser
Import-Module ActiveDirectory

# Define the path to the CSV file
$csvPath = "Path\To\Your\CSVFile.csv" # Users will update this path

# Read the CSV file into a variable
$users = Import-Csv -Path $csvPath

# Define the OUs to exclude (Users should update these)
$excludedOUs = @(
    "OU=ExcludeOU1,OU=ParentOU,DC=YourDomain,DC=com",
    "OU=ExcludeOU2,OU=ParentOU,DC=YourDomain,DC=com",
    "OU=ExcludeOU3,OU=ParentOU,DC=YourDomain,DC=com"
)

# Define the function to pad the Payroll ID
Function Pad-PayrollID($id) {
    # This function pads the ID based on specific rules
    # Users should modify it to match their ID format
    if ($id -match "^\d+$") { # Check if the ID is numeric
        if ($id.StartsWith("1")) {
            return $id.PadLeft(8, "0")
        } else {
            return "0" + $id.PadLeft(7, "0")
        }
    } else {
        Write-Warning "Payroll ID is not numeric: '$id'"
        return $null
    }
}

# Check if a user's OU should be excluded
Function IsExcludedOU($distinguishedName) {
    foreach ($ou in $excludedOUs) {
        if ($distinguishedName -like "*$ou") {
            return $true
        }
    }
    return $false
}

# Loop through each user in the CSV
foreach ($user in $users) {
    # Check if the PayrollID is present and numeric
    if (![string]::IsNullOrEmpty($user.PayrollID)) {
        # Pad the Payroll ID accordingly
        $formattedID = Pad-PayrollID $user.PayrollID

        if ($formattedID -ne $null) {
            # Query Active Directory for the user by their username
            try {
                $adUser = Get-ADUser -Filter "sAMAccountName -eq '$formattedID'" -Properties DistinguishedName -ErrorAction Stop

                # If user is found, check if they are in an excluded OU
                if ($adUser -and !(IsExcludedOU $adUser.DistinguishedName)) {
                    $ou = ($adUser.DistinguishedName -split ",", 2)[1]
                    Write-Host "User $($user.FirstName) $($user.Surname) with username $formattedID is in OU $ou"
                }
            } catch {
                Write-Warning "Error querying AD for user with username ${formattedID}: $_"
            }
        }
    } else {
        Write-Warning "PayrollID for $($user.FirstName) $($user.Surname) is missing or empty in the CSV file."
    }
}
