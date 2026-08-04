$source = "C:\inetpub\wwwroot"

# Timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Commit Message from Jenkins
$commitMsg = $env:GIT_COMMIT_MSG

if ([string]::IsNullOrWhiteSpace($commitMsg)) {
    $commitMsg = "NoCommitMessage"
}

# Remove invalid characters for Windows folder names
$commitMsg = $commitMsg -replace '[\\/:*?"<>|]', ''
$commitMsg = $commitMsg -replace '\s+', '_'

# Optional: Limit length
if ($commitMsg.Length -gt 50) {
    $commitMsg = $commitMsg.Substring(0,50)
}

# Backup Folder
$backup = "D:\Backups\Blackstone\$timestamp`_$commitMsg"

Write-Host "===== Backup Started ====="
Write-Host "Backup Location: $backup"

New-Item -ItemType Directory -Path $backup -Force | Out-Null

Copy-Item "$source\*" -Destination $backup -Recurse -Force

Write-Host "===== Backup Completed ====="