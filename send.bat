@echo off
for /F "tokens=* USEBACKQ" %%F in (account.txt) do (
set ssh_account=%%F
)
set id_rsa_location=%HOMEDRIVE%%HOMEPATH%\.ssh\id_rsa
echo start update
echo upload log file
echo.
echo ssh connects to %ssh_account%...
ssh -i %id_rsa_location% %ssh_account% "mkdir logs"
ssh -i %id_rsa_location% %ssh_account% "mkdir logs/%date%"
echo.
echo make up a windows event log list to send 
type nul > upload.txt
forfiles /p:%systemroot%\System32\winevt\Logs /M *.evtx /D -1 /C "CMD /C echo put %systemroot%\system32\winevt\Logs\@file logs/%date%/" >> "%~dp0%upload.txt"
echo bye >> "%~dp0%upload.txt"
echo.
echo sftp connects to %ssh_account%...
sftp -b upload.txt -i %id_rsa_location% %ssh_account%
echo.
echo upload log file done!
echo finish
