<#
  Teknarch Endpoint Deployment — Powered by SHEIKLAB
  Version: 3.6
  Author: Sheik Dawood
  Description: Modular, OEM-aware endpoint deployment script for Technarch clients across the UAE.
  Last Updated: 2025-10-17
#>

# 🖥️ Set PowerShell Window Title and Welcome Banner
$host.UI.RawUI.WindowTitle = "Teknarch Endpoint Deployment — Powered by SHEIKLAB"
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
Write-Host "WELCOME MR. SHEIK DAWOOD" -ForegroundColor Cyan
Start-Sleep -Seconds 5

# 📁 Create Log File
$logPath = "$env:TEMP\TeknarchInstallLog.txt"
"Teknarch Setup Log - $(Get-Date)" | Out-File $logPath

# 🧠 Gather System Info
$pcName   = $env:COMPUTERNAME
$userName = $env:USERNAME
$model    = (Get-WmiObject -Class Win32_ComputerSystem).Model
$ramGB    = [math]::Round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
$cpu      = (Get-WmiObject -Class Win32_Processor).Name
$gpu      = (Get-WmiObject -Class Win32_VideoController)[0].Name

@"
System Info:
PC Name     : $pcName
Username    : $userName
Model       : $model
RAM         : $ramGB GB
CPU         : $cpu
GPU         : $gpu
"@ | Out-File $logPath -Append

Write-Host ""
Write-Host "==================== SYSTEM PROFILE ====================" -ForegroundColor Cyan
Write-Host " PC Name     : $pcName"
Write-Host " Username    : $userName"
Write-Host " Model       : $model"
Write-Host " RAM         : $ramGB GB"
Write-Host " CPU         : $cpu"
Write-Host " GPU         : $gpu"
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""
Start-Sleep -Seconds 3

# 🔐 Admin Rights Check
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as Administrator!"
    Pause
    exit
}

# 📦 Generic Winget Installer
function Install-App {
    param ([string]$Id, [string]$Name)
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

# 🛠️ HP Support Assistant Installer (sp163238)
function Install-HPSupportAssistant {
    $url = "https://ftp.hp.com/pub/softpaq/sp163001-163500/sp163238.exe"
    $path = "$env:TEMP\HP_Support_Assistant.exe"
    Write-Host "Downloading HP Support Assistant..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $url -OutFile $path
        Start-Process -FilePath $path -ArgumentList "/S" -Wait
        Write-Host "HP Support Assistant installed successfully." -ForegroundColor Green
        "HP Support Assistant: Success" | Out-File $logPath -Append
        Remove-Item $path -Force
    } catch {
        Write-Warning "HP Support Assistant install failed: $($_.Exception.Message)"
        "HP Support Assistant: Failed" | Out-File $logPath -Append
    }
}

# 🛠️ AMD Adrenalin Driver Installer
function Install-AMDAdrenalinDriver {
    $url = "https://drivers.amd.com/drivers/installer/25.10/whql/amd-software-adrenalin-edition-25.9.1-minimalsetup-250901_web.exe"
    $path = "$env:TEMP\amd-adrenalin-setup.exe"
    Write-Host "Downloading AMD Adrenalin Edition..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $url -OutFile $path
        Start-Process -FilePath $path -ArgumentList "/S" -Wait
        Write-Host "AMD Adrenalin driver installed successfully." -ForegroundColor Green
        "AMD Adrenalin: Success" | Out-File $logPath -Append
        Remove-Item $path -Force
    } catch {
        Write-Warning "AMD Adrenalin install failed: $($_.Exception.Message)"
        "AMD Adrenalin: Failed" | Out-File $logPath -Append
    }
}

# 🛠️ NVIDIA App Installer
function Install-NvidiaApp {
    $url = "https://us.download.nvidia.com/nvapp/client/11.0.5.266/NVIDIA_app_v11.0.5.266.exe"
    $path = "$env:TEMP\NVIDIA_app.exe"
    Invoke-WebRequest -Uri $url -OutFile $path
    Start-Process -FilePath $path -ArgumentList "/S" -Wait
    Remove-Item $path -Force
    "NVIDIA App: Installed" | Out-File $logPath -Append
}

# 🛠️ Gigabyte Control Center Installer
function Install-GigabyteControlCenter {
    $url = "https://download.gigabyte.com/FileList/Utility/GCC_24.07.02.01.zip"
    $zipPath = "$env:TEMP\GCC.zip"
    $extractPath = "$env:TEMP\GCC"
    Invoke-WebRequest -Uri $url -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
    Start-Process "$extractPath\setup.exe" -ArgumentList "/S" -Wait
    Remove-Item $zipPath -Force
    Remove-Item $extractPath -Recurse -Force
    "Gigabyte Control Center: Installed" | Out-File $logPath -Append
}

# 🏷️ OEM Detection and Install
$manufacturer = (Get-WmiObject -Class Win32_ComputerSystem).Manufacturer.Trim()
Write-Host "Detected OEM: $manufacturer" -ForegroundColor Cyan
switch -Wildcard ($manufacturer) {
    "*Dell*"     { Install-App -Id "Dell.CommandUpdate" -Name "Dell Command | Update" }
    "*LENOVO*"   { Install-App -Id "Lenovo.SystemUpdate" -Name "Lenovo System Update"
                   Install-App -Id "9WZDNCRFJ4MV" -Name "Lenovo Vantage" }
    "*ASUS*"     { Install-App -Id "Asus.ArmouryCrate" -Name "Asus Armoury Crate" }
    "*HP*"       { Install-HPSupportAssistant }
    "*Acer*"     { Install-App -Id "9P8BB54NQNQ4" -Name "Acer Care Center" }
    "*Gigabyte*" { Install-GigabyteControlCenter }
    default      { Write-Host "No OEM-specific tools required for: $manufacturer" -ForegroundColor Yellow }
}

# 🧠 CPU Detection
if ($cpu -like "*AMD*") {
    Install-AMDAdrenalinDriver
}
if ($cpu -like "*Intel*") {
    Install-App -Id "Intel.IntelDriverAndSupportAssistant" -Name "Intel® Driver & Support Assistant"
}

# 🎮 GPU Detection
if ($gpu -like "*NVIDIA*") {
    Install-NvidiaApp
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
    @{ Id = "Microsoft.VCRedist.2015+.x64"; Name = "Visual C++ 2015 - 2022 x64" },
    @{ Id = "Microsoft.VCRedist.2015+.x86"; Name = "Visual C++ 2015 - 2022 x86" },

    @{ Id = "Microsoft.DotNet.DesktopRuntime.6"; Name = ".NET Desktop Runtime 6 (LTS)" },
    @{ Id = "Microsoft.DotNet.DesktopRuntime.8"; Name = ".NET Desktop Runtime 8 (LTS)" },
    @{ Id = "Microsoft.DotNet.AspNetCore.6"; Name = "ASP.NET Core Runtime 6 (LTS)" },
    @{ Id = "Microsoft.DotNet.AspNetCore.8"; Name = "ASP.NET Core Runtime 8 (LTS)" },

    @{ Id = "Microsoft.Office"; Name = "Microsoft 365 Apps for enterprise" },

    @{ Id = "Google.Chrome"; Name = "Google Chrome" },
    @{ Id = "Mozilla.Firefox"; Name = "Mozilla Firefox (en-US)" },
    @{ Id = "Brave.Brave"; Name = "Brave" },

    @{ Id = "RustDesk.RustDesk"; Name = "RustDesk" },
    @{ Id = "AnyDesk.AnyDesk"; Name = "AnyDesk" },

    @{ Id = "PDFgear.PDFgear"; Name = "PDFgear" },
    @{ Id = "7zip.7zip"; Name = "7-Zip" },
    # @{ Id = "VideoLAN.VLC"; Name = "VLC media player" },
    # @{ Id = "Notepad++.Notepad++"; Name = "Notepad++" },

    @{ Id = "9NKSQGP7F2NH"; Name = "WhatsApp" },
    # @{ Id = "Telegram.TelegramDesktop"; Name = "Telegram Desktop" },
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
