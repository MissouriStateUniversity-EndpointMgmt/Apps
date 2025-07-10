function RemoveApp {
 	## Uninstall Info
  	$UninstallString = "C:\Program Files\7-Zip\Uninstall.exe"
	$UninstallArgs = "/S"

 	# Uninstall
	Write-Output 'Uninstall'
 	if ($UninstallString) {	Start-Process $UninstallString -Wait -PassThru -ArgumentList $UninstallArgs }
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

		# Download new application file
		Write-Output $DownloadURI
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
