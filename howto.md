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

Set task manually to:

- be hidden (probably is not needed)
- be configured for Vista (probably is not needed)
- run even if current user is not logged in
