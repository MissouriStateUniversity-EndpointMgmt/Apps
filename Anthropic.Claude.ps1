Write-Output 'File Version 1.00'

try {
	
	if ($Action -ieq 'Install')
	{
		## Release Information
		$DownloadURI = "https://claude.ai/api/desktop/win32/x64/msix/latest/redirect"
		Write-Output $DownloadURI

		# Download new application file
		$FilePath = Join-Path -Path (Get-Location).Path -ChildPath "Claude.msix"
		Write-Output $FilePath
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri $DownloadURI -Out $FilePath -UseBasicParsing

		# Install
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
