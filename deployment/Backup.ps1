$source = "C:\inetpub\wwwroot"

# Get latest Git commit details
$commitId = git rev-parse --short HEAD
$commitMsg = git log -1 --pretty=%s

# Fallback values
if ([string]::IsNullOrWhiteSpace($commitId)) {
    $commitId = "UnknownCommit"
}

if ([string]::IsNullOrWhiteSpace($commitMsg)) {
    $commitMsg = "NoCommitMessage"
}

# Remove invalid characters for Windows folder names
$commitMsg = $commitMsg -replace '[\\/:*?"<>|]', ''
$commitMsg = $commitMsg -replace '\s+', '_'

# Limit commit message length
if ($commitMsg.Length -gt 50) {
    $commitMsg = $commitMsg.Substring(0,50)
}

# Backup Folder
$backup = "D:\Backups\Blackstone\$commitId`_$commitMsg"

Write-Host "===== Backup Started ====="
Write-Host "Commit ID      : $commitId"
Write-Host "Commit Message : $commitMsg"
Write-Host "Backup Location: $backup"

# If folder already exists, append build number or timestamp
if (Test-Path $backup) {
    $buildNo = $env:BUILD_NUMBER
    if ([string]::IsNullOrWhiteSpace($buildNo)) {
        $buildNo = Get-Date -Format "yyyyMMddHHmmss"
    }
    $backup = "${backup}_Build$buildNo"
}

New-Item -ItemType Directory -Path $backup -Force | Out-Null

Copy-Item "$source\*" -Destination $backup -Recurse -Force

Write-Host "===== Backup Completed ====="
Write-Host "Backup Saved To: $backup"