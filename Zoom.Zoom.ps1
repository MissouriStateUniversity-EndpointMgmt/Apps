<#
.SYNOPSIS
	
.DESCRIPTION

.EXAMPLE
	
.NOTES
	Author:      Brian Hays
    Created:     2024-06-05
    Updated:     2024-06-05
	
    Version history:
    1.0.0 - (2024-06-05) - Script created

#>

[CmdletBinding()]
Param (
	[Parameter(Mandatory=$false)]
	[ValidateSet('Install','Uninstall')]
	[string]$DeploymentType = 'Install'
)

$invoc = (Get-Variable MyInvocation).Value
$sourcePath = Split-Path $invoc.MyCommand.Path

Write-Host $invoc
Write-Host $sourcePath

Try {

	Write-Host "Starting"
 	Write-Host $DeploymentType

 	If ($DeploymentType -ieq 'Install')
	{

  		Write-Host "Install Section"
		Write-Host $PSScriptRoot
	
  		Write-Host "Downloading"
		# Download latest release from Zoom
		$downloadUri = "https://zoom.us/client/latest/ZoomInstallerFull.msi?archType=x64"
		$filePath = Join-Path -Path $PSScriptRoot -ChildPath "ZoomInstallerFull.msi"
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri $downloadUri -Out $filePath -UseBasicParsing
		
  		Write-Host "Installing"
		# Install
		Start-Process msiexec.exe -Wait -PassThru -ArgumentList "/i ZoomInstallerFull.msi /qn /norestart MSIRestartManagerControl=Disable ZSSOHOST='missouristate' ZoomAutoUpdate=1 ZConfig='kCmdParam_InstallOption=8;EnableEmbedBrowserForSSO=1' ZRecommend='AudioAutoAdjust=1'"

    	Write-Host "Finished"
  
	}
	ElseIf ($DeploymentType -ieq 'Uninstall')
	{
		
  		Write-Host "Uninstall Section"
  
		## Uninstall Zoom
		Install-PackageProvider -Name NuGet -Force | Out-Null
		Get-Package -Name "Zoom*(64-bit)" -ErrorAction SilentlyContinue | Uninstall-Package

      		Write-Host "Finished"

	}

 	Write-Host "End"

}
Catch {

}
