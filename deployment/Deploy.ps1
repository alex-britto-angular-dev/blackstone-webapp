$build = "$PSScriptRoot\..\dist\blackstone-starter"
$destination = "C:\inetpub\wwwroot"

Write-Host "===== Deployment Started ====="

if (!(Test-Path $build)) {
    throw "Build folder not found."
}

Copy-Item "$build\*" `
          -Destination $destination `
          -Recurse `
          -Force

Write-Host "===== Deployment Completed ====="