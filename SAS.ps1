
Write-Output 'File Version 1.06'

$LicenseFile = "SAS94_9D29YD_70085677_Win_X64_Wrkstn.txt"

try {

 	if ($Action -ieq 'Install')
	{
        # Download License File
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/MissouriStateUniversity-EndpointMgmt/MCM/refs/heads/main/$LicenseFile" -Method Get -Headers @{Authorization = "token $AccessToken"} -OutFile C:\Windows\Temp\$LicenseFile
		$SIDfile = Resolve-Path "C:\Windows\Temp\$LicenseFile"
		
		if ($SIDfile -ne $null)
		{
			$SIDreplace = " SAS_INSTALLATION_DATA=" + $SIDfile
			$ResponseProp = "C:\Windows\Temp\sdwresponse.properties"
			$InstallArgs = "-wait -quiet -lang en -responsefile " + $ResponseProp
		
			$InstallPath = "C:\Program Files\SASHome\"
			$UninstallProp = "uninstall.properties"
			$RenewVar = $InstallPath + "SASRenewalUtility\9.4\SASRenew.exe"
			$RenewArgs = "-s `"datafile:$SIDfile`""

			# Replace text in sdwresponse.properties with the path to the license file
			((Get-Content -path sdwresponse.properties -Raw) -replace ' SAS_INSTALLATION_DATA=SID_FILE',$SIDreplace) | Set-Content -Path $ResponseProp
			# Install
			$FilePath = Join-Path -Path (Get-Location).Path -ChildPath "setup.exe"
			Start-Process -FilePath $FilePath -ArgumentList $InstallArgs -Wait -NoNewWindow
	
			if (Test-Path $InstallPath) {
				# Copy uninstall file
				Copy-Item $UninstallProp -Destination $InstallPath
				# Program might not licnese during install so need to run SASRenew to license
				# Enable NetFx3 (required for SASRenew?)
				Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -All
				# Renew license program
				Invoke-Command -ScriptBlock { Start-Process -FilePath $RenewVar -ArgumentList $RenewArgs -Wait }
			}

		}

	}
    elseif ($Action -ieq 'Remove')
    {
        ## Uninstall

    }

}
catch {

}
