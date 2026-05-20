@echo off
setlocal enabledelayedexpansion
title lerocxn game optimizer
call :banner

:menu
cls
echo.
echo  ============================================================
echo        lerocxn  ^|  GAME OPTIMIZER
echo  ============================================================
echo.
echo   OYUN SEC:
echo   [1]  Minecraft         (Java / Bedrock)
echo   [2]  FiveM             (GTA:Online / RP)
echo   [3]  Feather Launcher  (Minecraft PvP)
echo   [4]  Genel Oyun Modu   (Her Oyun Icin)
echo.
echo   DIGER:
echo   [5]  Klavye Gecikme Testi
echo   [6]  Tum Ayarlari Sifirla
echo   [7]  Cikis
echo.
echo  ============================================================
echo.

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo  [HATA] Yonetici yetkisi gerekli!
    pause
    exit
)

set /p "choice=Seciminiz (1-7): "
if "%choice%"=="1" goto :minecraft
if "%choice%"=="2" goto :fivem
if "%choice%"=="3" goto :feather
if "%choice%"=="4" goto :general
if "%choice%"=="5" goto :kbtest
if "%choice%"=="6" goto :reset
if "%choice%"=="7" exit
goto :menu

:minecraft
cls
echo  [*] Minecraft optimizasyonu...
call :base_input
call :base_process
wmic process where name="javaw.exe" CALL setpriority "high priority" >nul 2>&1
wmic process where name="java.exe"  CALL setpriority "high priority" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\javaw.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpNoDelay" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo  [OK] Minecraft optimizasyonu tamamlandi!
pause
goto :menu

:fivem
cls
echo  [*] FiveM optimizasyonu...
call :base_input
call :base_process
wmic process where name="FiveM.exe" CALL setpriority "high priority" >nul 2>&1
wmic process where name="GTA5.exe" CALL setpriority "high priority" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
echo  [OK] FiveM optimizasyonu tamamlandi!
pause
goto :menu

:feather
cls
echo  [*] Feather Launcher optimizasyonu...
call :base_input
call :base_process
wmic process where name="javaw.exe" CALL setpriority "realtime" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\javaw.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "64" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1
echo  [OK] Feather optimizasyonu tamamlandi!
pause
goto :menu

:general
cls
echo  [*] Genel oyun modu...
call :base_input
call :base_process
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
sc config XblAuthManager start= demand >nul 2>&1
sc stop XblAuthManager >nul 2>&1
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo  [OK] Genel oyun modu aktif!
pause
goto :menu

:kbtest
cls
echo  --- Klavye Ayarlari ---
reg query "HKCU\Control Panel\Accessibility\Keyboard Response" 2>nul
echo.
echo  --- Mouse Ayarlari ---
reg query "HKCU\Control Panel\Mouse" /v "MouseSpeed" 2>nul
echo.
pause
goto :menu

:reset
cls
echo  [*] Sifirlaniyor...
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatDelay" /t REG_SZ /d "1000" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "1" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\javaw.exe\PerfOptions" /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "1" /f >nul 2>&1
sc config XblAuthManager start= auto >nul 2>&1
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
echo  [OK] Sifirlandi!
pause
goto :menu

:base_input
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatDelay" /t REG_SZ /d "200" /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatRate" /t REG_SZ /d "6" /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "BounceTime" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1
goto :eof

:base_process
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d "1" /f >nul 2>&1
goto :eof

:banner
for %%C in (0C 04 06 0E 0A 02 0B 03 01 09 05 0D) do (
    color %%C
    cls
    echo.
    echo  ============================================================
    echo        lerocxn  ^|  GAME OPTIMIZER
    echo  ============================================================
    ping 127.0.0.1 -n 1 -w 120 >nul
)
color 0A
goto :eof
