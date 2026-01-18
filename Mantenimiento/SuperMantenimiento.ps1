# --- CENTRO DE MANTENIMIENTO ---
$ErrorActionPreference = "SilentlyContinue"

# 1. Forzar Administrador (Ruta protegida con comillas)
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

try {
    function Mostrar-Menu {
        Clear-Host
        Write-Host "===========================================================" -ForegroundColor Cyan
        Write-Host "             CENTRO DE CONTROL TOTAL - WINDOWS" -ForegroundColor Cyan
        Write-Host "===========================================================" -ForegroundColor Cyan
        Write-Host " [1] SISTEMA: Actualizaciones"
        Write-Host " [2] APPS: Desinstalador Visual (Seleccion manual)"
        Write-Host " [3] APPS: Eliminar Bloatware Basico"
        Write-Host " [4] HERRAMIENTA: WinUtil (Chris Titus)"
        Write-Host " [5] LIMPIEZA: Temporales y Cache"
        Write-Host " [6] REPARACION: SFC y DISM"
        Write-Host " [7] RED: Optimizar DNS y Red"
        Write-Host " [8] RENDIMIENTO: Ver procesos RAM"
        Write-Host " [9] SALIR"
        Write-Host "===========================================================" -ForegroundColor Cyan
    }

    do {
        Mostrar-Menu
        $opcion = Read-Host "Elija una opcion [1-9]"
        switch ($opcion) {
            "1" { 
                Write-Host "Verificando modulo..." -ForegroundColor Yellow
                if (!(Get-Module -ListAvailable PSWindowsUpdate)) { Install-Module -Name PSWindowsUpdate -Force -Confirm:$false }
                Get-WindowsUpdate -Install -AcceptAll
                Pause 
            }
            "2" { 
                Write-Host "Cargando lista..." -ForegroundColor Yellow
                $seleccion = Get-AppxPackage | Select-Object Name, PackageFullName | Sort-Object Name | Out-GridView -Title "Selecciona y presiona OK" -PassThru
                if ($seleccion) { $seleccion | Remove-AppxPackage; Write-Host "Proceso terminado" }
                Pause 
            }
            "3" { 
                Write-Host "Borrando bloatware..." -ForegroundColor Yellow
                Get-AppxPackage *Bing*,*Zune*,*People*,*YourPhone*,*CommunicationsApps* | Remove-AppxPackage
                Pause 
            }
            "4" { iwr -useb https://christitus.com/win | iex }
            "5" { 
                Remove-Item "$env:TEMP\*" -Recurse -Force
                Write-Host "Temporales de usuario limpios." -ForegroundColor Green
                Pause 
            }
            "6" { 
                Write-Host "Reparando imagen..." -ForegroundColor Yellow; DISM /Online /Cleanup-Image /RestoreHealth
                Write-Host "Reparando archivos..." -ForegroundColor Yellow; sfc /scannow
                Pause 
            }
            "7" { ipconfig /flushdns; netsh winsock reset; Write-Host "Red reseteada"; Pause }
            "8" { Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 Name, @{Name="RAM(MB)";Expression={[math]::round($_.WorkingSet / 1MB,2)}}; Pause }
            "9" { break }
        }
    } while ($opcion -ne "9")
}
catch {
    Write-Host "Error critico: $($_.Exception.Message)" -ForegroundColor Red
    Pause
}
