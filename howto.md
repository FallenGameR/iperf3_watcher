# Howto

## Modify hosts file

```ps1
# set iperf3server entry
code C:\Windows\System32\drivers\etc\hosts
```

## Schedule for periodic execution

```ps1
$taskAction = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument '-File "C:\path\to\your\script.ps1"'
$taskTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration ([TimeSpan]::MaxValue)
$taskSettings = New-ScheduledTaskSettingsSet

Register-ScheduledTask -TaskName "ScriptTask" -Action $taskAction -Trigger $taskTrigger -Settings $taskSettings
```
