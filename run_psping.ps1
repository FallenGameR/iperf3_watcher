# Very unstable server
$server = "pspingserver:5201"

function get( $regex )
{
    $line = $input | sls $regex | % line
    if( $line )
    {
        $line -match $regex | Out-Null
        $Matches[1]
    }
    else
    {
        "N/A"
    }
}

# Delay test - TCP establish-drop connection
$delayOut = psping -i 0 $server
$delay = $delayOut | get "Average = (.+)ms"

# Bandwidth test - TCP test works, UDP doesn't
$bandwidthOut = psping -b -l 100k $server
$bandwidth = $bandwidthOut | get "Average = (.+)"

# Speed test - TCP upload 1MB, 1 warmup attempt instead of 5 default
psping -w 1 -l 1m $server

# Speed test - TCP download 1MB, 1 warmup attempt instead of 5 default
psping -r -w 1 -l 1m $server

# Speed test - UDP upload 10KB (the max possible is a bit less than 64KB)
# UDP download and warmup parameters don't really work for some reason
psping -u -l 10k $server

