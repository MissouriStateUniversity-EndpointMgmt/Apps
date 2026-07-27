Write-Output 'File Version 1.01'

try {
	
	if ($Action -ieq 'Install')
	{

		## Enable sideloading of trusted MSIX/AppX packages
		$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
		# Create the key if it doesn't exist
		If (!(Test-Path $RegPath)) {
		    New-Item -Path $RegPath -Force | Out-Null
		}
		# Enable sideloading
		New-ItemProperty -Path $RegPath -Name "AllowAllTrustedApps" -PropertyType DWord -Value 1 -Force | Out-Null
		Write-Output "Sideloading has been enabled."
		
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
