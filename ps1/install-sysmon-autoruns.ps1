# Purpose: Installs a handful of SysInternals tools on the host into c:\Tools\Sysinternals
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing SysInternals Tooling..."
$sysinternalsDir = "C:\Tools\Sysinternals"
$sysmonDir = "C:\ProgramData\Sysmon"
If(!(test-path $sysinternalsDir)) {
  New-Item -ItemType Directory -Force -Path $sysinternalsDir
} Else {
  Write-Host "Tools directory exists. Exiting."
  exit
}
If(!(test-path $sysmonDir)) {
  New-Item -ItemType Directory -Force -Path $sysmonDir
} Else {
  Write-Host "Sysmon directory exists. Exiting."
  exit
}
$autorunsPath = "C:\Tools\Sysinternals\Autoruns64.exe"
$sysmonPath = "C:\Tools\Sysinternals\Sysmon.exe"
$sysmonConfigPath = "$sysmonDir\sysmonConfig.xml"

# Microsoft likes TLSv1.2 as well
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Downloading Autoruns64.exe..."
(New-Object System.Net.WebClient).DownloadFile('https://live.sysinternals.com/Autoruns64.exe', $autorunsPath)
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Downloading Sysmon.exe..."
(New-Object System.Net.WebClient).DownloadFile('https://live.sysinternals.com/Sysmon.exe', $sysmonPath)


# Download Olaf Hartongs Sysmon config
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Downloading Olaf Hartong's Sysmon config..."
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/olafhartong/sysmon-configs/master/sysmonconfig-v9.xml', "$sysmonConfigPath")

# Start Sysmon
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Starting Sysmon..."
Start-Process -FilePath "$sysmonPath" -ArgumentList "-accepteula -i $sysmonConfigPath"
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Verifying that the Sysmon service is running..."
Start-Sleep 5 # Give the service time to start
If ((Get-Service -name Sysmon).Status -ne "Running")
{
  throw "The Sysmon service did not start successfully"
}
