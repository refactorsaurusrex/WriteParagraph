$ErrorActionPreference = 'Stop'

if ($env:APPVEYOR_REPO_TAG -eq 'true') {
  Write-Host "Publishing to the PowerShell Gallery..."
  Publish-Module -NuGetApiKey $env:psgallery -Path .\publish\WriteParagraph
  Write-Host "Package successfully published to the PowerShell Gallery."
} else {
  Write-Host "No tags pushed. Skipping deployment."
}