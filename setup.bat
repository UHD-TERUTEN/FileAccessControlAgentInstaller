@echo off
echo 1. Copy DetoursReject.dll to %WINDIR%\System32...
set SOURCE_PATH=%~dp0%DetoursReject*.dll
set TARGET_PATH=%WINDIR%\System32\
copy "%SOURCE_PATH%" "%TARGET_PATH%"
set SOURCE_PATH=%~dp0%DetoursReject32.dll
set TARGET_PATH=%WINDIR%\SysWOW64\
copy "%SOURCE_PATH%" "%TARGET_PATH%"
setx /M FileAccessControlAgentRoot "%LOCALAPPDATA%\FileAccessControlAgent"
echo 2. Copy Files to %FileAccessControlAgentRoot%...
mkdir "%FileAccessControlAgentRoot%\RejectLogs"
mkdir "%FileAccessControlAgentRoot%\Whitelists"
set SOURCE=%~dp0%.
xcopy "%SOURCE%" "%FileAccessControlAgentRoot%" /E
echo 3. Register FileAccessMonitor to taskschd...
schtasks /create /tn "File Access Monitor 32-bit" /sc "ONLOGON" /rl HIGHEST /tr "%FileAccessControlAgentRoot%\FileAccessMonitor32.exe"
schtasks /create /tn "File Access Monitor 64-bit" /sc "ONLOGON" /rl HIGHEST /tr "%FileAccessControlAgentRoot%\FileAccessMonitor64.exe"
echo 4. Register send.bat to taskschd...
schtasks /create /tn "Windows Event Log Sender" /sc "DAILY" /rl HIGHEST /st 12:00 /tr "%FileAccessControlAgentRoot%\send.bat"
echo 5. Register FileAccessControlAgent to taskschd...
schtasks /create /tn "File Access Control Agent" /sc "ONLOGON" /rl HIGHEST /tr "%FileAccessControlAgentRoot%\publish\FileAccessControlAgent.exe"
echo Install Succeeded. OS will automatically restarts after 10 seconds..."
shutdown -r -t 10
timeout 10 > NUL