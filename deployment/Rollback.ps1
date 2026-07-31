$backup = "D:\Backups\Blackstone"
$destination = "C:\inetpub\wwwroot"

Write-Host "Rolling back..."

Copy-Item "$backup\*" -Destination $destination -Recurse -Force

Write-Host "Rollback completed."
