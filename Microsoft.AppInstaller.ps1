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
	[ValidateSet('Install')]
	[string]$DeploymentType = 'Install'
)

Try {

 	If ($DeploymentType -ieq 'Install')
	{

		## Download App and Dependencies
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
		Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
		Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile Microsoft.UI.Xaml.2.8.x64.appx
		
		## Enable Sideloading
		Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Appx" -Name AllowDevelopmentWithoutDevLicense -Value 1
		
		## Install
		Add-AppxProvisionedPackage -Online -PackagePath Microsoft.VCLibs.x64.14.00.Desktop.appx -SkipLicense -ErrorAction SilentlyContinue
		Add-AppxProvisionedPackage -Online -PackagePath Microsoft.UI.Xaml.2.8.x64.appx -SkipLicense -ErrorAction SilentlyContinue
		Add-AppxProvisionedPackage -Online -PackagePath Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -SkipLicense -ErrorAction SilentlyContinue

	}

}
Catch {

}
