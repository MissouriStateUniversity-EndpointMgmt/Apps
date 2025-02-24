
# Printer Drivers
$DriverName = "TOSHIBA Universal Printer 2"
$INFFile = "eSf6u.inf"
Write-Output "PathC"
Write-Output $INFFile
Write-Output (Get-Location).Path
$ScriptPath = (Get-Location).Path

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

$INFPath = "$ScriptPath\drivers\$INFFile"
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
		Get-WmiObject -Class Win32_Printer | where{$_.Name -eq "\\eagle\$PrinterName" } | foreach{$_.delete()}
		Get-WmiObject -Class Win32_Printer | where{$_.Name -eq "\\jupiter\$PrinterName" } | foreach{$_.delete()}

		#Add driver to driver store
		Write-Output "Adding Driver to Windows DriverStore using INF ""$($INFPath)"""
		#Start-Process C:\Windows\System32\pnputil.exe -ArgumentList $INFARGS -Wait -NoNewWindow
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
