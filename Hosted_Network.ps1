$a = netsh wlan show hostednetwork
$messege = ""
$table = @{"c8:25:e1:22:3f:d7" = "Le 1S, Sourav Dokania";
           "00:00:00:00:00:00" = "Invalid";
           "90:48:9a:42:c4:45" = "HP Laptop, Ayush Aggarwal";
           "10:08:b1:9f:f4:9d" = "Lenovo, Abhijit Tripathy";
           "ec:88:92:78:8b:1a" = "Moto G2, Ayush Aggarwal";
		   "5c:93:a2:df:ce:cf" = "Lenovo, Chirag Mehta"
		   }
$status = !$a[11].Contains("Not started")
if($status)
{   
    $b = "Number of clients      :"
    $NumberOfClients = $a[15].Substring($a[15].IndexOf($b) + $b.Length + 1).ToInt32($null)
    #Write-Host "No of clients = $NumberOfClients"
        $clients = @(0) * $NumberOfClients
        #Write-Host $NumberOfClients
        for($i = 0; $i -lt $NumberOfClients; $i++)
        {
            $clients[$i] = $a[16+$i].Substring(8,17)
            #write-host $clients[$i]
            if($table.ContainsKey($clients[$i]))
            {
                $messege += $table.Get_Item($clients[$i]) + "`n"
                
            }
            else
            {
                $messege += $clients[$i] + "`n"
            }
            Write-Host $messege
        }
}
else
{
    #write-host "HosSpot Disabled"
}

<#function macResolve([String]$macAddress)
{
    if($Global:table.ContainsKey($macAddress))
    {
        $Global:table.Get_Item($macAddress)
    }
    else
    {
        $macAddress
    }
}#>
if($NumberOfClients -eq 0) {$messege = "None Connected"}
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 
$objNotifyIcon.Icon = "C:\Users\sourav\Desktop\devil.ico"
$objNotifyIcon.BalloonTipIcon = "Info"
$objNotifyIcon.BalloonTipText = $messege
$objNotifyIcon.BalloonTipTitle = "Devices Connected`n" + [DateTime]::Now.ToLongDateString()
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
while(1)
{
}
<##>