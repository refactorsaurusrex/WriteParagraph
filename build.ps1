param(
  [string]$Version = ''
)

$ErrorActionPreference = 'Stop'
$appName = "WriteParagraph"

if ($env:APPVEYOR_REPO_TAG -eq 'true') {
  $Version = [regex]::match($env:APPVEYOR_REPO_TAG_NAME,'[0-9]+\.[0-9]+\.[0-9]+').Groups[0].Value
  $module = Find-Module -Name $appName -ErrorAction SilentlyContinue
  if ($null -eq $module) {
    Write-Host "First time publishing module. Version is $Version."
  } else {
    $lastPublishedVersion = [Version]::new(($module | Select-Object -ExpandProperty Version))
    if ([Version]::new($Version) -le $lastPublishedVersion) {
      throw "Version must be greater than the last published version, which is 'v$lastPublishedVersion'."
    }
    Write-Host "Last published version: 'v$lastPublishedVersion'. Current version: 'v$Version'"
  }
} elseif ($null -ne $env:APPVEYOR_BUILD_NUMBER) {
  $Version = "0.0.$env:APPVEYOR_BUILD_NUMBER"
} elseif ($Version -eq '') {
  $Version = "0.0.0"
}

Write-Host "Building version '$Version'..."

if (Test-Path "$PSScriptRoot\publish") {
  Remove-Item -Path "$PSScriptRoot\publish" -Recurse -Force
}

$publishOutputDir = "$PSScriptRoot\publish\$appName"
$proj = Get-ChildItem -Filter "$appName.csproj" -Recurse -Path $PSScriptRoot | Select-Object -First 1 -ExpandProperty FullName

foreach ($target in 'win-x64','linux-x64','osx-x64') {
  dotnet publish $proj --output $publishOutputDir -c Release --self-contained false -r $target
}

if ($LASTEXITCODE -ne 0) {
  throw "Failed to publish application."
}

Remove-Item "$publishOutputDir\*.pdb"

Import-Module "$publishOutputDir\$appName.dll"
$moduleInfo = Get-Module $appName
Install-Module WhatsNew
Import-Module WhatsNew
$cmdletNames = Export-BinaryCmdletNames -ModuleInfo $moduleInfo
$cmdletAliases = Export-BinaryCmdletAliases -ModuleInfo $moduleInfo

$manifestPath = "$publishOutputDir\$appName.psd1"

$newManifestArgs = @{
  Path = $manifestPath
}

$updateManifestArgs = @{
  Path = $manifestPath
  CopyRight = "(c) $((Get-Date).Year) Nick Spreitzer"
  Description = "Write-Host, now with word wrapping!"
  Guid = '3ccfc8bb-32d1-4c9a-9647-b8d95eb966b2'
  Author = 'Nick Spreitzer'
  CompanyName = 'RAWR! Productions'
  ModuleVersion = $Version
  AliasesToExport = $cmdletAliases
  NestedModules = ".\$appName.dll"
  CmdletsToExport = $cmdletNames
  CompatiblePSEditions = @("Desktop","Core")
  HelpInfoUri = "https://github.com/refactorsaurusrex/WriteParagraph"
  PowerShellVersion = "6.0"
  PrivateData = @{
    Tags = 'write-host','word-wrap'
    LicenseUri = 'https://github.com/refactorsaurusrex/WriteParagraph/blob/master/LICENSE'
    ProjectUri = 'https://github.com/refactorsaurusrex/WriteParagraph'
  }
}

New-ModuleManifest @newManifestArgs
Update-ModuleManifest @updateManifestArgs
Remove-ModuleManifestComments $manifestPath -NoConfirm