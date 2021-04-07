@echo off
for /F "tokens=* USEBACKQ" %%F in (account.txt) do (
set ssh_account=%%F
)
set id_rsa_location=%HOMEDRIVE%%HOMEPATH%\.ssh\id_rsa
echo start update
echo zipping reject log files
tar -cf "%DATE%.zip" -C %FileAccessControlAgentRoot%\RejectLogs .
echo.
echo uploading zip file
echo ssh connects to %ssh_account%...
ssh -i %id_rsa_location% %ssh_account% "mkdir logs && mkdir logs/RejectLogs"
scp -i %id_rsa_location% "%DATE%.zip" "%ssh_account%:logs/RejectLogs"
del "%DATE%.zip"
echo.
echo zipping Windows event log files
tar -cf "%DATE%.zip" -C %systemroot%\System32\winevt\Logs *.evtx
echo.
echo uploading zip file
echo ssh connects to %ssh_account%...
ssh -i %id_rsa_location% %ssh_account% "mkdir logs/EventLogs"
scp -i %id_rsa_location% "%DATE%.zip" "%ssh_account%:logs/EventLogs"
del "%DATE%.zip"
echo.
echo log files have been uploaded!
echo finish
