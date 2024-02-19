# Get open files
$openFiles = Get-SmbOpenFile

# Get active sessions
$sessions = Get-SmbSession

# Combine open files with session information
$openFilesWithUsers = $openFiles | ForEach-Object {
    $file = $_
    $session = $sessions | Where-Object { $_.SessionId -eq $file.SessionId }
    [PSCustomObject]@{
        FileName = $file.Path
        UserName = $session.ClientUserName
        SessionId = $file.SessionId
        Current_Date = (Get-Date).ToString("yyyy-MM-dd HH:mm")
    }
}

# Convert to JSON
$jsonOutput = $openFilesWithUsers | ConvertTo-Json

# Save to a JSON file
$jsonOutput | Set-Content -Path "~\Desktop\open_files.json"

# Display a message
Write-Host "Open files information saved to ~\Desktop\open_files.json"
