Write-Output 'File Version 1.00'

try {
	
	if ($Action -ieq 'Install')
	{
		## Release Information
		$DownloadURI = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
		Write-Output $DownloadURI

		# Download new application file
		$FilePath = Join-Path -Path (Get-Location).Path -ChildPath "googlechromestandaloneenterprise64.msi"
		Write-Output $FilePath
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri $DownloadURI -Out $FilePath -UseBasicParsing

		## Install Info
		$InstallArgs = "/i $FilePath /qn"

		# Install
		Write-Output 'Install'
		Start-Process msiexec.exe -Wait -Passthru -ArgumentList $InstallArgs
	}
	elseif ($Action -ieq 'Remove')
	{
		## Uninstall
		Install-PackageProvider -Name NuGet -Force | Out-Null
		Get-Package -Name "Google Chrome" -ErrorAction SilentlyContinue | Uninstall-Package
	}

}
catch {

}
