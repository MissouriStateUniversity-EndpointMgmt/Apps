<#
.SYNOPSIS
	
.DESCRIPTION

.EXAMPLE
	
.NOTES
	Author:      Brian Hays
	Created:     2024-06-05
	Updated:     2024-10-15
	
	Version history:
	1.0.0 - (2024-06-05) - Script created
	1.0.1 - (2024-10-15) - Removed uninstall option

#>
Try {
	# Variables
	$installArgs = "/i ZoomInstallerFull.msi /qn /norestart MSIRestartManagerControl=Disable ZSSOHOST=""missouristate"" ZoomAutoUpdate=1 ZConfig=""kCmdParam_InstallOption=8;EnableEmbedBrowserForSSO=1"" ZRecommend=""AudioAutoAdjust=1"""

	# Download latest release from Zoom
	$downloadUri = "https://zoom.us/client/latest/ZoomInstallerFull.msi?archType=x64"
	$filePath = Join-Path -Path (Get-Location).Path -ChildPath "ZoomInstallerFull.msi"
	$ProgressPreference = 'SilentlyContinue'
	Invoke-WebRequest -Uri $downloadUri -Out $filePath -UseBasicParsing
	
	# Install
	Start-Process msiexec.exe -Wait -PassThru -ArgumentList $installArgs
}
Catch {

}
