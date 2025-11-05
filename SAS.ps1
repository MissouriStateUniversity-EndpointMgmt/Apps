
Write-Output 'File Version 1.09'

$LicenseFile = "SAS94_9D29YD_70085677_Win_X64_Wrkstn.txt"

try {

 	if ($Action -ieq 'Install')
	{
        # Download License File
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/MissouriStateUniversity-EndpointMgmt/MCM/refs/heads/main/$LicenseFile" -Method Get -Headers @{Authorization = "token $AccessToken"} -OutFile C:\Windows\Temp\$LicenseFile
		$SIDfile = Resolve-Path "C:\Windows\Temp\$LicenseFile"
		
		if ($SIDfile -ne $null)
		{
			# Replace text in sdwresponse.properties with the path to the license file
			$SIDreplace = " SAS_INSTALLATION_DATA=" + $SIDfile
			$ResponseProp = "C:\Windows\Temp\sdwresponse.properties"
			((Get-Content -path sdwresponse.properties -Raw) -replace ' SAS_INSTALLATION_DATA=SID_FILE',$SIDreplace) | Set-Content -Path $ResponseProp

			# Install
			$InstallFile = Join-Path -Path (Get-Location).Path -ChildPath "setup.exe"
			$InstallArgs = "-wait -partialprompt -lang en -responsefile " + $ResponseProp
			Start-Process -FilePath $InstallFile -ArgumentList $InstallArgs -Wait -NoNewWindow

			$RenewUtil = "C:\Program Files\SASHome\SASRenewalUtility\9.4\SASRenew.exe"
			$RenewArgs = "-s `"datafile:$SIDfile`""
	
			if (Test-Path $RenewUtil) {
				# Program might not licnese during install so need to run SASRenew to license
				# Enable NetFx3 (required for SASRenew?)
				# Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -All
				# Renew license program
				Start-Process -FilePath $RenewUtil -ArgumentList $RenewArgs -Wait -NoNewWindow
			}

		}

	}
    elseif ($Action -ieq 'Remove')
    {
        ## Uninstall
		$UninstallFile = "C:\Program Files\SASHome\SASDeploymentManager\9.4\sasdm.exe"
		$UninstallArgs = "-quiet -wait -uninstallall"
		Start-Process -FilePath $UninstallFile -ArgumentList $UninstallArgs -Wait -NoNewWindow
    }

}
catch {

}
