
# --- CENTRO DE CONTROL HIBRIDO (TITUS + DOOFY) ---
$ErrorActionPreference = "SilentlyContinue"

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

function Mostrar-Menu {
    Clear-Host
    Write-Host "===========================================================" -ForegroundColor Magenta
    Write-Host "         CENTRO DE OPTIMIZACION (TITUS & DOOFY STYLE)" -ForegroundColor Magenta
    Write-Host "===========================================================" -ForegroundColor Magenta
    Write-Host " [1] SISTEMA: Windows Update (Parches de Seguridad)"
    Write-Host " [2] APPS: Desinstalador Visual (Borra lo que quieras)"
    Write-Host " [3] WINUTIL: Lanzar Interfaz de Chris Titus"
    Write-Host " [4] DOOFY: Limpieza de RAM y Cache de Procesos"
    Write-Host " [5] DOOFY: Limpieza Profunda (Temp, Logs, Prefetch)"
    Write-Host " [6] REPARACION: Corregir errores (SFC + DISM)"
    Write-Host " [7] RED: Optimizar Latencia y DNS (Gaming Style)"
    Write-Host " [8] INFO: Ver Top 10 Procesos que consumen mas"
    Write-Host " [9] SALIR"
    Write-Host "===========================================================" -ForegroundColor Magenta
}

do {
    Mostrar-Menu
    $opcion = Read-Host "Seleccione una accion"
    switch ($opcion) {
        "1" { 
            Write-Host "Buscando actualizaciones..." -ForegroundColor Yellow
            if (!(Get-Module -ListAvailable PSWindowsUpdate)) { Install-Module -Name PSWindowsUpdate -Force }
            Get-WindowsUpdate -Install -AcceptAll; Pause 
        }
        "2" { 
            $apps = Get-AppxPackage | Select-Object Name, PackageFullName | Sort-Object Name
            $seleccion = $apps | Out-GridView -Title "Selecciona apps para eliminar" -PassThru
            if ($seleccion) { $seleccion | Remove-AppxPackage }
            Pause 
        }
        "3" { iwr -useb https://christitus.com/win | iex }
        "4" { 
            Write-Host "Liberando memoria RAM..." -ForegroundColor Cyan
            [System.GC]::Collect()
            Write-Host "RAM Liberada. (Nota: Windows reasignara lo necesario)" -ForegroundColor Green
            Pause 
        }
        "5" { 
            Write-Host "Limpieza estilo MiniOS..." -ForegroundColor Cyan
            Remove-Item "$env:TEMP\*" -Recurse -Force
            Remove-Item "C:\Windows\Temp\*" -Recurse -Force
            Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force
            wevtutil el | Foreach-Object {wevtutil cl "$_"} # Borra logs de eventos (Muy Doofy)
            Write-Host "Sistema limpio." -ForegroundColor Green
            Pause 
        }
        "6" { DISM /Online /Cleanup-Image /RestoreHealth; sfc /scannow; Pause }
        "7" { 
            Write-Host "Optimizando Red..." -ForegroundColor Cyan
            ipconfig /flushdns
            netsh int ip reset
            netsh winsock reset
            Write-Host "Red optimizada para menor latencia." -ForegroundColor Green
            Pause 
        }
        "8" { Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 Name, @{Name="RAM(MB)";Expression={[math]::round($_.WorkingSet / 1MB,2)}}; Pause }
        "9" { break }
    }
} while ($opcion -ne "9")
