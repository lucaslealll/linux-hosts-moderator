# This script blocks or unblocks access to specific websites on Windows,
# using the hosts file located at C:\Windows\System32\drivers\etc\hosts.
# It has been adapted to handle site lists in the format used by StevenBlack/hosts.
# Source: https://github.com/StevenBlack/hosts

# Path to the hosts file
$hostsFile = "C:\Windows\System32\drivers\etc\hosts"
# IP to redirect to (localhost)
$redirectIP = "127.0.0.1"
# Base directory for site categories to be blocked
$categoriesDir = "categories"

# Function to add sites to the hosts file
function Block-Sites {
    param (
        [string]$category
    )

    $categoryFile = Join-Path $categoriesDir "$category\list.txt"

    # Check if the category file exists
    if (Test-Path $categoryFile) {
        Get-Content $categoryFile | ForEach-Object {
            $line = $_.Trim()

            # Ignore comment lines or blank lines
            if ($line -match "^#" -or [string]::IsNullOrWhiteSpace($line)) {
                return
            }

            # Extract the domain from the line that starts with "0.0.0.0"
            $domain = $line -replace "0\.0\.0\.0\s+", ""

            # Check if the domain is already in the hosts file
            if (-not (Select-String -Path $hostsFile -Pattern $domain)) {
                Write-Host "Blocking $domain from category $category..."
                Add-Content -Path $hostsFile -Value "$redirectIP $domain"
            } else {
                Write-Host "$domain from category $category is already blocked."
            }
        }
    } else {
        Write-Host "The category $category does not exist."
    }
}

# Function to remove blocked sites from the hosts file
function Unblock-Sites {
    param (
        [string]$category
    )

    $categoryFile = Join-Path $categoriesDir "$category\sites_list.txt"

    # Check if the category file exists
    if (Test-Path $categoryFile) {
        $content = Get-Content $hostsFile

        Get-Content $categoryFile | ForEach-Object {
            $line = $_.Trim()

            # Ignore comment lines or blank lines
            if ($line -match "^#" -or [string]::IsNullOrWhiteSpace($line)) {
                return
            }

            # Extract the domain from the line that starts with "0.0.0.0"
            $domain = $line -replace "0\.0\.0\.0\s+", ""

            # Remove the domain from the hosts file
            $content = $content -notmatch $domain
        }

        # Write the updated content back to the hosts file
        Set-Content -Path $hostsFile -Value $content
    } else {
        Write-Host "The category $category does not exist."
    }
}

# Function to process all categories
function Process-AllCategories {
    param (
        [string]$action
    )

    Get-ChildItem -Directory $categoriesDir | ForEach-Object {
        $category = $_.Name
        & $action -category $category
    }
}

# Options menu
param (
    [string]$action,
    [string]$category
)

switch ($action) {
    "block" {
        if ($category) {
            Block-Sites -category $category
        } else {
            Process-AllCategories -action Block-Sites
        }
    }
    "unblock" {
        if ($category) {
            Unblock-Sites -category $category
        } else {
            Process-AllCategories -action Unblock-Sites
        }
    }
    default {
        Write-Host "Usage: .\block_sites.ps1 {block|unblock} [category]"
        Write-Host "Example: .\block_sites.ps1 block social"
        exit 1
    }
}
