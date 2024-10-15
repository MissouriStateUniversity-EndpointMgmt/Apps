<#
.SYNOPSIS
	Uninstalls an Application specified with a parameter
	
.DESCRIPTION
	Uninstalls using Get-Package
	Get Application name by running Get-Package

.EXAMPLE
	powershell.exe -NoProfile -ExecutionPolicy ByPass -File uninstall.ps1 "Dell Command | Update"

.NOTES
	Author:      Brian Hays
    Created:     2023-11-20
	
    Version history:
    1.0.0 - (2023-11-20) - Script created

#>

Param (
  [Parameter(Mandatory=$true)]
  [string]$uninstallName
)

Try {
  Install-PackageProvider -Name NuGet -Force | Out-Null
  Get-Package -Name $uninstallName -ErrorAction SilentlyContinue | Uninstall-Package
}
Catch {

}
