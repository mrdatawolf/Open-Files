<#
.SYNOPSIS
    get_open_files.ps1 - Gather the open files on a server and save as a json file.

.DESCRIPTION
    Gather the open files on a server and save as a json file.

.EXAMPLE
    .\get_open_files.ps1

.NOTES
    Author: Patrick Moon
#>
# version = 1.01
# Get open files
$openFiles = Get-SmbOpenFile

# Get active sessions
$sessions = Get-SmbSession

#Current DateTime
$currentDateTime = (Get-Date).ToString("yyyy-MM-dd HH:mm")

# Combine open files with session information
$openFilesWithUsers = $openFiles | ForEach-Object {
    $file = $_
    $session = $sessions | Where-Object { $_.SessionId -eq $file.SessionId }
    [PSCustomObject]@{
        FileName = $file.Path
        UserName = $session.ClientUserName
        SessionId = $file.SessionId
        Current_Date = $currentDateTime
    }
}

# Convert to JSON
$jsonOutput = $openFilesWithUsers | ConvertTo-Json

# Save to a JSON file
$RandomString = -join (48..57 + 65..90 + 97..122 | Get-Random -Count 4 | ForEach-Object { [char]$_ })
$jsonOutput | Set-Content -Path "~\Desktop\open_files_$currentDateTime_$RandomString.json"


# Display a message
Write-Host "File saved to ~\Desktop\open_files.json"
