<#
.SYNOPSIS
	Simple script to install a network printer from an INF file. The INF and required CAB files hould be in the same directory as the script if creating a Win32app
	
.DESCRIPTION
	Rather than passing all the printer info, the script will get the printer information from Get-PrinterData function and install the printer.
	This script is used for a driver family rather than a generic script for all. The driver information is under # Printer Drivers

.EXAMPLE
	.\Install-Printer.ps1 -PrinterName GGP-BLACK
	
.NOTES
	Author:      Ben Whitmore
	Repository:  https://github.com/byteben/Windows-10/blob/master/Install-Printer.ps1
	Created:     2021-01-12
	Updated:     2021-12-09
	
	Author:      Brian Hays
	Updated:     2024-09-05
	
	Version history:
	2.0.2 - (2021-12-10) - Merged scripts and updated for MSU specific support, using PortName instead of PrinterIP
	2.1.0 - (2024-09-05) - Changed to a switch command instead of passing the DriverName, PortName, PrinterComment, PrinterLocation, INFFile
	2.1.1 - (2025-10-27) - Removed Logging

#>

[CmdletBinding()]
Param (
	[Parameter(Mandatory = $True)]
	[String]$PrinterName
)

# Printer Drivers
$DriverName = "TOSHIBA Universal Printer 2"
$INFFile = "eSf6u.inf"

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
		"CRPM-ORANGE" {
			$PrinterDetails.PortName = "mfp-07060766"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO455"
			$PrinterDetails.PrinterLocation = "LEVY 100"
		}
		"CSC-BLACK" {
			$PrinterDetails.PortName = "csc-black"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO4508A"
			$PrinterDetails.PrinterLocation = "CHEK 203A"
		}
		"CNAS-BLACK" {
			$PrinterDetails.PortName = "mfp14346783"
			$PrinterDetails.PrinterComment = "TOSHIBA e-STUDIO4528A"
			$PrinterDetails.PrinterLocation = "SCNC 142F"
		}
	}
	return $PrinterDetails
}

$INFPath = "$PSScriptRoot\drivers\$INFFile"
Write-Host $INFPath
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
		Get-WmiObject -Class Win32_Printer | where{$_.Name -eq "\\eagle\$PrinterName" } | foreach{$_.delete()}
		Get-WmiObject -Class Win32_Printer | where{$_.Name -eq "\\jupiter\$PrinterName" } | foreach{$_.delete()}

		#Add driver to driver store
		Write-Output "Adding Driver to Windows DriverStore using INF ""$($INFPath)"""
		Start-Process pnputil.exe -ArgumentList $INFARGS -Wait -NoNewWindow

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
