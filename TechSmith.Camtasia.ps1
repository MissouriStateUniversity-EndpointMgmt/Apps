Write-Output 'File Version 1.00'

try {

 	if ($Action -ieq 'Install')
	{
		## Update Key 
		$ProductKey = "HHCKM-QX5Z4-MLCAJ-YEDDJ-B6CEM"
  
  		## Release Information
		$DownloadURI = "https://download.techsmith.com/camtasiastudio/releases/camtasia.msi"
		Write-Output $DownloadURI

		# Download new application file
		$FilePath = Join-Path -Path (Get-Location).Path -ChildPath "camtasia.msi"
		Write-Output $FilePath
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri $DownloadURI -Out $FilePath -UseBasicParsing

  		## Install Info
		$InstallArgs = "/i camtasia.msi TSC_SOFTWARE_KEY=$($ProductKey) TSC_SOFTWARE_USER=""Missouri State University"" TSC_UPDATE_ENABLE=0 /passive /norestart"

		# Install
		Write-Output 'Install'
		Start-Process msiexec.exe -Wait -PassThru -ArgumentList $installArgs
	}
	elseif ($Action -ieq 'Remove')
	{
		## Uninstall
		Install-PackageProvider -Name NuGet -Force | Out-Null
		Get-Package -Name "Camtasia 202*" -ErrorAction SilentlyContinue | Uninstall-Package
 	}

}
catch {

}
