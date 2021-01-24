# Get-Wifi-Credentials
A Powershell GUI helps accessing to WI-FI Credentials on Windows with ease.

Download and run the ps1 file with Powershell or open Powershell as Administrator then execute these following commands:

```
Set-ExecutionPolicy Unrestricted -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/kylesmile1103/Get-Wifi-Credentials/main/app.ps1'))
```
![alt text](https://github.com/kylesmile1103/Get-Wifi-Credentials/blob/main/screenshot.png "Screenshot")
