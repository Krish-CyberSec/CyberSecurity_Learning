# AD user automation script v2.0
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$dataDir = Join-Path $scriptDir 'Data'

$groupNames = @(Get-Content -LiteralPath (Join-Path $dataDir 'group_names.txt') -ErrorAction Stop | ForEach-Object { ([string]$_).Trim() } | Where-Object { $_ })
$firstNames = @(Get-Content -LiteralPath (Join-Path $dataDir 'first_names.txt') -ErrorAction Stop | ForEach-Object { ([string]$_).Trim() } | Where-Object { $_ })
$lastNames = @(Get-Content -LiteralPath (Join-Path $dataDir 'last_name.txt') -ErrorAction Stop | ForEach-Object { ([string]$_).Trim() } | Where-Object { $_ })
$passwords = @(Get-Content -LiteralPath (Join-Path $dataDir 'password.txt') -ErrorAction Stop | ForEach-Object { ([string]$_).Trim() } | Where-Object { $_ })

$num_groups = 7
$num_users = 7

if ($groupNames.Count -lt $num_groups) {
    throw "At least $num_groups group names are required in '$dataDir\group_names.txt'."
}

if ($firstNames.Count -lt $num_users -or $lastNames.Count -lt $num_users -or $passwords.Count -lt $num_users) {
    throw "At least $num_users first names, last names, and passwords are required in '$dataDir'."
}

$selectedGroupNames = @(Get-Random -InputObject $groupNames -Count $num_groups)
$selectedFirstNames = @(Get-Random -InputObject $firstNames -Count $num_users)
$selectedLastNames = @(Get-Random -InputObject $lastNames -Count $num_users)
$selectedPasswords = @(Get-Random -InputObject $passwords -Count $num_users)

$groups = @($selectedGroupNames)

$users = @(
    for ($i = 0; $i -lt $num_users; $i++) {
        [pscustomobject]@{
            name     = "$($selectedFirstNames[$i]) $($selectedLastNames[$i])"
            password = $selectedPasswords[$i]
            groups   = @((Get-Random -InputObject $selectedGroupNames))
        }
    }
)

$output = [pscustomobject]@{
    Domain = 'DMC.com'
    groups = $groups
    users  = $users
}

Write-Output ($output | ConvertTo-Json -Depth 5 | Out-File -FilePath (Join-Path $scriptDir 'ad_users.json') -Encoding UTF8 -Force)
