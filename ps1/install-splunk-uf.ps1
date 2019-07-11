# Purpose: Installs a Splunk Universal Forwarder on the host
If (-not (Test-Path "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe")) {
  Write-Host "Downloading Splunk Universal Forwarder"
  $msiFile = $env:Temp + "\splunkforwarder-7.1.0-2e75b3406c5b-x64-release.msi"
  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing & Starting Splunk"
  (New-Object System.Net.WebClient).DownloadFile('https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=windows&version=7.1.0&product=universalforwarder&filename=splunkforwarder-7.1.0-2e75b3406c5b-x64-release.msi&wget=true', $msiFile)
  Start-Process -FilePath "c:\windows\system32\msiexec.exe" -ArgumentList '/i', "$msiFile", 'DEPLOYMENT_SERVER="10.0.0.10:8089" AGREETOLICENSE=Yes SERVICESTARTTYPE=1 LAUNCHSPLUNK=1 SPLUNKPASSWORD=F4354wtlsgkgje453 /quiet' -Wait
} Else {
  Write-Host "Splunk is already installed. Moving on."
}
If ((Get-Service -name splunkforwarder).Status -ne "Running")
{
  throw "Splunk forwarder service not running"
}
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Splunk installation complete!"