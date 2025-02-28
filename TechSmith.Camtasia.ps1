try {

 	if ($Action -ieq 'Install')
	{

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
