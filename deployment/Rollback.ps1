$backup = "D:\Backups\Blackstone"
$destination = "C:\inetpub\wwwroot"

Write-Host "===== Rollback Started ====="

Copy-Item "$backup\*" `
          -Destination $destination `
          -Recurse `
          -Force

Write-Host "===== Rollback Completed ====="