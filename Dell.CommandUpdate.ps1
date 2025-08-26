Write-Output 'File Version 1.00'

function RemoveApp {
    ## Uninstall MSI
    Install-PackageProvider -Name NuGet -Force | Out-Null
    Get-Package -Name "Dell Command | Update for Windows Universal" -ErrorAction SilentlyContinue | Uninstall-Package
    Get-Package -Name "Dell Command | Update" -ErrorAction SilentlyContinue | Uninstall-Package
}

try {

 	if ($Action -ieq 'Install')
	{
        ## Release Information from GitHub winget-pkgs
        Install-Module -Name powershell-yaml -Force -Repository PSGallery -Scope CurrentUser
        $ReleasesURL = 'https://api.github.com/repos/microsoft/winget-pkgs/contents/manifests/d/Dell/CommandUpdate'
        $LatestVersion = (Invoke-RestMethod -UseBasicParsing -Method GET -Uri $ReleasesURL).name -match "^\d+(\.\d+){1,3}$" | Sort-Object -Descending | Select-Object -First 1
        $LatestURL = "https://raw.githubusercontent.com/microsoft/winget-pkgs/master/manifests/d/Dell/CommandUpdate/$LatestVersion/Dell.CommandUpdate.installer.yaml"
        $Info = ((Invoke-RestMethod -UseBasicParsing -Method GET -Uri $LatestURL) | ConvertFrom-Yaml)
        $DownloadURL = $Info.Installers.InstallerUrl
        $InstallArgs = $Info.InstallerSwitches.Silent
		Write-Output $DownloadURI
		Write-Output $InstallArgs

		# Download new application file
		$FilePath = Join-Path -Path (Get-Location).Path -ChildPath $(Split-Path -Path $DownloadURI -Leaf)
		Write-Output $FilePath
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri $DownloadURI -Out $FilePath -UseBasicParsing
        
		# Remove Old Versions
		RemoveApp

		# Install
   		Write-Output 'Install'
		Start-Process $FilePath -Wait -Passthru -ArgumentList $InstallArgs
	}
	elseif ($Action -ieq 'Remove')
	{
		## Uninstall
		RemoveApp
 	}

}
catch {

}
