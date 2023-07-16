# Howto

## Modify hosts file

```ps1
# set iperf3server entry
code C:\Windows\System32\drivers\etc\hosts
```

## Schedule for periodic execution

```ps1
$taskAction = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument '-nop -w Hidden -File "C:\Users\Alex\src\iperf3_watcher\run.ps1"'
$taskTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration (New-TimeSpan -Days (365*10))
$taskSettings = New-ScheduledTaskSettingsSet
Register-ScheduledTask -TaskName "iperf3_watcher" -Action $taskAction -Trigger $taskTrigger -Settings $taskSettings
```

Then open task scheduler and set that it would be executed ragerdless if the user was logged in.

## Server - start on every boot

```ps1
$taskAction = New-ScheduledTaskAction -Execute 'iperf3.exe' -Argument '-s'
$taskTrigger = New-ScheduledTaskTrigger -AtStartup
$taskPrincipal = New-ScheduledTaskPrincipal -UserId ".\fallengamer"
$task = New-ScheduledTask -Action $taskAction -Trigger $taskTrigger # -Principal $taskPrincipal
$task | Register-ScheduledTask -TaskName "iperf3 server" # -User $taskPrincipal -Password $null -Force
# $STPrin = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
```

Then open task scheduler and set that it would be executed ragerdless if the user was logged in.

## Joing functionality

`PingTrace` to reboot gateway.
