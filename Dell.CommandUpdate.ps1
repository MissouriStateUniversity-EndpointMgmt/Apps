Write-Output 'File Version 2.00'

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
        $ReleasesURL = 'https://api.github.com/repos/microsoft/winget-pkgs/contents/manifests/d/Dell/CommandUpdate'
        $LatestVersion = (Invoke-RestMethod -UseBasicParsing -Method GET -Uri $ReleasesURL).name -match "^\d+(\.\d+){1,3}$" | Sort-Object -Descending | Select-Object -First 1
		Write-Output $LatestVersion
        $LatestURL = "https://raw.githubusercontent.com/microsoft/winget-pkgs/master/manifests/d/Dell/CommandUpdate/$LatestVersion/Dell.CommandUpdate.installer.yaml"
		Write-Output $LatestURL
		# Download and parse YAML content
		$yamlContent = Invoke-RestMethod -Uri $LatestURL -Headers @{ 'User-Agent' = 'PowerShell' }
		$DownloadURI = ($yamlContent -join "`n") -match "InstallerUrl:\s+(http.*)" | ForEach-Object { $Matches[1] }
		$InstallArgs = ($yamlContent -join "`n") -match "Silent:\s*(.+)" | ForEach-Object { $Matches[1] }
		Write-Output $DownloadURI
		Write-Output $InstallArgs

		# Download new application file
        $FilePath = Join-Path -Path (Get-Location).Path -ChildPath "DellCommandUpdate.exe"
        $ProgressPreference = 'SilentlyContinue'
        $userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
        Invoke-WebRequest -Uri $DownloadURI -Out $filePath -UserAgent $userAgent
        
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
