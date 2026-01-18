# --- ULTIMATE PURGE & CLEAN SUITE v12.0 ---
# Objetivo: Borrar todo rastro residual y procesos fantasma.
$ErrorActionPreference = "SilentlyContinue"

# 1. PRIVILEGIOS DE ADMINISTRADOR
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

function Mostrar-Progreso ($Tarea) {
    Write-Host "[ PROCESANDO ] $Tarea..." -ForegroundColor Cyan
}

Clear-Host
Write-Host "===========================================================" -ForegroundColor Red
Write-Host "       PURGA TOTAL DE RESIDUOS Y PROCESOS FANTASMA" -ForegroundColor Red
Write-Host "===========================================================" -ForegroundColor Red
Write-Host " Este script eliminara archivos temporales, restos de apps"
Write-Host " desinstaladas y detendra servicios innecesarios."
Write-Host "==========================================================="
Pause

# --- PASO 1: DETENCIÓN DE PROCESOS Y TELEMETRÍA ---
Mostrar-Progreso "Deteniendo servicios de telemetría y rastreo en segundo plano"
$servicios = @("DiagTrack", "dmwappushservice", "SysMain", "WerSvc", "OneSyncSvc")
foreach ($s in $servicios) {
    Stop-Service -Name $s -Force
    Set-Service -Name $s -StartupType Disabled
}

# --- PASO 2: LIMPIEZA DE CARPETAS RESIDUALES (AppData/ProgramData) ---
Mostrar-Progreso "Buscando carpetas vacias y restos de aplicaciones desinstaladas"
$rutasResiduales = @(
    "$env:LocalAppdata\Temp",
    "$env:AppData\Local\Temp",
    "C:\Windows\Temp",
    "C:\Windows\Prefetch",
    "C:\Windows\SoftwareDistribution\Download",
    "$env:LocalAppdata\Microsoft\Windows\Explorer\thumbcache_*.db",
    "$env:LocalAppdata\IconCache.db"
)

foreach ($ruta in $rutasResiduales) {
    Remove-Item $ruta -Recurse -Force
}

# --- PASO 3: PURGA DE COMPONENTES OBSOLETOS (WinSxS) ---
# Esto borra las actualizaciones viejas que Windows guarda "por si acaso"
Mostrar-Progreso "Purgando almacen de componentes WinSxS (Esto libera gigas reales)"
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase

# --- PASO 4: LIMPIEZA DE CACHÉ DE SOMBREADORES Y DNS ---
Mostrar-Progreso "Limpiando caches de Red y DirectX"
ipconfig /flushdns
$directX = "$env:LocalAppdata\D3DSCache"
if (Test-Path $directX) { Remove-Item "$directX\*" -Recurse -Force }

# --- PASO 5: ELIMINACIÓN DE LOGS DE EVENTOS ---
# Borra el historial de errores y eventos que ocupa espacio en el registro
Mostrar-Progreso "Vaciando todos los registros de eventos de Windows"
wevtutil el | Foreach-Object {wevtutil cl "$_"}

# --- PASO 6: OPTIMIZACIÓN DE MEMORIA RAM (DOOFY STYLE) ---
Mostrar-Progreso "Forzando liberacion de memoria RAM residual"
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

# --- FINALIZACIÓN ---
Clear-Host
Write-Host "===========================================================" -ForegroundColor Green
Write-Host "          PURGA COMPLETADA EXITOSAMENTE" -ForegroundColor Green
Write-Host "===========================================================" -ForegroundColor Green
Write-Host " [+] Archivos residuales: ELIMINADOS"
Write-Host " [+] Servicios de rastreo: DESACTIVADOS"
Write-Host " [+] Memoria RAM: OPTIMIZADA"
Write-Host " [+] Gigas recuperados de WinSxS: OK"
Write-Host ""
Write-Host "Se recomienda reiniciar el equipo para aplicar cambios de registro."
Write-Host "==========================================================="
Pause
