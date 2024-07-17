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
        $next = [datetime]::parse($finishedExact.ToString("yyyy/MM/dd HH:mm:ss")).Add($interval)

        $logged = $start
        while( $logged -lt $next )
        {
            $info = "{0},{1}" -f $logged.ToString("yyyy/MM/dd HH:mm:ss"), $value
            & $Logging $info
            $logged = $logged.AddSeconds(1)
        }

        $sleep = $next - [datetime]::Now
        if( $sleep -gt [timespan]::Zero )
        {
            Start-Sleep -Duration $sleep
        }
    }
}

Start-Monitor `
    {Test-Connection google.com -Count 1 | foreach Latency} `
    { param($line) $line } `
    "00:00:01"