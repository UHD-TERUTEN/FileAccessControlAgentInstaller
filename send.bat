@echo off
for /F "tokens=* USEBACKQ" %%F in (%FileAccessControlAgentRoot%\account.txt) do (
set ssh_account=%%F
)
set id_rsa_location=%HOMEDRIVE%%HOMEPATH%\.ssh\id_rsa
echo start update
echo zipping reject log files
mkdir "%FileAccessControlAgentRoot%\RejectLogs\%DATE%"
move %FileAccessControlAgentRoot%\RejectLogs\*.txt "%FileAccessControlAgentRoot%\RejectLogs\%DATE%"
tar -zcvf "%FileAccessControlAgentRoot%\RejectLogs\%DATE%\%DATE%.tar.gz" -C %FileAccessControlAgentRoot%\RejectLogs\%DATE% .
echo.
echo uploading zip file
echo ssh connects to %ssh_account%...
ssh -i %id_rsa_location% %ssh_account% "mkdir logs && mkdir logs/RejectLogs"
scp -i %id_rsa_location% "%FileAccessControlAgentRoot%\RejectLogs\%DATE%\%DATE%.tar.gz" "%ssh_account%:logs/RejectLogs"
rmdir /s /q "%FileAccessControlAgentRoot%\RejectLogs\%DATE%"
echo.
echo zipping Windows event log files
mkdir "%FileAccessControlAgentRoot%\EventLogs\%DATE%"
forfiles /p:%systemroot%\System32\winevt\Logs /M *.evtx /D -1 /C "CMD /C copy %systemroot%\system32\winevt\Logs\@file %FileAccessControlAgentRoot%\EventLogs\%DATE%"
tar -zcvf "%FileAccessControlAgentRoot%\EventLogs\%DATE%\%DATE%.tar.gz" -C %FileAccessControlAgentRoot%\EventLogs\%DATE% *.evtx
echo.
echo uploading zip file
echo ssh connects to %ssh_account%...
ssh -i %id_rsa_location% %ssh_account% "mkdir logs/EventLogs"
scp -i %id_rsa_location% "%FileAccessControlAgentRoot%\EventLogs\%DATE%\%DATE%.zip" "%ssh_account%:logs/EventLogs"
rmdir /s /q "%FileAccessControlAgentRoot%\EventLogs\%DATE%"
echo.
echo log files have been uploaded!
echo finish