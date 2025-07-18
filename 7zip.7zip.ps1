Write-Output 'File Version 1.12'

function RemoveApp {
	## Uninstall Info
	$UninstallName = "7-Zip*"
	$UninstallArgs = "/S"
	$ProgramFilePath = "7-Zip\Uninstall.exe"

 	## Uninstall MSI
	Install-PackageProvider -Name NuGet -Force | Out-Null
	Get-Package -Name $UninstallName -ErrorAction SilentlyContinue | Uninstall-Package

 	## Uninstall EXE
	(Get-Item -Path "C:\Program Files\$ProgramFilePath","C:\Program Files (x86)\$ProgramFilePath" -ErrorAction SilentlyContinue) | ForEach-Object { Start-Process $_.FullName -Wait -PassThru -ArgumentList $UninstallArgs }
}

try {

 	if ($Action -ieq 'Install')
	{
		## Install Info
		$InstallArgs = "/S"
  
		## GitHub Information
		$repo = "ip7z/7zip"
		$FileNamePattern = "*x64.exe"
		$ReleasesURL = "https://api.github.com/repos/$repo/releases/latest"
		$DownloadURI = ((Invoke-RestMethod -Method GET -Uri $ReleasesURL).assets | Where-Object name -like $FileNamePattern).browser_download_url
		Write-Output $DownloadURI

		# Download new application file
		$FilePath = Join-Path -Path (Get-Location).Path -ChildPath $(Split-Path -Path $DownloadURI -Leaf)
		Write-Output $FilePath
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri $DownloadURI -Out $FilePath -UseBasicParsing

		# Remove Old Versions
		RemoveApp

		# Install
   		Write-Output 'Install'
		Start-Process $FilePath -Wait -Passthru -ArgumentList $InstallArgs
 	}
	elseif ($Action -ieq 'Remove')
	{
		RemoveApp
 	}

}
catch {

}
