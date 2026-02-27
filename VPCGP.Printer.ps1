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
        "BRICK-1" {
			$PrinterDetails.PortName = "brickworkroom"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO"
			$PrinterDetails.PrinterLocation = "Efactory Room 1024"
		}
		"EFAC-BLUE" {
			$PrinterDetails.PortName = "pctrmailroom"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO"
			$PrinterDetails.PrinterLocation = "PCTR 1048 Workroom"
		}
		"EFAC-GREEN" {
			$PrinterDetails.PortName = "efactory-green"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO"
			$PrinterDetails.PrinterLocation = "PCTR 1041"
		}
        "EFAC-MAROON" {
			$PrinterDetails.PortName = "pctrcoworking"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO"
			$PrinterDetails.PrinterLocation = "Efactory Room 1024"
		}
		"ELI-BLUE" {
			$PrinterDetails.PortName = "mfp15970244"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO"
			$PrinterDetails.PrinterLocation = "JDMC 0228"
		}
		"ELI-ORANGE" {
			$PrinterDetails.PortName = "mfp07583774"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO"
			$PrinterDetails.PrinterLocation = "JDMC 0418"
		}
		"FLI-RED" {
			$PrinterDetails.PortName = "mfp11340514"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO"
			$PrinterDetails.PrinterLocation = "JDMC 0412"
		}
		"GST-RED" {
			$PrinterDetails.PortName = "mfp07666656"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO"
			$PrinterDetails.PrinterLocation = "CARR 0306"
		}
		"IS-BLUE" {
			$PrinterDetails.PortName = "mfp13394669"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO"
			$PrinterDetails.PrinterLocation = "JDMC 0116"
		}
		"IS-RED" {
			$PrinterDetails.PortName = "mfp12096893"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO"
			$PrinterDetails.PrinterLocation = "JDMC 0101 FrontDesk"
		}
		"OEA-RED" {
			$PrinterDetails.PortName = "mfp11673737"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO"
			$PrinterDetails.PrinterLocation = "PLSU 0209"
		}
		"OIP-ORANGE" {
			$PrinterDetails.PortName = "mfp15799479"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO"
			$PrinterDetails.PrinterLocation = "JDMC 0507 Workroom"
		}
  
 		# HP
		"EFAC-ORANGE" {
			$PrinterDetails.PortName = "efac-orange"
			$PrinterDetails.PrinterComment = "HP Color LaserJet M553"
			$PrinterDetails.PrinterLocation = "PCTR 1048 Workroom"
		}
  
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
