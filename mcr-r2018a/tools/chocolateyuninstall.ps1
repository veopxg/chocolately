$ErrorActionPreference = 'Stop'

$DisplayVersion = '9.4'
$softwareName = 'MATLAB Runtime ' + $DisplayVersion

$RegistryLocation = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall'
$unexe = Get-ItemProperty "$RegistryLocation\*" | 
                     Where-Object { $_.displayname -match $softwareName} |
                     Select-Object -ExpandProperty UninstallString

$InstalledPath = $unexe -replace "^(.*v$($DisplayVersion.replace('.','')))\\.*",'$1'
Write-Output $unexe
Write-Output $InstalledPath
$a = $unexe.LastIndexOf($InstalledPath)
Write-Output $a
$unexe = $unexe.remove(($unexe.LastIndexOf($InstalledPath)))

$UninstallArgs = @{
   packageName = $env:ChocolateyPackageName
   fileType = 'exe'
   file = $unexe
   silentArgs = '"' + $InstalledPath + '" -mode silent'
   validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @UninstallArgs

if (Test-Path $InstalledPath) {
   Remove-Item $InstalledPath -Recurse
}