$json = iperf3 -c iperf3server --json
$parsed = $json | ConvertFrom-Json

# sender - is iperf client, Upload speed from iperf client to iperf server is measured
# receiver - is iperf server, Download speed on iperf server from iperf client is measured
$speedInMibs = $parsed.end.sum_received.bits_per_second / 1mb

$latencyText = psping -n 3 iperf3server:5201
$latencyInMs = $latencyText | where{ $psitem -match "Average = (\d+\.\d+)ms" } | foreach{ $Matches[1] }

function Write-Log
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Text
    )

    $time = Get-Date
    $day = $time.ToString("dd")
    $logPath = "$PsScriptRoot\data\iperf3_$day.csv"
    $logEntry = $time.ToString("yyyy/MM/dd HH:mm:ss") + "," + $Text

    $isFilePresent = Test-Path $logPath -ea Ignore
    $isStaleFile = (Get-Item $logPath -ea Ignore | % LastWriteTime | % Date) -ne $time.Date
    $isAppendNeeded = $isFilePresent -and (-not $isStaleFile)

    if( $isAppendNeeded )
    {
        $logEntry >> $logPath
    }
    else
    {
        $logEntry > $logPath
    }
}

Write-Log "$speedInMibs,$latencyInMs"