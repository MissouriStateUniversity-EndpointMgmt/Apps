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
			$PrinterDetails.PrinterLocation = "SCNC 110F"
		}
		"BIO-BLACK" {
			$PrinterDetails.PortName = "bio-black"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO5508A"
			$PrinterDetails.PrinterLocation = "SCNC 244"
		}
		"BIO-BLUE" {
			$PrinterDetails.PortName = "bio-blue"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO5518A"
			$PrinterDetails.PrinterLocation = "SCNC 210A"
		}
  		"SEES-BLACK" {
			$PrinterDetails.PortName = "sees-black"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO4525AC"
			$PrinterDetails.PrinterLocation = "SCNC 310"
		}
    	"CHM-BLACK" {
			$PrinterDetails.PortName = "mfp14263477"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO6528A"
			$PrinterDetails.PrinterLocation = "SCNC 410"
		}
		"CRPM-BLACK" {
			$PrinterDetails.PortName = "crpm-black"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO4505AC"
			$PrinterDetails.PrinterLocation = "SCNC 122C"
		}
		"CSC-BLACK" {
			$PrinterDetails.PortName = "csc-black"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO4508A"
			$PrinterDetails.PrinterLocation = "CHEK 203A"
		}
		"MTH-BLACK" {
			$PrinterDetails.PortName = "mth-black"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO6508A"
			$PrinterDetails.PrinterLocation = "UNVH 212"
		}
		"MTH-BLUE" {
			$PrinterDetails.PortName = "mth-blue"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO6518A"
			$PrinterDetails.PrinterLocation = "UNVH 006"
		}
  		"EGR-RED" {
			$PrinterDetails.PortName = "mfp14226282"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO5518A"
			$PrinterDetails.PrinterLocation = "PCTR 2004A"
		}
		"EGR-GREEN" {
			$PrinterDetails.PortName = "mfp15810788"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO2525AC"
			$PrinterDetails.PrinterLocation = "PCTR 2001"
		}
		"PHY-YELLOW" {
			$PrinterDetails.PortName = "MFP12015819"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO5508A"
			$PrinterDetails.PrinterLocation = "KEMP 101"
		}
  
 		# HP
		"CNAS-BLUE" {
			$PrinterDetails.PortName = "cnas-blue"
			$PrinterDetails.PrinterComment = "HP LaserJet 400 color M451dn"
			$PrinterDetails.PrinterLocation = "SCNC 107"
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
			$PrinterDetails.PrinterLocation = "UNVH 006"
		}
		"MTH-ORANGE" {
			$PrinterDetails.PortName = "mth-orange"
			$PrinterDetails.PrinterComment = "HP Color LaserJet M402dne"
			$PrinterDetails.PrinterLocation = "CHEK 001"
		}
		"SEES-YELLOW" {
			$PrinterDetails.PortName = "sees-yellow"
			$PrinterDetails.PrinterComment = "HP Color LaserJet CP4005"
			$PrinterDetails.PrinterLocation = "SCNC 310"
		}
		"SEES-RED" {
			$PrinterDetails.PortName = "sees-red"
			$PrinterDetails.PrinterComment = "HP Color LaserJet CP4005"
			$PrinterDetails.PrinterLocation = "SCNC 318"
		}
		"SEES-INDIGO" {
			$PrinterDetails.PortName = "sees-indigo"
			$PrinterDetails.PrinterComment = "HP LaserJet Pro M201dw"
			$PrinterDetails.PrinterLocation = "SCNC 306"
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
		"CHM-TAN" {
			$PrinterDetails.PortName = "npi6c137e"
			$PrinterDetails.PrinterComment = "HP LaserJet 400 M401n"
			$PrinterDetails.PrinterLocation = "TEMP 431"
		}
		"OEWRI-GREEN" {
			$PrinterDetails.PortName = "oewri-green"
			$PrinterDetails.PrinterComment = "HP LaserJet 200 Color M251nw"
			$PrinterDetails.PrinterLocation = "SCNC 305"
		}
		"EGR-YELLOW" {
			$PrinterDetails.PortName = "npi08be86"
			$PrinterDetails.PrinterComment = "HP Color LaserJet M254dw"
			$PrinterDetails.PrinterLocation = "PCTR 2032"
		}
  
  		# BROTHER
    		"MTH-GREEN" {
			$PrinterDetails.PortName = "mth-green"
			$PrinterDetails.PrinterComment = "Brother HL-L8360CDW"
			$PrinterDetails.PrinterLocation = "UNVH 212"
		}
  
 		# XEROX
		"CRPM-GREEN" {
			$PrinterDetails.PortName = "crpm-green"
			$PrinterDetails.PrinterComment = "Xerox VersaLink C7000"
			$PrinterDetails.PrinterLocation = "SCNC 122C"
		}
    	"CHM-WHITE" {
			$PrinterDetails.PortName = "xc-a572ad"
			$PrinterDetails.PrinterComment = "Xerox VersaLink C405"
			$PrinterDetails.PrinterLocation = "SCNC 410D"
		}
    	"PHY-RED" {
			$PrinterDetails.PortName = "xc-d32bd8"
			$PrinterDetails.PrinterComment = "Xerox WorkCentre 6515"
			$PrinterDetails.PrinterLocation = "KEMP 101"
		}
  
 		# LEXMARK
  		"BIO-GREEN" {
			$PrinterDetails.PortName = "bio-green"
			$PrinterDetails.PrinterComment = "Lexmark MC2535adwe"
			$PrinterDetails.PrinterLocation = "SCNC 108"
		}
  		"PHY-GREEN" {
			$PrinterDetails.PortName = "phy-green"
			$PrinterDetails.PrinterComment = "Lexmark MS421dn"
			$PrinterDetails.PrinterLocation = "KEMP 226A"
		}
  
  		# DELL
  		"CSC-ORANGE" {
			$PrinterDetails.PortName = "csc-orange"
			$PrinterDetails.PrinterComment = "Dell Color Printer S3840cdn"
			$PrinterDetails.PrinterLocation = "CHEK 203A"
		}
  		"CNAS-RED" {
			$PrinterDetails.PortName = "cnas-red"
			$PrinterDetails.PrinterComment = "Dell C2660dn Color Laser"
			$PrinterDetails.PrinterLocation = "SCNC 110B"
		}
  		"OEWRI-RED" {
			$PrinterDetails.PortName = "oewri-red"
			$PrinterDetails.PrinterComment = "Dell C2660dn Color Laser"
			$PrinterDetails.PrinterLocation = "SCNC 305"
		}
  
 		# CANON
     		"SEES-PLOTTER" {
			$PrinterDetails.PortName = "sees-plotter"
			$PrinterDetails.PrinterComment = "Canon imagePROGRAF iPF825"
			$PrinterDetails.PrinterLocation = "SCNC 210A"
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
