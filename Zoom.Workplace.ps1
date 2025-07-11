Write-Output 'File Version 1.00'

try {

 	if ($Action -ieq 'Install')
	{
        ## Release Information
		$DownloadURI = "https://zoom.us/client/latest/ZoomInstallerFull.msi?archType=x64"
        Write-Output $DownloadURI

        # Download new application file
		$FilePath = Join-Path -Path (Get-Location).Path -ChildPath "ZoomInstallerFull.msi"
        Write-Output $FilePath
		$ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $DownloadURI -Out $FilePath -UseBasicParsing

        ## Install Info
		$installArgs = "/i $FilePath /qn /norestart MSIRestartManagerControl=Disable ZSSOHOST=""missouristate"" ZoomAutoUpdate=1 ZConfig=""kCmdParam_InstallOption=8;EnableEmbedBrowserForSSO=1"" ZRecommend=""AudioAutoAdjust=1"""
		
		# Install
        Write-Output 'Install'
        Start-Process msiexec.exe -Wait -Passthru -ArgumentList $InstallArgs
	}
	elseif ($Action -ieq 'Remove')
	{
		## Uninstall
		Install-PackageProvider -Name NuGet -Force | Out-Null
		Get-Package -Name "Zoom*(64-bit)" -ErrorAction SilentlyContinue | Uninstall-Package
 	}

}
catch {

}
