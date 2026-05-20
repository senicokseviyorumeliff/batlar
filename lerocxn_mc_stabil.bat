@echo off
title lerocxn mc stabil
call :banner

:menu
cls
echo.
echo  ============================================================
echo        lerocxn mc stabil  ^|  KNOCKBACK REDUCER
echo  ============================================================
echo.
echo   [1]  Aktif Et   (Minecraft icin optimize et)
echo   [2]  Kaldir     (Normal ayarlara don)
echo   [3]  Durum Goster
echo   [4]  Cikis
echo.
echo  ============================================================
echo.

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo  [HATA] Yonetici olarak calistirin!
    pause
    exit
)

set /p "sec=Seciminiz: "
if "%sec%"=="1" goto aktif
if "%sec%"=="2" goto kaldir
if "%sec%"=="3" goto durum
if "%sec%"=="4" exit
goto menu

:aktif
cls
echo  [*] Minecraft stabil mod aktif ediliyor...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpNoDelay" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /t REG_DWORD /d "0" /f >nul 2>&1
wmic process where name="javaw.exe" CALL setpriority "realtime" >nul 2>&1
wmic process where name="javaw.exe" CALL setpriority "high priority" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
ipconfig /flushdns >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d "0" /f >nul 2>&1
netsh qos add policy "MC_Boost" app="javaw.exe" dscp=46 throttle-rate=-1 >nul 2>&1
sc stop "DiagTrack" >nul 2>&1
sc stop "WSearch" >nul 2>&1
sc stop "SysMain" >nul 2>&1
echo  [OK] Minecraft stabil mod aktif!
pause
goto menu

:kaldir
cls
echo  [*] Normal ayarlara donuluyor...
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpNoDelay" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "10" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "20" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /f >nul 2>&1
netsh qos delete policy "MC_Boost" >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
sc start "DiagTrack" >nul 2>&1
sc start "WSearch" >nul 2>&1
sc start "SysMain" >nul 2>&1
wmic process where name="javaw.exe" CALL setpriority "normal" >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo  [OK] Normal ayarlara donuldu!
pause
goto menu

:durum
cls
echo  --- TCP Ayarlari ---
netsh int tcp show global | findstr /i "Auto-Tuning RSS Chimney"
echo.
echo  --- javaw.exe ---
tasklist | findstr /i "javaw"
echo.
echo  --- Ping (8.8.8.8) ---
ping 8.8.8.8 -n 4
echo.
pause
goto menu

:banner
for %%C in (09 0A 0B 03 0D 05 0E 06 04 0C 01 02) do (
    color %%C
    cls
    echo.
    echo  ============================================================
    echo        lerocxn mc stabil  ^|  KNOCKBACK REDUCER
    echo  ============================================================
    ping 127.0.0.1 -n 1 -w 100 >nul
)
color 0B
goto :eof
