@echo off
title lerocxn lag test - Ping Simulator
call :banner

:menu
cls
echo.
echo  ============================================================
echo        lerocxn lag test  ^|  PING SIMULATOR
echo  ============================================================
echo.
echo   [1]  Hafif Lag     (~50-100ms ek gecikme)
echo   [2]  Orta Lag      (~100-200ms ek gecikme)
echo   [3]  Agir Lag      (~300ms+ ek gecikme)
echo   [4]  Lag Kaldir    (Normal ayarlara don)
echo   [5]  Mevcut Durumu Goster
echo   [6]  Cikis
echo.
echo  ============================================================
echo.

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo  [HATA] Lutfen Yonetici olarak calistirin!
    pause
    exit
)

set /p "sec=Seciminiz: "
if "%sec%"=="1" goto hafif
if "%sec%"=="2" goto orta
if "%sec%"=="3" goto agir
if "%sec%"=="4" goto kaldir
if "%sec%"=="5" goto durum
if "%sec%"=="6" exit
goto menu

:hafif
cls
echo  [*] Hafif lag uygulanıyor...
netsh int tcp set global autotuninglevel=disabled >nul 2>&1
netsh int tcp set global rss=disabled >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "30" /f >nul 2>&1
net stop dnscache >nul 2>&1
echo  [OK] Hafif lag aktif! (~50-100ms)
pause
goto menu

:orta
cls
echo  [*] Orta lag uygulanıyor...
netsh int tcp set global autotuninglevel=disabled >nul 2>&1
netsh int tcp set global rss=disabled >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /t REG_DWORD /d "6" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "5000" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "60" /f >nul 2>&1
net stop dnscache >nul 2>&1
echo  [OK] Orta lag aktif! (~100-200ms)
pause
goto menu

:agir
cls
set /p "onay=  UYARI: Agir lag uygulanacak! Devam? (E/H): "
if /i "%onay%" neq "E" goto menu
netsh int tcp set global autotuninglevel=disabled >nul 2>&1
netsh int tcp set global rss=disabled >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d "4096" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "90" /f >nul 2>&1
net stop dnscache >nul 2>&1
echo  [OK] Agir lag aktif! (~300ms+)
pause
goto menu

:kaldir
cls
echo  [*] Tum lag ayarlari kaldiriliyor...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
netsh int tcp set global congestionprovider=ctcp >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /f >nul 2>&1
net start dnscache >nul 2>&1
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
echo  [OK] Lag kaldirildi!
pause
goto menu

:durum
cls
echo  --- TCP Global ---
netsh int tcp show global | findstr /i "Auto-Tuning RSS"
echo.
echo  --- DNS Cache ---
sc query dnscache | findstr /i "STATE"
echo.
pause
goto menu

:banner
for %%C in (09 0A 0B 03 0D 05 0E 06 04 0C 01 02) do (
    color %%C
    cls
    echo.
    echo  ============================================================
    echo        lerocxn lag test  ^|  PING SIMULATOR
    echo  ============================================================
    ping 127.0.0.1 -n 1 -w 100 >nul
)
color 0C
goto :eof
