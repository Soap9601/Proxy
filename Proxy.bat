@echo off

:menu
cls
echo ===============================
echo Proxy Management Menu
echo ===============================
echo 1. Turn Proxy On
echo 2. Turn Proxy Off
echo 0. Exit
echo.
set /p choice=Enter your choice (0-2): 

if "%choice%"=="1" (
    call :turn_proxy_on
) else if "%choice%"=="2" (
    call :turn_proxy_off
) else if "%choice%"=="0" (
    exit /b 0
) else (
    echo Invalid choice. Please enter a number from 0 to 2.
    pause
    goto :menu
)

goto :menu

:turn_proxy_on
:: Check if proxy is already enabled
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable | findstr /i "ProxyEnable.*REG_DWORD.*1"
if %errorlevel%==0 (
    echo Proxy is already enabled. Cannot turn it on again.
    pause
    goto :menu
)

:: Define proxy server address and port
set proxyAddress=201.20.115.22
set proxyPort=8080

:: Set proxy for system-wide settings
echo Setting system-wide proxy settings...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d %proxyAddress%:%proxyPort% /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f
echo System-wide proxy set to %proxyAddress%:%proxyPort%
pause
goto :menu

:turn_proxy_off
:: Check if proxy is enabled
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable | findstr /i "ProxyEnable.*REG_DWORD.*1"
if %errorlevel%==1 (
    echo Proxy is not enabled. Cannot turn it off.
    pause
    goto :menu
)

:: Disable proxy
echo Disabling proxy settings...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f
echo Proxy settings disabled.
pause
goto :menu
