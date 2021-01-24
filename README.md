# Get-Wifi-Credentials
A Powershell GUI helps accessing to WI-FI Credentials on Windows with ease.

Download then run the ps1 file with Powershell or open Powershell as Administrator and execute these following commands:

```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```
