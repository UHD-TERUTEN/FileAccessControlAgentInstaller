@echo off
echo 1. Copy DetoursReject.dll to %WINDIR%\System32...
set SOURCE_PATH=%~dp0%DetoursReject.dll
set TARGET_PATH=%WINDIR%\System32\DetoursReject.dll
copy "%SOURCE_PATH%" "%TARGET_PATH%"
echo 2. Register FileAccessMonitor to taskschd...
schtasks /create /tn "File Access Monitor" /sc "ONLOGON" /rl HIGHEST /tr "%~dp0%\FileAccessMonitor.exe"
echo 3. Register send.bat to taskschd...
schtasks /create /tn "Audit Log Sender" /sc "DAILY" /st 00:00 /ru system /tr "%~dp0%\send.bat
echo 4. Register FileAccessControlAgent to taskschd...
schtasks /create /tn "File Access Control Agent" /sc "ONLOGON" /rl HIGHEST /tr "%~dp0%\publish\FileAccessControlAgent.exe"
echo Install Succeeded. OS will automatically restarts after 10 seconds..."
shutdown -r -t 10
timeout 10 > NUL