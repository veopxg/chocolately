$ErrorActionPreference = 'Stop'

$DisplayVersion = '9.10'
$softwareName = 'MATLAB Runtime ' + $DisplayVersion

$RegistryLocation = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall'
$unexe = Get-ItemProperty "$RegistryLocation\*" | 
                     Where-Object { $_.displayname -match $softwareName} |
                     Select-Object -ExpandProperty UninstallString

$InstalledPath = $unexe -replace "^(.*v$($DisplayVersion.replace('.','')))\\.*",'$1'

$UninstallArgs = @{
   packageName = $env:ChocolateyPackageName
   fileType = 'exe'
   file = $unexe
   silentArgs = '-mode silent'
   validExitCodes = @(0)
}
Write-Output $UninstallArgs

Uninstall-ChocolateyPackage @UninstallArgs

if (Test-Path $InstalledPath) {
   Remove-Item $InstalledPath -Recurse
}