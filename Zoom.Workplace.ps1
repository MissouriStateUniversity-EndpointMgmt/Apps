try {

 	if ($Action -ieq 'Install')
	{

		# Variables
		$installArgs = "/i ZoomInstallerFull.msi /qn /norestart MSIRestartManagerControl=Disable ZSSOHOST=""missouristate"" ZoomAutoUpdate=1 ZConfig=""kCmdParam_InstallOption=8;EnableEmbedBrowserForSSO=1"" ZRecommend=""AudioAutoAdjust=1"""

		# Download latest release
		$downloadUri = "https://zoom.us/client/latest/ZoomInstallerFull.msi?archType=x64"
		$filePath = Join-Path -Path (Get-Location).Path -ChildPath "ZoomInstallerFull.msi"
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri $downloadUri -Out $filePath -UseBasicParsing
		
		# Install
		Start-Process msiexec.exe -Wait -PassThru -ArgumentList $installArgs

	}
	elseif ($Action -ieq 'Uninstall')
	{
		
		## Uninstall Zoom
		Install-PackageProvider -Name NuGet -Force | Out-Null
		Get-Package -Name "Zoom*(64-bit)" -ErrorAction SilentlyContinue | Uninstall-Package

 	}

}
catch {

}
