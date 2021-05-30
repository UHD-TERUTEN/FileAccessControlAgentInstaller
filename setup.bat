@echo off
echo 1. Copy DetoursReject.dll to %WINDIR%\System32...
set SOURCE_PATH=%~dp0%DetoursReject*.dll
set TARGET_PATH=%WINDIR%\System32\
copy "%SOURCE_PATH%" "%TARGET_PATH%"
set SOURCE_PATH=%~dp0%DetoursReject32.dll
set TARGET_PATH=%WINDIR%\SysWOW64\
copy "%SOURCE_PATH%" "%TARGET_PATH%"
set FILE_ACCESS_CONTROL_AGENT_ROOT "%LOCALAPPDATA%\FileAccessControlAgent"
setx /M FileAccessControlAgentRoot "%FILE_ACCESS_CONTROL_AGENT_ROOT%"
echo 2. Copy Files to %FILE_ACCESS_CONTROL_AGENT_ROOT%...
mkdir "%FILE_ACCESS_CONTROL_AGENT_ROOT%\RejectLogs"
mkdir "%FILE_ACCESS_CONTROL_AGENT_ROOT%\Whitelists"
set SOURCE=%~dp0%.
xcopy "%SOURCE%" "%FILE_ACCESS_CONTROL_AGENT_ROOT%" /E
echo 3. Register FileAccessMonitor to taskschd...
schtasks /create /tn "File Access Monitor 32-bit" /sc "ONLOGON" /rl HIGHEST /tr "%FILE_ACCESS_CONTROL_AGENT_ROOT%\FileAccessMonitor32.exe"
schtasks /create /tn "File Access Monitor 64-bit" /sc "ONLOGON" /rl HIGHEST /tr "%FILE_ACCESS_CONTROL_AGENT_ROOT%\FileAccessMonitor64.exe"
echo 4. Register send.bat to taskschd...
schtasks /create /tn "Windows Event Log Sender" /sc "DAILY" /rl HIGHEST /st 13:00 /tr "%FILE_ACCESS_CONTROL_AGENT_ROOT%\send.bat"
echo 5. Register FileAccessControlAgent to taskschd...
schtasks /create /tn "File Access Control Agent" /sc "ONLOGON" /rl HIGHEST /tr "%FILE_ACCESS_CONTROL_AGENT_ROOT%\publish\FileAccessControlAgent.exe"
echo Install Succeeded. OS will automatically restarts after 10 seconds..."
shutdown -r -t 10
timeout 10 > NUL