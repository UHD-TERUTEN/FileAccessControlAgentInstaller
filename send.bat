@echo off
@REM for /F "tokens=* USEBACKQ" %%F in (account.txt) do (
@REM set ssh_account=%%F
@REM )
@REM set id_rsa_location=%HOMEDRIVE%%HOMEPATH%\.ssh\id_rsa
@REM echo start update
@REM echo upload log file
@REM echo.
@REM echo ssh connects to %ssh_account%...
@REM ssh -i %id_rsa_location% %ssh_account% "mkdir logs"
@REM echo.
@REM echo sftp connects to %ssh_account%...
@REM sftp -b upload.txt -i %id_rsa_location% %ssh_account%
@REM echo.
@REM echo upload log file done!
@REM echo finish

@REM echo mput > "%~dp0%filelist.txt"
@REM forfiles /p:%systemroot%\system32\winevt\Logs /M *.evtx /D -1 >> "%~dp0%filelist.txt"
@REM echo bye >> "%~dp0%filelist.txt"

forfiles /p:%systemroot%\system32\winevt\Logs /M *.evtx /D -1 /C "CMD /C sftp put @file -i %id_rsa_location% %ssh_account%"
