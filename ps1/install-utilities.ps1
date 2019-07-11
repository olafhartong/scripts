# Purpose: Installs chocolatey package manager, then installs custom utilities from Choco and adds syntax highlighting for Powershell, Batch, and Docker. Also installs Mimikatz into c:\Tools\Mimikatz.

If (-not (Test-Path "C:\ProgramData\chocolatey")) {
  Write-Host "Installing Chocolatey"
  iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
  Write-Host "Chocolatey is already installed."
}

Write-Host "Installing Notepad++, Chrome, WinRar, Firefox."
If ($(hostname) -eq "win10") {
  # Because the Windows10 start menu sucks
  choco install -y classic-shell -installArgs ADDLOCAL=ClassicStartMenu
}
choco install -y NotepadPlusPlus
choco install -y GoogleChrome
choco install -y Firefox
choco install -y 7zip

Write-Host "Utilties installation complete!"
