# Contributions
# https://github.com/byteben/Windows-10/blob/master/Remove-Printer.ps1

Try {
  #Remove Printer
  Get-Service Spooler | Where {$_.status -eq 'Stopped'} | Start-Service -Verbose
  $PrinterExist = Get-Printer -Name $PrinterName -ErrorAction SilentlyContinue
  if ($PrinterExist) {
    Remove-Printer -Name $PrinterName -Confirm:$false
  }
}
Catch {
  Write-Warning "Error removing Printer"
  Write-Warning "$($_.Exception.Message)"
}
