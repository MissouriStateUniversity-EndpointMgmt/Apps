Write-Output 'File Version 1.00'

function RemoveApp {
    ## Uninstall Info
    $UninstallName = "Foxit PDF Editor"
    $UninstallArgs = "/S"
    
    ## Uninstall MSI
    Install-PackageProvider -Name NuGet -Force | Out-Null
    Get-Package -Name $UninstallName -ErrorAction SilentlyContinue | Uninstall-Package
    
    ## Uninstall EXE
    (Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall","HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -ErrorAction SilentlyContinue) | Get-ItemProperty | Where-Object {$_.DisplayName -like $UninstallName} | Foreach { Start-Process $_.UninstallString -Wait -PassThru -ArgumentList $UninstallArgs }
}

try {

 	if ($Action -ieq 'Install')
	{
        # Remove Old Versions
        RemoveApp

        ## Release Information
        # $DownloadURI = "https://www.foxit.com/downloads/latest.html?product=Foxit-PDF-Editor-Suite-Pro-Teams&version=&platform=Windows&country=US&language=ML&package_type=zip"
        $DownloadURI = "https://cdn01.foxitsoftware.com/product/phantomPDF/desktop/win/2025.3.0/FoxitPDFEditor20253_L10N_Setup_Website_x64.zip"
        Write-Output $DownloadURI

        # Download new application file
		$FilePath = Join-Path -Path (Get-Location).Path -ChildPath "FoxitPDFEditor.zip"
		
        Write-Output $FilePath
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $DownloadURI -Out $FilePath -UseBasicParsing

        # Extract ZIP
		Expand-Archive $FilePath -DestinationPath (Get-Location).Path

		## Install Info
		$InstallFile = Resolve-Path "FoxitPDF*.msi"
		$UpdateFile = Resolve-Path "FoxitPDF*.msp"
		If ($UpdateFile -ne $null)
		{
			$InstallArgs = "/i $InstallFile /qn /update $UpdateFile"
		}
		Else
		{
			$InstallArgs = "/i $InstallFile /qn"
		}

        # Install
        Write-Output 'Install'
        Start-Process msiexec.exe -Wait -Passthru -ArgumentList $InstallArgs
 	}
	elseif ($Action -ieq 'Remove')
	{
		RemoveApp
 	}

}
catch {

}
