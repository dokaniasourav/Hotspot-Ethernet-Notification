$messege = ""



#Function to see what proxy needs to be set

    $regKey="HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    [String]$proxyServerMorning = "localhost:9001"
    [String]$proxyServerEvening = "172.16.15.11:8080"
    $proxyServer = Get-ItemProperty -path $regKey -ErrorAction SilentlyContinue
    $day =  Get-Date
    if(($day.DayOfWeek.value__ -ne 6) -and 
       ($day.DayOfWeek.value__ -ne 0) -and
       ($day.Hour -gt 9) -and ($day.Hour -lt 19))
       {
            [String]$proxyValue = $proxyServerMorning
       }
       else
       {
            [String]$proxyValue = $proxyServerEvening
       }


#Function to return true if ethernet connected
    $networkAdapters = Get-NetAdapter -Name "Ethernet" -ErrorAction SilentlyContinue
    if($networkAdapters.MediaConnectionState -eq "Connected")
    {
        [Int]$proxyEnable = 1
    }
    else
    {
        [Int]$proxyEnable = 0
    }


    $regKey="HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    $currentSettings = Get-ItemProperty -Path $regKey
    if($currentSettings.ProxyEnable -ne $proxyEnable)
    {
        Set-ItemProperty -Path $regKey -Name ProxyEnable -Value $proxyEnable
        $messege += If($proxyEnable){"Ethernet Inserted, Proxy Enabled`n"} else {"Lan Wire Removed, Proxy Disabled`n"}
    }
    if($currentSettings.ProxyServer -ne $proxyValue)
    {
        Set-ItemProperty -Path $regKey -Name ProxyServer -Value $proxyValue
        $messege += "The Value changed to $proxyValue `n"
    }
    #Write-Host ProxyEnabled = ($proxyEnable -eq 1) and Value = $proxyValue




#Sends a System-Wide Braodcast to all applications that the proxy settings have been changed

$source=@"
[DllImport("wininet.dll")]
public static extern bool InternetSetOption(int hInternet, int dwOption, int lpBuffer, int dwBufferLength);
"@
#Create type from sourc
$wininet = Add-Type -memberDefinition $source -passthru -name InternetSettings
#INTERNET_OPTION_PROXY_SETTINGS_CHANGED
$wininet::InternetSetOption([IntPtr]::Zero, 95, [IntPtr]::Zero, 0)|out-null
#INTERNET_OPTION_REFRESH
$wininet::InternetSetOption([IntPtr]::Zero, 37, [IntPtr]::Zero, 0)|out-null


    $a = netsh wlan show hostednetwork
    Write-Host $a[11]
    if($a[11].Contains("Not started"))
    {
        $k = netsh wlan start hostednetwork
        $messege += $k
    }
    else
    {
        $b = "Number of clients      :"
        $NumberOfClients = $a[15].Substring($a[15].IndexOf($b) + $b.Length + 1)
        $messege += "Hotspot Running, $NumberOfClients Connected"
    }


[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 
$objNotifyIcon.Icon = "C:\Users\sourav\Desktop\devil.ico"
$objNotifyIcon.BalloonTipIcon = "Info"
$objNotifyIcon.BalloonTipText = $messege
$objNotifyIcon.BalloonTipTitle = [DateTime]::Now.ToLongDateString()
$objNotifyIcon.Visible = $True
$objNotifyIcon.ShowBalloonTip(2000)

<#
Write-Host "`r`nPRESS Ctrl+C   OR WAIT FOR..."
$timeout = new-timespan -Seconds 6
$sw = [diagnostics.stopwatch]::StartNew()
$t = 5
while ($sw.elapsed -lt $timeout){
    start-sleep -seconds 1
    Write-Host $t "Seconds"
    $t = $t - 1
}
<##>