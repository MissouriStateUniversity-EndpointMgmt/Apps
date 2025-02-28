try {

 	if ($Action -ieq 'Install')
	{

		$InstallArgs = "/i camtasia.msi TSC_SOFTWARE_KEY=$($ProductKey) TSC_SOFTWARE_USER=""Missouri State University"" TSC_UPDATE_ENABLE=0 /passive /norestart"

		# Download latest release
		$downloadUri = "https://download.techsmith.com/camtasiastudio/releases/camtasia.msi"
		$filePath = Join-Path -Path (Get-Location).Path -ChildPath "camtasia.msi"
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri $downloadUri -Out $filePath -UseBasicParsing
		
		# Install
		Start-Process msiexec.exe -Wait -PassThru -ArgumentList $installArgs

	}
	elseif ($Action -ieq 'Uninstall')
	{
		
		## Uninstall
		Install-PackageProvider -Name NuGet -Force | Out-Null
		Get-Package -Name "Camtasia 202*" -ErrorAction SilentlyContinue | Uninstall-Package

 	}

}
catch {

}
