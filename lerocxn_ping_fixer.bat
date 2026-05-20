@echo off
setlocal enabledelayedexpansion
title lerocxn network optimizer
call :banner

:menu
cls
echo.
echo  ============================================================
echo        lerocxn  ^|  NETWORK OPTIMIZER
echo  ============================================================
echo.
echo   [1]  Ping Dusurucu       (TCP/IP Tweaks)
echo   [2]  QoS Optimizasyonu   (Bant Genisligi)
echo   [3]  DNS Temizle + Hizli DNS
echo   [4]  Guc Plani           (Yuksek Performans)
echo   [5]  Winsock + IP Reset  (Baglanti Yenile)
echo   [6]  TUM NETWORK TWEAKS  (Hepsini Uygula)
echo   [7]  Varsayilana Don     (Geri Al)
echo   [8]  Ag Durumunu Goster
echo   [9]  Cikis
echo.
echo  ============================================================
echo.

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo  [HATA] Yonetici yetkisi gerekli!
    pause
    exit
)

set /p "choice=Seciminiz (1-9): "
if "%choice%"=="1" goto :ping
if "%choice%"=="2" goto :qos
if "%choice%"=="3" goto :dns
if "%choice%"=="4" goto :power
if "%choice%"=="5" goto :winsock
if "%choice%"=="6" goto :allnet
if "%choice%"=="7" goto :reset
if "%choice%"=="8" goto :info
if "%choice%"=="9" exit
goto :menu

:ping
cls
echo  [*] TCP/IP Ping tweaks uygulanıyor...
netsh int tcp set heuristics disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global congestionprovider=ctcp >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global dca=enabled >nul 2>&1
netsh int teredo set state disabled >nul 2>&1
netsh int isatap set state disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpNoDelay" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d "1" /f >nul 2>&1
echo  [OK] Ping tweaks uygulandi!
pause
goto :menu

:qos
cls
echo  [*] QoS optimizasyonu...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DisableBandwidthThrottling" /t REG_DWORD /d "1" /f >nul 2>&1
echo  [OK] QoS tamamlandi!
pause
goto :menu

:dns
cls
echo  [*] DNS temizleniyor...
ipconfig /flushdns >nul 2>&1
nbtstat -R >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d "0" /f >nul 2>&1
echo.
echo   [1] Cloudflare 1.1.1.1   [2] Google 8.8.8.8   [3] Quad9 9.9.9.9   [4] Atla
set /p "d=DNS: "
if "%d%"=="1" (for /f "tokens=3" %%i in ('netsh interface show interface ^| findstr /i "connected"') do (netsh interface ip set dns "%%i" static 1.1.1.1 >nul 2>&1 & netsh interface ip add dns "%%i" 1.0.0.1 index=2 >nul 2>&1))
if "%d%"=="2" (for /f "tokens=3" %%i in ('netsh interface show interface ^| findstr /i "connected"') do (netsh interface ip set dns "%%i" static 8.8.8.8 >nul 2>&1 & netsh interface ip add dns "%%i" 8.8.4.4 index=2 >nul 2>&1))
if "%d%"=="3" (for /f "tokens=3" %%i in ('netsh interface show interface ^| findstr /i "connected"') do (netsh interface ip set dns "%%i" static 9.9.9.9 >nul 2>&1 & netsh interface ip add dns "%%i" 149.112.112.112 index=2 >nul 2>&1))
echo  [OK] DNS tamamlandi!
pause
goto :menu

:power
cls
echo  [*] Guc plani optimize ediliyor...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
if %errorLevel% neq 0 (powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1)
powercfg /hibernate off >nul 2>&1
echo  [OK] Guc plani tamamlandi!
pause
goto :menu

:winsock
cls
echo  [*] Winsock + IP reset...
ipconfig /release >nul 2>&1
ipconfig /flushdns >nul 2>&1
netsh int ip reset >nul 2>&1
netsh winsock reset catalog >nul 2>&1
ipconfig /renew >nul 2>&1
echo  [OK] Reset tamamlandi! Yeniden baslatmaniz onerilidir.
pause
goto :menu

:allnet
cls
echo  [*] Tum network tweaks uygulanıyor...
call :ping
call :qos
ipconfig /flushdns >nul 2>&1
echo  [OK] Tum tweakler uygulandi!
pause
goto :menu

:reset
cls
echo  [*] Varsayilana donuluyor...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global congestionprovider=default >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "10" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "20" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /f >nul 2>&1
netsh winsock reset >nul 2>&1
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
echo  [OK] Varsayilana donuldu!
pause
goto :menu

:info
cls
echo  --- TCP Ayarlari ---
netsh int tcp show global
echo.
echo  --- Guc Plani ---
powercfg /getactivescheme
echo.
pause
goto :menu

:banner
for %%C in (09 0A 0B 03 0D 05 0E 06 04 0C) do (
    color %%C
    cls
    echo.
    echo.
    echo  ============================================================
    echo        lerocxn  ^|  NETWORK OPTIMIZER
    echo  ============================================================
    ping 127.0.0.1 -n 1 -w 120 >nul
)
color 0A
goto :eof
