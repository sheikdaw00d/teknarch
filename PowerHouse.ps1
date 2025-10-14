# SHEIKLAB - Installer v2.0 (PowerShell Edition)
$host.UI.RawUI.WindowTitle = "SHEIKLAB - Installer v2.0"
Write-Host "=======================================================================" -ForegroundColor Green
Write-Host "  ######  ##     ## ######## #### ##    ## ##          ###    ########"
Write-Host " ##    ## ##     ## ##        ##  ##   ##  ##         ## ##   ##     ##"
Write-Host " ##       ##     ## ##        ##  ##  ##   ##        ##   ##  ##     ##"
Write-Host "  ######  ######### ######    ##  #####    ##       ##     ## ########"
Write-Host "       ## ##     ## ##        ##  ##  ##   ##       ######### ##     ##"
Write-Host " ##    ## ##     ## ##        ##  ##   ##  ##       ##     ## ##     ##"
Write-Host "  ######  ##     ## ######## #### ##    ## ######## ##     ## ########"
Write-Host "=======================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "WELCOME MR. SHEIK" -ForegroundColor Cyan
Start-Sleep -Seconds 5

# Setup begins
$logPath = "$env:TEMP\TechnarchInstallLog.txt"
"Technarch Setup Log - $(Get-Date)" | Out-File $logPath

# Admin check
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as Administrator!"
    Pause
    exit
}

# Install function
function Install-App {
    param (
        [string]$Id,
        [string]$Name
    )
    Write-Host "Installing $Name ..." -ForegroundColor Yellow
    winget install --id $Id -e --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$Name installed successfully!" -ForegroundColor Green
        "${Name}: Success" | Out-File $logPath -Append
    } else {
        Write-Host "Failed to install $Name" -ForegroundColor Red
        "${Name}: Failed" | Out-File $logPath -Append
    }
    Write-Host ""
}

# OEM Detection
$manufacturer = (Get-WmiObject -Class Win32_ComputerSystem).Manufacturer.Trim()
Write-Host "Detected OEM: $manufacturer" -ForegroundColor Cyan
"OEM Detected: $manufacturer" | Out-File $logPath -Append

switch -Wildcard ($manufacturer) {
    "*Dell*" {
        Install-App -Id "Dell.CommandUpdate" -Name "Dell Command | Update"
    }
    "*LENOVO*" {
        Install-App -Id "Lenovo.SystemUpdate" -Name "Lenovo System Update"
        Install-App -Id "9WZDNCRFJ4MV" -Name "Lenovo Vantage"
    }
    "*ASUS*" {
        Install-App -Id "Asus.ArmouryCrate" -Name "Asus Armoury Crate"
    }
    "*HP*" {
        Install-App -Id "HP.ImageAssistant" -Name "HP Image Assistant"
        Start-Process "https://support.hp.com/us-en/help/hp-support-assistant"
        Write-Host "HP Support Assistant launched in browser for manual install." -ForegroundColor Yellow
    }
    "*Acer*" {
        Start-Process "https://www.acer.com/support"
        Write-Host "Acer support page launched in browser for manual driver and utility access." -ForegroundColor Yellow
    }
    default {
        Write-Host "No OEM-specific tools required for: $manufacturer" -ForegroundColor Yellow
    }
}

# App list
$apps = @(
    @{ Id = "Microsoft.VCRedist.2005.x86"; Name = "Visual C++ 2005 x86" },
    @{ Id = "Microsoft.VCRedist.2008.x86"; Name = "Visual C++ 2008 x86" },
    @{ Id = "Microsoft.VCRedist.2010.x64"; Name = "Visual C++ 2010 x64" },
    @{ Id = "Microsoft.VCRedist.2010.x86"; Name = "Visual C++ 2010 x86" },
    @{ Id = "Microsoft.VCRedist.2012.x64"; Name = "Visual C++ 2012 x64" },
    @{ Id = "Microsoft.VCRedist.2012.x86"; Name = "Visual C++ 2012 x86" },
    @{ Id = "Microsoft.VCRedist.2013.x64"; Name = "Visual C++ 2013 x64" },
    @{ Id = "Microsoft.VCRedist.2013.x86"; Name = "Visual C++ 2013 x86" },
    @{ Id = "Microsoft.VCRedist.2015+.x64"; Name = "Visual C++ 2015–2022 x64" },
    @{ Id = "Microsoft.VCRedist.2015+.x86"; Name = "Visual C++ 2015–2022 x86" },

    @{ Id = "Microsoft.DotNet.DesktopRuntime.6"; Name = ".NET Desktop Runtime 6 (LTS)" },
    @{ Id = "Microsoft.DotNet.DesktopRuntime.8"; Name = ".NET Desktop Runtime 8 (LTS)" },
    @{ Id = "Microsoft.DotNet.AspNetCore.6"; Name = "ASP.NET Core Runtime 6 (LTS)" },
    @{ Id = "Microsoft.DotNet.AspNetCore.8"; Name = "ASP.NET Core Runtime 8 (LTS)" },

    @{ Id = "Microsoft.Office"; Name = "Microsoft 365 Apps for enterprise" },
    @{ Id = "Google.Chrome"; Name = "Google Chrome" },
    @{ Id = "Mozilla.Firefox"; Name = "Mozilla Firefox (en-US)" },
    @{ Id = "RustDesk.RustDesk"; Name = "RustDesk" },
    @{ Id = "AnyDesk.AnyDesk"; Name = "AnyDesk" },
    @{ Id = "PDFgear.PDFgear"; Name = "PDFgear" },
    @{ Id = "7zip.7zip"; Name = "7-Zip" },
    @{ Id = "VideoLAN.VLC"; Name = "VLC media player" },
    @{ Id = "Notepad++.Notepad++"; Name = "Notepad++" },
    @{ Id = "Intel.IntelDriverAndSupportAssistant"; Name = "Intel® Driver & Support Assistant" },
    @{ Id = "9NKSQGP7F2NH"; Name = "WhatsApp" },
    @{ Id = "Telegram.TelegramDesktop"; Name = "Telegram Desktop" },
    @{ Id = "SlackTechnologies.Slack"; Name = "Slack" },
    @{ Id = "Zoom.Zoom"; Name = "Zoom Workplace" }
)

# Run installs
foreach ($app in $apps) {
    Install-App -Id $app.Id -Name $app.Name
}

Write-Host ""
Write-Host "All installations attempted." -ForegroundColor Cyan
Pause

