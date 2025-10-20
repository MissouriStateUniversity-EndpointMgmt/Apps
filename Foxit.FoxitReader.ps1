Write-Output 'File Version 1.01'

function RemoveApp {
    ## Uninstall Info
    $UninstallName = "Foxit PDF Reader"
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
        $DownloadURI = "https://www.foxit.com/downloads/latest.html?product=Foxit-Enterprise-Reader&version=&platform=Windows&language=English&package_type=zip"
        Write-Output $DownloadURI

        # Download new application file
		$FilePath = Join-Path -Path (Get-Location).Path -ChildPath "FoxitPDFReader.zip"
		
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
        	$InstallArgs = "/i $FilePath /qn DESKTOP_SHORTCUT=""0"" MAKEDEFAULT=""1"" VIEWINBROWSER=""1"" LAUNCHCHECKDEFAULT=""0"" AUTO_UPDATE=""2"" ADDLOCAL=""FX_PDFVIEWER"" /update $UpdateFile"
		}
		Else
		{
        	$InstallArgs = "/i $FilePath /qn DESKTOP_SHORTCUT=""0"" MAKEDEFAULT=""1"" VIEWINBROWSER=""1"" LAUNCHCHECKDEFAULT=""0"" AUTO_UPDATE=""2"" ADDLOCAL=""FX_PDFVIEWER"""
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
