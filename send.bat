@echo off
for /F "tokens=* USEBACKQ" %%F in (account.txt) do (
set ssh_account=%%F
)
set id_rsa_location=%HOMEDRIVE%%HOMEPATH%\.ssh\id_rsa
set REJECT_LOGS=%LOCALAPPDATA%\FileAccessControlAgent\reject_logs\*
echo start update
echo uploading reject log files
echo.
echo ssh connects to %ssh_account%...
ssh -i %id_rsa_location% %ssh_account% "mkdir logs"
ssh -i %id_rsa_location% %ssh_account% "mkdir logs/reject_logs"
echo.
del upload_reject.txt
type nul > upload_reject.txt
echo %REJECT_LOGS% >> "%~dp0%upload_reject.txt"
echo bye >> "%~dp0%upload_reject.txt"
echo.
echo sftp connects to %ssh_account%...
sftp -b upload_reject.txt -i %id_rsa_location% %ssh_account%
echo.
echo.
echo uploading Windows event log files
echo.
echo ssh connects to %ssh_account%...
ssh -i %id_rsa_location% %ssh_account% "mkdir logs/events"
ssh -i %id_rsa_location% %ssh_account% "mkdir logs/events/%date%"
echo.
echo make up a windows event log list to send 
echo.
del upload_evtx.txt
type nul > upload_evtx.txt
forfiles /p:%systemroot%\System32\winevt\Logs /M *.evtx /D -1 /C "CMD /C echo put %systemroot%\system32\winevt\Logs\@file logs/events/%date%/" >> "%~dp0%upload_evtx.txt"
echo bye >> "%~dp0%upload_evtx.txt"
echo.
echo sftp connects to %ssh_account%...
sftp -b upload_evtx.txt -i %id_rsa_location% %ssh_account%
echo.
echo uploading log files has done!
echo finish
