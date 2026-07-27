Write-Output 'File Version 1.03'

try {
	
	if ($Action -ieq 'Install')
	{

		## Enable Developer Mode
		$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
		# Create the key if it doesn't exist
		If (!(Test-Path $RegPath)) {
		    New-Item -Path $RegPath -Force | Out-Null
		}
		# Enable sideloading
		New-ItemProperty -Path $RegPath -Name "AllowDevelopmentWithoutDevLicense" -PropertyType DWord -Value 1 -Force | Out-Null
		Write-Output "Developer Mode has been enabled."

		## Cowork desktop requirements
		Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart
		
		## Release Information
		$DownloadURI = "https://claude.ai/api/desktop/win32/x64/msix/latest/redirect"
		Write-Output $DownloadURI

		## Download new application file
		$FilePath = Join-Path -Path (Get-Location).Path -ChildPath "Claude.msix"
		Write-Output $FilePath
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri $DownloadURI -Out $FilePath -UseBasicParsing

		## Install
		Write-Output 'Install'
		Add-AppxProvisionedPackage -Online -PackagePath "Claude.msix" -SkipLicense -Regions "all"

	}
	elseif ($Action -ieq 'Remove')
	{
		## Uninstall
		Install-PackageProvider -Name NuGet -Force | Out-Null
		Get-Package -Name "Claude" -ErrorAction SilentlyContinue | Uninstall-Package
	}

}
catch {

}
