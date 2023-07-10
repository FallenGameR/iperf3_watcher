$json = iperf3 -c iperf3server --json
$parsed = $json | ConvertFrom-Json
$speedInMibs = $parsed.end.sum_received.bits_per_second / 1mb

function Write-Log
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Text
    )

    $time = Get-Date
    $day = $time.ToString("dd")
    $logPath = "$PsScriptRoot\iperf3_$day.csv"
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

Write-Log $speedInMibs