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
		"CNAS-BLACK" {
			$PrinterDetails.PortName = "mfp14346783"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO4528A"
			$PrinterDetails.PrinterLocation = "SCNC 142F"
		}
		"SEES-BLACK" {
			$PrinterDetails.PortName = "sees-black"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO4525AC"
			$PrinterDetails.PrinterLocation = "SCNC 342"
		}
		"CRPM-BLACK" {
			$PrinterDetails.PortName = "crpm-black"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO4505AC"
			$PrinterDetails.PrinterLocation = "SCNC 1XX"
		}
		"CSC-BLACK" {
			$PrinterDetails.PortName = "csc-black"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO4508A"
			$PrinterDetails.PrinterLocation = "CHEK 203A"
		}
		"MTH-BLACK" {
			$PrinterDetails.PortName = "mth-black"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO6508A"
			$PrinterDetails.PrinterLocation = "CHEK 16M"
		}
		"MTH-BLUE" {
			$PrinterDetails.PortName = "mth-blue"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO6518A"
			$PrinterDetails.PrinterLocation = "CHEK 43M"
		}
 		# HP
		"CNAS-BLUE" {
			$PrinterDetails.PortName = "cnas-blue"
			$PrinterDetails.PrinterComment = "HP LaserJet 400 color M451dn"
			$PrinterDetails.PrinterLocation = "SCNC 170"
		}
		"BIO-RED" {
			$PrinterDetails.PortName = "npiadcc2d"
			$PrinterDetails.PrinterComment = "HP LaserJet 4100"
			$PrinterDetails.PrinterLocation = "SCNC 272B"
		}
		"MTH-YELLOW" {
			$PrinterDetails.PortName = "mth-yellow"
			$PrinterDetails.PrinterComment = "HP Color LaserJet M402dn"
			$PrinterDetails.PrinterLocation = "CHEK 305"
		}
		"MTH-RED" {
			$PrinterDetails.PortName = "mth-red"
			$PrinterDetails.PrinterComment = "HP LaserJet 400 M401dne"
			$PrinterDetails.PrinterLocation = "CHEK 43M"
		}
		"MTH-ORANGE" {
			$PrinterDetails.PortName = "mth-orange"
			$PrinterDetails.PrinterComment = "HP Color LaserJet M402dne"
			$PrinterDetails.PrinterLocation = "CHEK 001"
		}
		"MTH-GREEN" {
			$PrinterDetails.PortName = "mth-green"
			$PrinterDetails.PrinterComment = "HP Color LaserJet CP3525"
			$PrinterDetails.PrinterLocation = "CHEK 10M"
		}
		"GGP-YELLOW" {
			$PrinterDetails.PortName = "npi9ee684"
			$PrinterDetails.PrinterComment = "HP Color LaserJet CP4005"
			$PrinterDetails.PrinterLocation = "SCNC 354"
		}
		"GGP-RED" {
			$PrinterDetails.PortName = "npi82eb61"
			$PrinterDetails.PrinterComment = "HP Color LaserJet CP4005"
			$PrinterDetails.PrinterLocation = "SCNC 342"
		}
		"GGP-ORANGE" {
			$PrinterDetails.PortName = "npi1f1d44"
			$PrinterDetails.PrinterComment = "HP LaserJet P4515"
			$PrinterDetails.PrinterLocation = "SCNC 311"
		}
		"CHM-GREEN" {
			$PrinterDetails.PortName = "chm-green"
			$PrinterDetails.PrinterComment = "HP Color LaserJet M553"
			$PrinterDetails.PrinterLocation = "SCNC 449A"
		}
		"CHM-BROWN" {
			$PrinterDetails.PortName = "chm-brown"
			$PrinterDetails.PrinterComment = "HP LaserJet P2055dn"
			$PrinterDetails.PrinterLocation = "KEMP 119D"
		}
		"CHM-RED" {
			$PrinterDetails.PortName = "npi23e8fb"
			$PrinterDetails.PrinterComment = "HP LaserJet P3005"
			$PrinterDetails.PrinterLocation = "SCNC 403"
		}
		"CRPM-RED" {
			$PrinterDetails.PortName = "crpm-red"
			$PrinterDetails.PrinterComment = "HP LaserJet 400 M401dne"
			$PrinterDetails.PrinterLocation = "LEVY 100"
		}
		"OEWRI-YELLOW" {
			$PrinterDetails.PortName = "npi03f1a0"
			$PrinterDetails.PrinterComment = "HP LaserJet Pro M201dw"
			$PrinterDetails.PrinterLocation = "SCNC 125"
		}
  		# BROTHER
		"MTH-GREEN" {
			$PrinterDetails.PortName = "mth-green"
			$PrinterDetails.PrinterComment = "Brother HL-L8360CDW"
			$PrinterDetails.PrinterLocation = "CHEK 10M"
			$PrinterDetails.DriverName = "Brother HL-L8360CDW series"
		}
 		# XEROX
  		"CRPM-GREEN" {
			$PrinterDetails.PortName = "crpm-green"
			$PrinterDetails.PrinterComment = "Xerox VersaLink C7000"
			$PrinterDetails.PrinterLocation = "SCNC"
		}
  		# DELL
 		# CANON
 	}
	return $PrinterDetails
}

$INFPath = "$PSScriptRoot\drivers\$INFFile"
Write-Output $INFPath
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

		#Add driver to driver store
		Write-Output "Adding Driver to Windows DriverStore using INF ""$($INFPath)"""
  		Start-Process -FilePath "C:\Windows\SysNative\pnputil.exe" -ArgumentList $INFARGS -Wait -NoNewWindow

		#Install driver
		$DriverExist = Get-Printerport -Name $DriverName -ErrorAction SilentlyContinue
		if (-not $DriverExist) {
			Write-Output "Adding Printer Driver ""$($DriverName)"""
			Add-PrinterDriver -Name $DriverName -Confirm:$false
		}
		else {
			Write-Output "Print Driver ""$($DriverName)"" already exists. Skipping driver installation."
		}

		#Create Printer Port
		$PortExist = Get-Printerport -Name $PrinterData.PortName -ErrorAction SilentlyContinue
		if (-not $PortExist) {
			Write-Output "Adding Port ""$($PrinterData.PortName)"""
			Add-PrinterPort -name $PrinterData.PortName -PrinterHostAddress $PrinterData.PortName -Confirm:$false
		}
		else {
			Write-Output "Port ""$($PrinterData.PortName)"" already exists. Skipping Printer Port installation."
		}

		#Add Printer
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
