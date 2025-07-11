Write-Output 'File Version 1.00'

try {

 	if ($Action -ieq 'Install')
	{
        ## Release Information
        $DownloadURI = "https://download.mozilla.org/?product=firefox-esr-msi-latest-ssl&os=win64&lang=en-US"
        Write-Output $DownloadURI
        $InstallFile = (Invoke-WebRequest -Method Head -Uri $DownloadURI -UseBasicParsing -ErrorAction SilentlyContinue).BaseResponse.ResponseUri.Segments[-1].Replace('%20','')

        # Download new application file
        $FilePath = Join-Path -Path (Get-Location).Path -ChildPath $InstallFile
        Write-Output $FilePath
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $DownloadURI -Out $FilePath -UseBasicParsing

        ## Install Info
        $InstallArgs = "/i $FilePath /qn DESKTOP_SHORTCUT=false"
        
        # Install
        Write-Output 'Install'
        Start-Process msiexec.exe -Wait -Passthru -ArgumentList $InstallArgs
 	}
    elseif ($Action -ieq 'Remove')
    {
        ## Uninstall
        Install-PackageProvider -Name NuGet -Force | Out-Null
        Get-Package -Name "Mozilla Firefox ESR*" -ErrorAction SilentlyContinue | Uninstall-Package
    }

}
catch {

}
