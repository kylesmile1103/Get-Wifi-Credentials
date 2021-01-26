Add-Type -AssemblyName PresentationFramework | Out-Null
Add-Type -AssemblyName System.Drawing | Out-Null
Add-Type -AssemblyName System.Windows.Forms | Out-Null
Add-Type -AssemblyName WindowsFormsIntegration | Out-Null
[void][System.Windows.Forms.Application]::EnableVisualStyles()
[Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8bom'
$wshell = New-Object -ComObject Wscript.Shell

# function LoadXml ($global:filename) {
#     $XamlLoader = (New-Object System.Xml.XmlDocument)
#     $XamlLoader.Load($filename)
#     return $XamlLoader
# }
# $scriptPath = $myinvocation.MyCommand.Definition
# $localFile = split-path -parent $scriptPath
# [Xml]$xaml = LoadXml("$localFile\gui.xaml")

[Xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" Title="Get Wifi Credentials" MinHeight="400" MinWidth="280">
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="*" />
            <ColumnDefinition Width="*" />
        </Grid.ColumnDefinitions>
        <Grid.RowDefinitions>
            <RowDefinition Height="*" />
        </Grid.RowDefinitions>
        <GroupBox Margin="5,5,5,0" Header="Wifi Info" FlowDirection="RightToLeft">
            <Grid HorizontalAlignment="Stretch" VerticalAlignment="Stretch" FlowDirection="LeftToRight" Margin="5,5,0,0">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto" />
                    <RowDefinition Height="Auto" />
                    <RowDefinition Height="*" />
                </Grid.RowDefinitions>
                <Label Grid.Row="0" Content="WIFI SSID LIST" HorizontalAlignment="Center" FontSize="20" />
                <Grid Grid.Row="1">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*" />
                        <ColumnDefinition Width="*" />
                        <ColumnDefinition Width="5*" />
                    </Grid.ColumnDefinitions>
                    <Button Width="55" Height="18" ToolTip="Refresh current list" x:Name="refresh" Grid.Column="0" Content="Refresh" />
                    <Button Width="55" Height="18" ToolTip="Toggle sort list Ascending/Descending" x:Name="sort" Grid.Column="1" Content="Sort" />
                    <Grid Grid.Column="2" HorizontalAlignment="Right">
                        <TextBox Width="280" VerticalAlignment="Center" HorizontalAlignment="Left" x:Name="search" Margin="5"/>
                        <TextBlock IsHitTestVisible="False" Text="Search for SSID" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10,0,0,0" Foreground="DarkGray">
                            <TextBlock.Style>
                                <Style TargetType="{x:Type TextBlock}">
                                    <Setter Property="Visibility" Value="Collapsed"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding Text, ElementName=search}" Value="">
                                            <Setter Property="Visibility" Value="Visible"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                    </Grid>
                </Grid>
                <ListBox Grid.Row="2" x:Name="SSID" FontSize="18"/>
            </Grid>
        </GroupBox>
        <Grid Grid.Column="1">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto" />
                <RowDefinition Height="Auto" />
            </Grid.RowDefinitions>
            <GroupBox Grid.Row="0" Header="Password" FlowDirection="RightToLeft" Margin="5,5,5,5">
                <Grid FlowDirection="LeftToRight" Margin="0,8,0,8">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="4*" />
                        <ColumnDefinition Width="*" />
                    </Grid.ColumnDefinitions>
                    <TextBlock x:Name="Pass" Grid.Column="0" HorizontalAlignment="Center" VerticalAlignment="Center" FontSize="18" FontStyle="Italic" FontWeight="Bold"/>
                    <Border BorderBrush="Gray" BorderThickness="0,0,1,0"/>
                    <TextBlock x:Name="PassLen" Grid.Column="1" HorizontalAlignment="Left" VerticalAlignment="Center" FontSize="16" Margin="5,0,0,0" />
                </Grid>
            </GroupBox>
            <GroupBox Grid.Row="1" Header="Option" FlowDirection="RightToLeft" Margin="5,5,5,5">
                <Grid VerticalAlignment="Center" HorizontalAlignment="Stretch" Grid.Row="0" FlowDirection="LeftToRight" Margin="0,8,0,8">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*" />
                        <ColumnDefinition Width="*" />
                        <ColumnDefinition Width="*" />
                        <ColumnDefinition Width="*" />
                        <ColumnDefinition Width="*" />
                    </Grid.ColumnDefinitions>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*" />
                    </Grid.RowDefinitions>
                    <Button Grid.Column="1" Width="60" Height="28" ToolTip="Copy current Password to Clipboard" Content="Copy" x:Name="copyBtn" />
                    <Button Grid.Column="2" Width="60" Height="28" ToolTip="Permanently forget current Password" Content="Remove" x:Name="removeBtn" />
                    <Button Grid.Column="3" Width="60" Height="28" ToolTip="Export full list to text file" Content="Export" x:Name="exportBtn" />
                </Grid>
            </GroupBox>
        </Grid>
    </Grid>
</Window>
"@

$Window = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $xaml))
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
    Set-Variable -Name ($_.Name) -Value $window.FindName($_.Name) -Scope Script
}

$script = [scriptblock]::create( {
        [Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8
        $WifiCred = @()
        $listProfiles = netsh wlan show profiles | Select-String -Pattern "All User Profile" | ForEach-Object { ($_ -split ":")[-1].Trim() };
        $listProfiles | ForEach-Object {
            $profileInfo = netsh wlan show profiles name=$_ key="clear";
            $Key = $profileInfo | Select-String -Pattern "Key Content" | ForEach-Object { ($_ -split ":")[-1].Trim() };
            $WifiCred += New-Object -TypeName psobject -Property @{SSID = $_; Password = $Key }
        }
        Write-Output $WifiCred
    })

$SSID.Add_SelectionChanged( {
        [string]$PassText = $WifiCred | Where-Object { $_.SSID -eq $this.SelectedItem } | Select-Object -ExpandProperty Password
        $Pass.text = $PassText
        $PassLen.text = "Length: $($PassText.length)"
    })

$copyBtn.Add_Click( {
        [string]$PassText = $WifiCred | Where-Object { $_.SSID -eq $SSID.SelectedItem } | Select-Object -ExpandProperty Password
        Set-Clipboard $PassText
        $wshell.Popup('Copied "{0}" to the clipboard!' -f $PassText, 0, "Get Wifi Credentials") | Out-Null
    })
    
$exportBtn.Add_Click( {
        $OpenFileDialog = New-Object 'System.Windows.Forms.SaveFileDialog'
        $OpenFileDialog.DefaultExt = "txt"
        $OpenFileDialog.Filter = "Text file (*.txt) |*.txt"
        $OpenFileDialog.title = "Save file to..."
        if ($OpenFileDialog.ShowDialog() -eq 'Ok') {
            $outFile = $OpenFileDialog.FileName
            if ($null -ne $outFile) {
                $expContent = ($WifiCred | Format-Table SSID, Password) | out-string
                $expContent | Out-File $outFile -Force
                (Get-Item $outFile).LastWriteTime = (Get-Date)
                Start-Process "explorer.exe" -ArgumentList "/select, ""$outFile"" "
            }
        }
    })

$removeBtn.Add_Click( {
        [string]$SSIDText = $WifiCred | Where-Object { $_.SSID -eq $SSID.SelectedItem } | Select-Object -ExpandProperty SSID
        netsh wlan delete profile $SSIDText
        $wshell.Popup('Password of "{0}" has been forgotten!' -f $SSIDText, 0, "Get Wifi Credentials") | Out-Null
        [array]$newList = $WifiCred | Where-Object { $_.SSID -ne $SSIDText }
        $SSID.ItemsSource = $newList.SSID
    })

$search.Add_TextChanged( {
        [System.Windows.Data.CollectionViewSource]::GetDefaultView($SSID.ItemsSource).Filter = [Predicate[Object]] {             
            Try {
                $args[0] -match [regex]::Escape($This.Text)
            }
            Catch {
                $True
            }
        }
    })

$refresh.Add_Click( {
        Remove-Variable $WifiCred -ErrorAction SilentlyContinue
        Start-Job -Name dumpWifiInfo -ScriptBlock $script | Wait-Job
        [global]$WifiCred = Receive-Job dumpWifiInfo
        $SSID.ItemsSource = $WifiCred.SSID
    })

$sort.Add_Click( {
        If ([int]$Script:counter -eq 0) {
            $SSID.ItemsSource = $WifiCred.SSID | Sort-Object
            $Script:counter++
        }
        Else {
            $SSID.ItemsSource = $WifiCred.SSID | Sort-Object -Descending
            $Script:counter--
        }
    })

$window.Add_Closing( { [System.Windows.Forms.Application]::Exit(); Stop-Process $pid })
$windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);' 
$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru 
$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)
[System.Windows.Forms.Integration.ElementHost]::EnableModelessKeyboardInterop($window)
$window.Show()
$window.Activate()

Start-Job -Name dumpWifiInfo -ScriptBlock $script | Wait-Job
$WifiCred = Receive-Job dumpWifiInfo
$SSID.ItemsSource = $WifiCred.SSID

$appContext = New-Object System.Windows.Forms.ApplicationContext 
[void][System.Windows.Forms.Application]::Run($appContext)