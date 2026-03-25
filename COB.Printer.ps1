# Contributions
# https://github.com/byteben/Windows-10/blob/master/Install-Printer.ps1
# https://call4cloud.nl/deploy-printer-drivers-intune-win32app/

function Get-PrinterData {
	param (
		[Parameter(Mandatory = $True)]
		[String]$PrinterName
	)
	$PrinterDetails = [PSCustomObject]@{
		PortName = $null
		PrinterComment = $null
		PrinterLocation = $null
	}
	switch ($PrinterName) {
 		# TOSHIBA
        "COB-BLACK" {
			$PrinterDetails.PortName = "MFP14113658"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO7516AC"
			$PrinterDetails.PrinterLocation = ""
		}
  
 		# HP
  
  	}
	return $PrinterDetails
}

$INFARGS = @(
	"/install"
	"/add-driver"
	$INFPath
)

$PrinterData = Get-PrinterData $PrinterName

if ($PrinterData.PortName -ne $null) {

	try {
		# Check if Print Spooler is running
		Get-Service Spooler | Where {$_.status -eq 'Stopped'} | Start-Service -Verbose

		# Delete old printer connections
		Get-WmiObject -Class Win32_Printer | where{$_.Name -eq $PrinterName } | foreach{$_.delete()}

		# Add driver to driver store
		Write-Output "Adding Driver to Windows DriverStore using INF ""$($INFPath)"""
  
		# Check if running as a 32-bit process on a 64-bit client
		if (Test-Path "C:\Windows\SysNative\pnputil.exe") {
  			Write-Output "The script is running as a 32-bit process on a 64-bit client."
	 		Start-Process -FilePath "C:\Windows\SysNative\pnputil.exe" -ArgumentList $INFARGS -Wait -NoNewWindow
		}
		else {
  			Write-Output "The script is running as a native process."
	  		Start-Process pnputil.exe -ArgumentList $INFARGS -Wait -NoNewWindow
		}

    		# Install driver
		$DriverExist = Get-Printerport -Name $DriverName -ErrorAction SilentlyContinue
		if (-not $DriverExist) {
			Write-Output "Adding Printer Driver ""$($DriverName)"""
			Add-PrinterDriver -Name $DriverName -Confirm:$false
		}
		else {
			Write-Output "Print Driver ""$($DriverName)"" already exists. Skipping driver installation."
		}

		# Create Printer Port
		$PortExist = Get-Printerport -Name $PrinterData.PortName -ErrorAction SilentlyContinue
		if (-not $PortExist) {
			Write-Output "Adding Port ""$($PrinterData.PortName)"""
			Add-PrinterPort -name $PrinterData.PortName -PrinterHostAddress $PrinterData.PortName -Confirm:$false
		}
		else {
			Write-Output "Port ""$($PrinterData.PortName)"" already exists. Skipping Printer Port installation."
		}

		# Add Printer
		$PrinterExist = Get-Printer -Name $PrinterName -ErrorAction SilentlyContinue
		if (-not $PrinterExist) {
			Write-Output "Adding Printer ""$($PrinterName)"""
			Add-Printer -Name $PrinterName -DriverName $DriverName -PortName $PrinterData.PortName -Comment $PrinterData.PrinterComment -Location $PrinterData.PrinterLocation -Confirm:$false
		}
		else {
			Write-Output "Printer ""$($PrinterName)"" already exists. Removing old printer..."
			Remove-Printer -Name $PrinterName -Confirm:$false
			Write-Output "Adding Printer ""$($PrinterName)"""
			Add-Printer -Name $PrinterName -DriverName $DriverName -PortName $PrinterData.PortName -Comment $PrinterData.PrinterComment -Location $PrinterData.PrinterLocation -Confirm:$false
		}
	}
	catch {
		Write-Warning "`nError during installation.."
		$err = $_.Exception.Message
		Write-Error $err
	}

}
else {
	Write-Output "Printer information not found."
}
