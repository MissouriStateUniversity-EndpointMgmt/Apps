Write-Output 'File Version 1.00'

$DownloadURI = "https://cdn01.foxitsoftware.com/product/phantomPDF/desktop/win/2025.3.0/FoxitPDFEditor20253_L10N_Setup_Website_x64.zip"
$TempPath = "C:\Windows\Temp\FoxitPDFEditor"

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
        Write-Output $DownloadURI

        # Create Temp Folder
		New-Item -Path $TempPath -ItemType Directory -ErrorAction SilentlyContinue

        # Download new application file
		$FilePath = "$TempPath\FoxitPDFEditor.zip"
        Write-Output $FilePath
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $DownloadURI -Out $FilePath -UseBasicParsing

        # Extract ZIP
		Expand-Archive $FilePath -DestinationPath $TempPath

		## Install Info
		$InstallFile = Resolve-Path "$TempPath\FoxitPDF*.msi"
		$UpdateFile = Resolve-Path "$TempPath\FoxitPDF*.msp"
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
		Remove-Item $TempPath -Recurse -Force
 	}
	elseif ($Action -ieq 'Remove')
	{
		RemoveApp
 	}

}
catch {

}
