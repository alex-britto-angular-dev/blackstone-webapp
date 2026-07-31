$source = "C:\inetpub\wwwroot"
$backup = "D:\Backups\Blackstone"

Write-Host "===== Backup Started ====="

if (!(Test-Path $backup)) {
    New-Item -ItemType Directory -Path $backup | Out-Null
}

Copy-Item "$source\*" -Destination $backup -Recurse -Force

Write-Host "===== Backup Completed ====="