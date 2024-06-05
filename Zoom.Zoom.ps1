Param (
	[Parameter(Mandatory = $True)]
	[String]$AppName,
	[parameter(Mandatory = $True, ParameterSetName = "Install")]
	[switch]$Install,
	[parameter(Mandatory = $True, ParameterSetName = "Uninstall")]
	[switch]$Uninstall
)

switch ($PSCmdlet.ParameterSetName) {
	"Install" {
		Write-Host $AppName
		Write-Host 'Install'
	}
	"Uninstall" {
		Write-Host $AppName
		Write-Host 'Uninstall'
	}
}


# Variables
# $installArgs = "/i ZoomInstallerFull.msi /q /norestart ZRecommend=""AudioAutoAdjust=1"" ZoomAutoUpdate=""true"" ZoomInstallOption=8 ZSSOHOST=""missouristate"" ZConfig=""EnableEmbedBrowserForSSO=1"""
$installArgs = "/i ZoomInstallerFull.msi /qn /norestart MSIRestartManagerControl=Disable ZSSOHOST=""missouristate"" ZoomAutoUpdate=1 ZConfig=""kCmdParam_InstallOption=8;EnableEmbedBrowserForSSO=1"" ZRecommend=""AudioAutoAdjust=1"""

# Download latest release from Zoom
$downloadUri = "https://zoom.us/client/latest/ZoomInstallerFull.msi?archType=x64"
$filePath = Join-Path -Path $PSScriptRoot -ChildPath "ZoomInstallerFull.msi"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $downloadUri -Out $filePath -UseBasicParsing

# Install
$ExitCode = (Start-Process msiexec.exe -Wait -PassThru -ArgumentList $installArgs).ExitCode
return $ExitCode
