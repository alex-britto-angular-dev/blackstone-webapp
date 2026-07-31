$build = "$PSScriptRoot\..\dist\blackstone-starter"
$destination = "C:\inetpub\wwwroot"

Write-Host "Deploying..."

if (!(Test-Path $build)) {
    throw "Build folder not found: $build"
}

Copy-Item "$build\*" -Destination $destination -Recurse -Force

Write-Host "Deployment completed."
