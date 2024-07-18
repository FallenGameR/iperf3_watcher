function Start-Monitor
{
    param
    (
        [scriptblock] $Measurement,
        [scriptblock] $Logging,
        [timespan] $Interval = [timespan]::FromSeconds(1)
    )

    while( $true )
    {
        $startExact = Get-Date
        $value = & $Measurement
        $finishedExact = Get-Date

        $start = [datetime]::parse($startExact.ToString("yyyy/MM/dd HH:mm:ss"))
        $next = $start.Add($interval)
        if( -not $value ){ $value = -1 }

        $logged = $start
        while( $logged -lt $next )
        {
            $info = "{0},{1}" -f $logged.ToString("yyyy/MM/dd HH:mm:ss"), $value
            & $Logging $info
            $logged = $logged.Add($interval)
        }

        $sleep = $next - [datetime]::Now
        if( $sleep -gt [timespan]::Zero )
        {
            Start-Sleep -Milliseconds $sleep.TotalMilliseconds
        }
    }
}

function Test-Latency
{
    Test-Connection google.com -Count 1 | foreach Latency
}

function Test-Download
{
    $reply = iperf3 -c iperf3server --json | ConvertFrom-Json
    $mbpsDownload = $reply.end.sum_received.bits_per_second / 1mb
    [math]::Round($mbpsDownload, 2)
}

function Out-File
{
    param($line, $prefix)

    $path = "$PsScriptRoot\data\$($prefix)_$(Get-Date -Format "dd").csv"

    if( -not (Test-Path $path) )
    {
        $header = "Timestamp,$prefix"
        $header | Add-Content -Path $path
    }

    $line | Add-Content -Path "$PsScriptRoot\data\$($prefix)_$(Get-Date -Format "dd").csv"
}

function Trace-Latency( $prefix )
{
    Start-Job -ArgumentList $PsScriptRoot, $prefix -ScriptBlock {
        param($root, $prefix)

        . $root/ping.ps1
        $prefix += "_latency"

        Start-Monitor `
            { Test-Latency } `
            { param($line) Out-File $line $prefix } `
            "00:00:01"
    }
}

function Trace-Download( $prefix )
{
    Start-Job -ArgumentList $PsScriptRoot, $prefix -ScriptBlock {
        param($root, $prefix)

        . $root/ping.ps1
        $prefix += "_download"

        Start-Monitor `
            { Test-Download } `
            { param($line) Out-File $line $prefix } `
            "00:05:00"
    }
}

<#

C:\Windows\System32\drivers\etc\hosts
20.106.102.7 iperf3server


        Start-Monitor `
            { Test-Latency } `
            { param($line) $line } `
            "00:00:01"

#>



