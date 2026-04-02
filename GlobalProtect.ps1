Write-Output 'File Version 1.00'

try {

 	if ($Action -ieq 'Install')
	{
        ## Release Information
		$DownloadURI = "https://remote.missouristate.edu/global-protect/getmsi.esp?version=64&platform=windows"
        Write-Output $DownloadURI

        # Download new application file
		$FilePath = Join-Path -Path (Get-Location).Path -ChildPath "GlobalProtect64.msi"
        Write-Output $FilePath
		$ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $DownloadURI -Out $FilePath -UseBasicParsing

        ## Install Info
		$installArgs = "/i $FilePath /qn"
		
		# Install
        Write-Output 'Install'
        Start-Process msiexec.exe -Wait -Passthru -ArgumentList $InstallArgs
	}
	elseif ($Action -ieq 'Remove')
	{
		## Uninstall
		Install-PackageProvider -Name NuGet -Force | Out-Null
		Get-Package -Name "GlobalProtect" -ErrorAction SilentlyContinue | Uninstall-Package
 	}

}
catch {

}
