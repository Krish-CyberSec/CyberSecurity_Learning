
# ============================================================
# Script Name : CreateADUsers.ps1
# Description : Creates Active Directory groups and users
#               using information provided in a JSON file.
#
# Usage       : .\CreateADUsers.ps1 -JsonFile ".\users.json"
#
# Requirements:
#   - Active Directory PowerShell module
#   - Appropriate AD permissions
#   - Run from a machine with access to the AD domain
# ============================================================

# Accept the JSON configuration file as a mandatory parameter
param(
    [Parameter(Mandatory = $true)]
    [string]$JsonFile
)

# Import the Active Directory module
Import-Module ActiveDirectory -ErrorAction Stop


# ============================================================
# FUNCTION: CreateADGroup
# Description:
#   Creates an Active Directory security group using
#   the group name provided in the JSON configuration.
# ============================================================

function CreateADGroup {

    param(
        [Parameter(Mandatory = $true)]
        [string]$groupName
    )

    try {

        # Check whether the group already exists
        $existingGroup = Get-ADGroup `
            -Filter "Name -eq '$groupName'" `
            -ErrorAction SilentlyContinue

        if ($existingGroup) {
            Write-Warning "Group '$groupName' already exists. Skipping creation."
            return
        }

        # Create a new AD security group
        # GroupScope: Global
        # GroupCategory: Security

        New-ADGroup `
            -Name $groupName `
            -GroupScope Global `
            -GroupCategory Security `
            -ErrorAction Stop

        Write-Host "[SUCCESS] Group created: $groupName" -ForegroundColor Green

    }
    catch {

        # Display the actual error if group creation fails
        Write-Warning "[ERROR] Could not create group '$groupName': $_"

    }
}


# ============================================================
# FUNCTION: CreateADUser
# Description:
#   Creates an Active Directory user and adds the user
#   to the groups specified in the JSON configuration.
# ============================================================

function CreateADUser {

    param(
        [Parameter(Mandatory = $true)]
        $userObject
    )

    # Extract the user's full name
    $name = $userObject.name

    # Split the full name into first name and last name
    # Example: Alex Leu -> FirstName: Alex, LastName: Leu

    $nameParts = $name.Trim() -split '\s+'

    # Validate that the name contains at least two parts
    if ($nameParts.Count -lt 2) {

        Write-Warning "[ERROR] Invalid user name: $name"
        return

    }

    $firstName = $nameParts[0]
    $lastName = $nameParts[-1]

    # Extract the password from the JSON object
    $password = $userObject.password

    # Generate username using:
    # First initial + Last name
    # Example: Alex Leu -> aleu

    $userName = ($firstName.Substring(0, 1) + $lastName).ToLower()

    # Set the SamAccountName
    $samAccName = $userName

    # Generate the User Principal Name (UPN)
    # Example: aleu@DMC.com

    $principalName = "$userName@$Global:Domain"


    try {

        # Check whether the user already exists
        $existingUser = Get-ADUser `
            -Filter "SamAccountName -eq '$samAccName'" `
            -ErrorAction SilentlyContinue

        if ($existingUser) {

            Write-Warning "User '$samAccName' already exists. Skipping creation."
            return

        }

        # Convert the plaintext password into a SecureString
        $securePassword = ConvertTo-SecureString `
            $password `
            -AsPlainText `
            -Force


        # ----------------------------------------------------
        # Create the Active Directory user
        # ----------------------------------------------------

        $newUser = New-ADUser `
            -Name $name `
            -GivenName $firstName `
            -Surname $lastName `
            -SamAccountName $samAccName `
            -UserPrincipalName $principalName `
            -AccountPassword $securePassword `
            -Enabled $true `
            -PassThru `
            -ErrorAction Stop

        Write-Host "[SUCCESS] User created: $name" -ForegroundColor Green


        # ----------------------------------------------------
        # Add the newly created user to specified AD groups
        # ----------------------------------------------------

        foreach ($group in $userObject.groups) {

            try {

                # Retrieve the AD group using its name
                $adGroup = Get-ADGroup `
                    -Identity $group `
                    -ErrorAction Stop

                # Add the newly created user to the group
                Add-ADGroupMember `
                    -Identity $adGroup `
                    -Members $newUser `
                    -ErrorAction Stop

                Write-Host "[SUCCESS] Added $name to group '$group'" `
                    -ForegroundColor Green

            }
            catch {

                # Display a warning if the group does not exist
                # or if membership assignment fails

                Write-Warning "[ERROR] Could not add '$name' to group '$group': $_"

            }

        }

    }
    catch {

        # Handle user creation errors
        Write-Warning "[ERROR] Could not create user '$name': $_"

    }

}


# ============================================================
# MAIN SCRIPT EXECUTION
# ============================================================

try {

    # --------------------------------------------------------
    # Step 1: Validate and read the JSON configuration file
    # --------------------------------------------------------

    if (-not (Test-Path -Path $JsonFile -PathType Leaf)) {

        throw "JSON configuration file not found: $JsonFile"

    }

    # -Raw reads the complete JSON file as one string
    # ConvertFrom-Json converts it into a PowerShell object

    $Json = Get-Content -Path $JsonFile -Raw | ConvertFrom-Json


    # --------------------------------------------------------
    # Step 2: Extract the domain name from JSON
    # --------------------------------------------------------

    $Global:Domain = $Json.Domain

    if ([string]::IsNullOrWhiteSpace($Global:Domain)) {

        throw "Domain property is missing from JSON configuration."

    }

    Write-Host "`nStarting Active Directory provisioning..." `
        -ForegroundColor Cyan

    Write-Host "Target Domain: $Global:Domain" `
        -ForegroundColor Cyan


    # --------------------------------------------------------
    # Step 3: Create all AD groups
    # --------------------------------------------------------

    Write-Host "`n========== CREATING GROUPS ==========" `
        -ForegroundColor Yellow

    foreach ($group in $Json.groups) {

        CreateADGroup $group

    }


    # --------------------------------------------------------
    # Step 4: Create all AD users
    # --------------------------------------------------------

    Write-Host "`n========== CREATING USERS ==========" `
        -ForegroundColor Yellow

    foreach ($user in $Json.users) {

        CreateADUser $user

    }


    # --------------------------------------------------------
    # Step 5: Provisioning completed
    # --------------------------------------------------------

    Write-Host "`nActive Directory provisioning completed!" `
        -ForegroundColor Green

}
catch {

    # Handle errors in the main execution process
    Write-Error "Provisioning failed: $_"

}
