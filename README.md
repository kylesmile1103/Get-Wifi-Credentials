# Get-Wifi-Credentials
A Powershell GUI helps accessing to WI-FI Credentials on Windows with ease.

## Usage

### Option 1
* Step 1: Clone this repo or just download the app.ps1
* Step 2: Make sure your Execution Policy is not Restricted, you can check by issuing this command: `Get-ExecutionPolicy`. If it's not, run Powershell as Administrator and execute `Set-ExecutionPolicy unrestricted`.
* Step 3: Right click at the app.ps1, Run with Powershell and you're good to go.

### Option 2
* Open Powershell as Administrator then execute these following commands (copy all and paste by pressing right click to the console):

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process -Force;
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/kylesmile1103/Get-Wifi-Credentials/main/app.ps1'))
```

## Screenshot
![alt text](https://github.com/kylesmile1103/Get-Wifi-Credentials/blob/main/screenshot.png "Screenshot")
