
Write-Output 'File Version 1.00'

$LicenseFile = "SAS94_9D29YD_70085677_Win_X64_Wrkstn.txt"

try {

 	if ($Action -ieq 'Install')
	{
        # Download License File
        Invoke-WebRequest -Uri "https://api.github.com/repos/MissouriStateUniversity-EndpointMgmt/MCM/contents/$LicenseFile" -Headers @{Authorization = "token $AccessToken"} -OutFile $LicenseFile

 	}
    elseif ($Action -ieq 'Remove')
    {
        ## Uninstall

    }

}
catch {

}
