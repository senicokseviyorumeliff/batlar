@echo off
title lerocxn mc jvm - Feather Optimizer
call :banner

:menu
cls
echo.
echo  ============================================================
echo        lerocxn mc jvm  ^|  FEATHER OPTIMIZER
echo  ============================================================
echo.
echo   [1]  JVM Argumanlari Panoya Kopyala
echo   [2]  Minecraft Performans Tweaklerini Uygula
echo   [3]  Tum Ayarlari Sifirla
echo   [4]  Cikis
echo.
echo  ============================================================
echo.

set /p "sec=Seciminiz: "
if "%sec%"=="1" goto kopyala
if "%sec%"=="2" goto tweak
if "%sec%"=="3" goto sifirla
if "%sec%"=="4" exit
goto menu

:kopyala
cls
echo.
echo   [1] Standart (4-8GB RAM)
echo   [2] Yuksek RAM (8-16GB)
echo   [3] Dusuk RAM (2-4GB)
echo   [4] PvP ZGC
echo.
set /p "r=RAM secimi: "

if "%r%"=="1" set "JVM=-Xms4G -Xmx4G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=10 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"
if "%r%"=="2" set "JVM=-Xms8G -Xmx12G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=10 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=60 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"
if "%r%"=="3" set "JVM=-Xms2G -Xmx3G -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=20 -XX:G1MaxNewSizePercent=30 -XX:G1HeapRegionSize=4M -XX:SurvivorRatio=32 -XX:MaxTenuringThreshold=1"
if "%r%"=="4" set "JVM=-Xms6G -Xmx6G -XX:+UseZGC -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:ZUncommitDelay=60 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"

echo %JVM% | clip
echo  [OK] JVM argumanlari panoya kopyalandi!
echo  Feather: Settings ^> Java ^> JVM Arguments kismina yapistir.
pause
goto menu

:tweak
cls
echo  [*] Minecraft tweakler uygulanıyor...

net session >nul 2>&1
if %errorLevel% neq 0 (echo  [HATA] Yonetici gerekli! & pause & goto menu)

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpNoDelay" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
wmic process where name="javaw.exe" CALL setpriority "realtime" >nul 2>&1
netsh qos add policy "MC_JVM_Boost" app="javaw.exe" dscp=46 throttle-rate=-1 >nul 2>&1
ipconfig /flushdns >nul 2>&1
sc stop "DiagTrack" >nul 2>&1
sc stop "WSearch" >nul 2>&1
sc stop "SysMain" >nul 2>&1
echo  [OK] Tweakler uygulandi!
pause
goto menu

:sifirla
cls
echo  [*] Sifirlaniyor...
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpNoDelay" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "10" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "20" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /f >nul 2>&1
netsh qos delete policy "MC_JVM_Boost" >nul 2>&1
sc start "DiagTrack" >nul 2>&1
sc start "WSearch" >nul 2>&1
sc start "SysMain" >nul 2>&1
wmic process where name="javaw.exe" CALL setpriority "normal" >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo  [OK] Sifirlandi!
pause
goto menu

:banner
for %%C in (09 0A 0B 03 0D 05 0E 06 04 0C 01 02) do (
    color %%C
    cls
    echo.
    echo  ============================================================
    echo        lerocxn mc jvm  ^|  FEATHER OPTIMIZER
    echo  ============================================================
    ping 127.0.0.1 -n 1 -w 100 >nul
)
color 0B
goto :eof
