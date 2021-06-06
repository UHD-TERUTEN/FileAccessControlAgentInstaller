@echo off
set root=%HOMEDRIVE%%HOMEPATH%
for /F "tokens=* USEBACKQ" %%F in (%FileAccessControlAgentRoot%\scripts\account.txt) do (
set ssh_account=%%F
)
set id_rsa_location=%root%\.ssh\id_rsa
echo start uploading
echo zipping reject log files
tar -zcvf "%root%\Logs\RejectLogs\%DATE%.tar.gz" -C %root%\Logs\RejectLogs *.txt
echo.
echo uploading zip file
echo ssh connects to %ssh_account%...
ssh -i %id_rsa_location% %ssh_account% "mkdir Logs"
scp -i %id_rsa_location% "%root%\Logs\RejectLogs\%DATE%.tar.gz" "%ssh_account%:Logs"
del "%root%\Logs\RejectLogs\%DATE%.tar.gz"
echo.
echo log files have been uploaded!
echo finish

@REM sqlite3 db.sqlite < "insert into Whitelist values(%filename%,null)"
@REM sqlite3 db.sqlite < update_system_logs.txt
@REM sqlite3 db.sqlite < update_file_access_reject_logs.txt
@REM sqlite3 db.sqlite < update_inquiry.txt
