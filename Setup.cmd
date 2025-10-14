@echo off
setlocal
color 0A
title SHEIKLAB - Installer v2.0
echo =======================================================================
echo   ######  ##     ## ######## #### ##    ## ##          ###    ########     
echo  ##    ## ##     ## ##        ##  ##   ##  ##         ## ##   ##     ##    
echo  ##       ##     ## ##        ##  ##  ##   ##        ##   ##  ##     ##    
echo   ######  ######### ######    ##  #####    ##       ##     ## ########     
echo        ## ##     ## ##        ##  ##  ##   ##       ######### ##     ##    
echo  ##    ## ##     ## ##        ##  ##   ##  ##       ##     ## ##     ##   
echo   ######  ##     ## ######## #### ##    ## ######## ##     ## ########   
echo =======================================================================
echo.                                                                                                  
echo WELCOME MR.SHEIK
Pause
timeout /t 5 /nobreak
echo.

:: ===== Check for Admin =====
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Please run this script as Administrator!
    pause
    exit /b
)

:: Function style installer
call :installApp Microsoft.VCRedist.2010.x64 "Microsoft Visual C++ 2010 x64"
call :installApp Microsoft.VCRedist.2010.x86 "Microsoft Visual C++ 2010 x86"
call :installApp Microsoft.VCRedist.2012.x64 "Microsoft Visual C++ 2012 x64"
call :installApp Microsoft.VCRedist.2012.x86 "Microsoft Visual C++ 2012 x86"
call :installApp Microsoft.VCRedist.2013.x64 "Microsoft Visual C++ 2013 x64"
call :installApp Microsoft.VCRedist.2013.x86 "Microsoft Visual C++ 2013 x86"
call :installApp Microsoft.VCRedist.2015+.x64 "Microsoft Visual C++ 2015-2022 x64"
call :installApp Microsoft.VCRedist.2015+.x86 "Microsoft Visual C++ 2015-2022 x86"
:: call :installApp Microsoft.VisualStudioCode "Microsoft Visual Studio Code"
:: call :installApp JetBrains.PyCharm.Community "PyCharm Community Edition"
call :installApp Microsoft.Office "Microsoft 365 Apps for enterprise"
:: call :installApp Apache.OpenOffice "OpenOffice"
call :installApp Google.Chrome "Google Chrome"
call :installApp Mozilla.Firefox "Mozilla Firefox (en-US)"
:: call :installApp Brave.Brave "Brave"
call :installApp RustDesk.RustDesk "RustDesk"
call :installApp AnyDesk.AnyDesk "AnyDesk"
call :installApp PDFgear.PDFgear "PDFgear"
:: call :installApp geeksoftwareGmbH.PDF24Creator "PDF24 Creator"
call :installApp 7zip.7zip "7-Zip"
call :installApp VideoLAN.VLC "VLC media player"
call :installApp Notepad++.Notepad++ "Notepad++"
call :installApp Intel.IntelDriverAndSupportAssistant "Intel® Driver & Support Assistant"
call :installApp Dell.CommandUpdate "Dell Command | Update"
:: call :installApp 9WZDNCRFJ4MV "Lenovo Vantage"
:: call :installApp Lenovo.SystemUpdate "Lenovo System Update"
:: call :installApp Asus.ArmouryCrate "Asus ArmouryCrate"
:: call :installApp Proton.ProtonVPN "Proton VPN"
:: call :installApp Fortinet.FortiClientVPN "FortiClient VPN"
:: call :installApp SonicWaLL.NetExtender "SonicWall NetExtender"
call :installApp 9NKSQGP7F2NH "WhatsApp"
:: call :installApp Telegram.TelegramDesktop "Telegram Desktop"
call :installApp SlackTechnologies.Slack "Slack"
:: call :installApp Microsoft.Teams "Microsoft Teams"
call :installApp Zoom.Zoom "Zoom Workplace"
:: call :installApp Cisco.Webex "Webex"
:: call :installApp OBSProject.OBSStudio "OBS Studio"
:: call :installApp PuTTY.PuTTY "PuTTy"

echo.
echo All installations attempted.
pause
exit /b

:installApp
echo Installing %2 ...
winget install --id %1 -e --accept-source-agreements --accept-package-agreements
if %ERRORLEVEL%==0 (
        echo %2 installed successfully!
    ) else (
        echo Failed to install %2
    )
    echo.
exit /b
