Write-Output 'File Version 1.00'

try {

 	if ($Action -ieq 'Install')
	{
  		## Release Information
        $FileNamePattern = "windowsdesktop-runtime-win-x64.exe"
        $ReleasesURL = "https://builds.dotnet.microsoft.com/dotnet/release-metadata/8.0/releases.json"
        $DownloadURI = ((Invoke-RestMethod -Method GET -Uri $ReleasesURL).releases[0].windowsdesktop.files | Where-Object name -eq $FileNamePattern).url
		Write-Output $DownloadURI


		# Download new application file
        $FilePath = Join-Path -Path (Get-Location).Path -ChildPath $(Split-Path -Path $DownloadURI -Leaf)
		Write-Output $FilePath
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri $DownloadURI -Out $FilePath -UseBasicParsing

  		## Install Info
		$InstallArgs = "/quiet"

		# Install
		Write-Output 'Install'
		Start-Process $FilePath -Wait -Passthru -ArgumentList $InstallArgs
	}
	elseif ($Action -ieq 'Remove')
	{
		## Uninstall
 	}

}
catch {

}
