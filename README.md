# Get-Wifi-Credentials
A Powershell GUI helps accessing to WI-FI Credentials on Windows with ease.

## Usage

### Option 1
* Step 1: Clone this repo or just download the app.ps1
* Step 2: Make sure your Execution Policy is not `Restricted`, you can check by issuing this command:
```Get-ExecutionPolicy```. Otherwise, run Powershell as Administrator and execute ```Set-ExecutionPolicy unrestricted```.
* Step 3: Right click at the app.ps1, hit `Run with Powershell` and you'll be good to go.

### Option 2
* Open Powershell then execute these following commands (copy all and paste by pressing right click onto the Powershell console):

```powershell
saps powershell -Verb RunAs -ArgumentList ('-Command "{0}"' -f $(icm -ScriptBlock $([scriptblock]::create( {
$uri='https://raw.githubusercontent.com/kylesmile1103/Get-Wifi-Credentials/main/app.ps1';
Set-ExecutionPolicy Unrestricted -Scope Process -Force;
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
iex ((New-Object System.Net.WebClient).DownloadString($uri));
}))))

```

## Screenshot
![alt text](https://github.com/kylesmile1103/Get-Wifi-Credentials/blob/main/screenshot.png "Screenshot")
