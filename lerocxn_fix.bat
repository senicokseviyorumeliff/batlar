@echo off
title CLEAN TWEAK v1.0
call :banner

:menu
cls
echo.
echo  ============================================================
echo   CLEAN TWEAK v1.0 - Windows 10/11 Optimizasyon
echo  ============================================================
echo.
echo   [1]  Ag Optimizasyonu (TCP/IP Tweaks)
echo   [2]  QoS Bant Genisligi Optimizasyonu
echo   [3]  DNS Temizleme ve Yenileme
echo   [4]  Gecici Dosyalari Temizle
echo   [5]  FPS Booster (Gereksiz Servisleri Durdur)
echo   [6]  TUM TWEAKLER (Hepsini Uygula)
echo   [7]  Tum Ayarlari Sifirla (Varsayilana Don)
echo   [8]  Mevcut Ag Ayarlarini Goster
echo   [9]  CIKIS
echo.
echo  ============================================================
echo.

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo  [HATA] Yonetici olarak calistirin!
    pause
    exit
)

set /p choice="Seciminizi yapin (1-9): "
if "%choice%"=="1" goto :network
if "%choice%"=="2" goto :qos
if "%choice%"=="3" goto :dns
if "%choice%"=="4" goto :cleaner
if "%choice%"=="5" goto :fps
if "%choice%"=="6" goto :all
if "%choice%"=="7" goto :reset
if "%choice%"=="8" goto :showinfo
if "%choice%"=="9" exit
goto :menu

:network
cls
echo  [*] Ag optimizasyonu...
netsh int tcp set heuristics disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global congestionprovider=ctcp >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpNoDelay" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /t REG_DWORD /d "0" /f >nul 2>&1
echo  [OK] Ag optimizasyonu tamamlandi!
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
netsh winsock reset catalog >nul 2>&1
echo  [OK] DNS temizlendi!
pause
goto :menu

:cleaner
cls
set /p confirm="Gecici dosyalar silinsin mi? (E/H): "
if /i "%confirm%" neq "E" goto :menu
del /s /f /q "%SystemRoot%\Temp\*" >nul 2>&1
del /s /f /q "%TEMP%\*" >nul 2>&1
del /s /f /q "%SystemRoot%\Prefetch\*" >nul 2>&1
del /s /f /q "%SystemRoot%\SoftwareDistribution\Download\*" >nul 2>&1
echo  [OK] Temizlik tamamlandi!
pause
goto :menu

:fps
cls
echo  [*] FPS boost uygulanıyor...
sc config XblAuthManager start= demand >nul 2>&1
sc config XboxNetApiSvc start= demand >nul 2>&1
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "2" /f >nul 2>&1
echo  [OK] FPS boost tamamlandi!
pause
goto :menu

:all
cls
echo  [*] Tum tweakler uygulanıyor...
call :network
call :qos
ipconfig /flushdns >nul 2>&1
nbtstat -R >nul 2>&1
echo  [OK] Tum tweakler uygulandi!
pause
goto :menu

:reset
cls
echo  [*] Varsayilana donuluyor...
netsh int tcp set heuristics enabled >nul 2>&1
netsh int tcp set global rss=default >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global congestionprovider=default >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "10" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "20" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /f >nul 2>&1
sc config XblAuthManager start= auto >nul 2>&1
sc config XboxNetApiSvc start= auto >nul 2>&1
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
echo  [OK] Varsayilana donuldu!
pause
goto :menu

:showinfo
cls
netsh int tcp show global
echo.
ipconfig | findstr /i "IPv4 Subnet Default DNS"
echo.
pause
goto :menu

:banner
for %%C in (09 0A 0B 03 0D 05 0E 06 04 0C 01 02) do (
    color %%C
    cls
    echo.
    echo  ============================================================
    echo   CLEAN TWEAK v1.0 - lerocxn
    echo  ============================================================
    ping 127.0.0.1 -n 1 -w 100 >nul
)
color 0A
goto :eof
