Write-Output 'File Version 1.05'

$ReleasesURL = "https://downloads.arcgis.com/dms/rest/download/secured/ArcGISPro_36_197382.exe?f=json&folder=software/arcgispro/EXEs/3.6"

function RemoveApp {
    ## Uninstall Info
    $UninstallName = "ArcGIS Pro"
    
    ## Uninstall MSI
    Install-PackageProvider -Name NuGet -Force | Out-Null
    Get-Package -Name $UninstallName -ErrorAction SilentlyContinue | Uninstall-Package
}

try {

 	if ($Action -ieq 'Install')
	{
        # Remove Old Versions
        # RemoveApp

        ## Release Information
        $DownloadURI = (Invoke-RestMethod -UseBasicParsing -Method GET -Uri $ReleasesURL).url
        Write-Output $DownloadURI

        # Download new application file
		$FilePath = "C:\Windows\Temp\ArcGISPro.exe"
        Write-Output $FilePath
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $DownloadURI -Out $FilePath -UseBasicParsing

        # Install 7Zip module
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        Set-PSRepository -Name 'PSGallery' -SourceLocation "https://www.powershellgallery.com/api/v2" -InstallationPolicy Trusted
        Install-Module -Name 7Zip4PowerShell -Force
        
        # Extract 7Zip file
        Expand-7Zip -ArchiveFileName $FilePath -TargetPath "C:\Windows\Temp\"

        ## Install Info
		$InstallFile = "C:\Windows\Temp\ArcGISPro\ArcGISPro.msi"
		$UpdateFile = Resolve-Path "C:\Windows\Temp\ArcGISPro\ArcGIS_Pro_*.msp"
		If ($UpdateFile -ne $null)
		{
        	$InstallArgs = "/i $InstallFile /qb ALLUSERS=1 ACCEPTEULA=YES SOFTWARE_CLASS=Professional AUTHORIZATION_TYPE=NAMED_USER LOCK_AUTH_SETTINGS=FALSE LICENSE_URL=""https://missouristate.maps.arcgis.com"" /update $UpdateFile"
		}
		Else
		{
        	$InstallArgs = "/i $InstallFile /qb ALLUSERS=1 ACCEPTEULA=YES SOFTWARE_CLASS=Professional AUTHORIZATION_TYPE=NAMED_USER LOCK_AUTH_SETTINGS=FALSE LICENSE_URL=""https://missouristate.maps.arcgis.com"""
		}

        # Install
        Write-Output 'Install'
		Write-Output $InstallArgs
        Start-Process msiexec.exe -Wait -Passthru -ArgumentList $InstallArgs
		Remove-Item $FilePath -Force
		Remove-Item C:\Windows\Temp\ArcGISPro -Recurse -Force
 	}
	elseif ($Action -ieq 'Remove')
	{
		RemoveApp
 	}

}
catch {

}
