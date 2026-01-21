@echo off
title INFRASTRUCTURE & AUDIT SUPER CONSOLE v3.0 - PRO MODE
setlocal enabledelayedexpansion
:: Chequeo de privilegios de Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] DEBES EJECUTAR ESTA CONSOLA COMO ADMINISTRADOR.
    pause
    exit
)

:MENU
cls
color 0B
echo ===========================================================================
echo            SUPER CONSOLA DE AUDITORIA, REDES Y CIBERSEGURIDAD
echo ===========================================================================
echo  [ RED Y CONECTIVIDAD ]             [ SEGURIDAD Y AUDITORIA ]
echo  1. Test EMS (10.1.78.22)           8. Ver Conexiones Activas (ESTABLISHED)
echo  2. IP/DNS/Gateway Detallado        9. Puertos Escuchando (LISTENING)
echo  3. Trazado de Ruta (MTR-style)    10. Buscar Puertos Forti/VPN/EMS
echo  4. Reset Stack TCP/IP/Winsock     11. Matar Proceso (PID/Nombre)
echo  5. Escaneo Rápido Red Local       12. Auditoría de Usuarios y Admins
echo  6. Tabla ARP (Dispositivos)       13. Ver Servicios en Ejecución
echo  7. Liberar/Renovar IP             14. Listar Apps de Inicio (Autorun)
echo ---------------------------------------------------------------------------
echo  [ SISTEMA Y HARDWARE ]             [ DISCO Y MANTENIMIENTO ]
echo 15. Info Hardware (Serial/CPU/RAM) 20. Reparar Archivos (SFC /Scannow)
echo 16. Estado de Batería (Reporte)    21. Ver Espacio y Particiones
echo 17. Ver Log de Eventos (Errores)   22. Limpieza Profunda Temporales
echo 18. Monitor de Recursos (Realtime) 23. Verificar Errores de Disco (CHKDSK)
echo 19. Exportar Drivers Instalados    24. Optimizar/Defragmentar Disco
echo ---------------------------------------------------------------------------
echo  [99] REINICIAR CONSOLA             [0] SALIR
echo ===========================================================================
set /p opt=" >> Seleccione una opcion: "

if "%opt%"=="1" goto EMS
if "%opt%"=="2" goto IP
if "%opt%"=="3" goto TRACE
if "%opt%"=="4" goto NETRESET
if "%opt%"=="5" goto SCANRED
if "%opt%"=="6" goto ARP
if "%opt%"=="7" goto IPREFRESH
if "%opt%"=="8" goto ESTABLISHED
if "%opt%"=="9" goto PORTS
if "%opt%"=="10" goto FORTI
if "%opt%"=="11" goto KILL
if "%opt%"=="12" goto USERS
if "%opt%"=="13" goto SERVICES
if "%opt%"=="14" goto STARTUP
if "%opt%"=="15" goto HARDWARE
if "%opt%"=="16" goto BATT
if "%opt%"=="17" goto EVENTS
if "%opt%"=="18" goto MONITOR
if "%opt%"=="19" goto DRIVERS
if "%opt%"=="20" goto SFC
if "%opt%"=="21" goto DISK
if "%opt%"=="22" goto CLEAN
if "%opt%"=="23" goto CHK
if "%opt%"=="24" goto DEFRAG
if "%opt%"=="99" goto MENU
if "%opt%"=="0" exit
goto MENU

:: --- SECCION RED ---
:EMS
cls
echo [TEST EMS 10.1.78.22]
powershell -Command "$t = New-Object Net.Sockets.TcpClient; try { $t.Connect('10.1.78.22', 2222); Write-Host 'CONEXION EXITOSA AL PUERTO 2222' -ForegroundColor Green } catch { Write-Host 'FALLO: PUERTO CERRADO O RED INALCANZABLE' -ForegroundColor Red }"
pause
goto MENU

:IP
cls
ipconfig /all
echo.
echo [GEO-IP EXTERNA]
powershell -Command "Invoke-RestMethod http://ip-api.com/json | Select-Object as, query, city, country"
pause
goto MENU

:TRACE
cls
set /p target="Ingrese IP o Dominio para trazar: "
tracert %target%
pause
goto MENU

:NETRESET
cls
echo Reseteando interfaces y DNS...
netsh int ip reset >nul
netsh winsock reset >nul
ipconfig /flushdns >nul
echo [OK] Reset completado. Reinicie para efectividad total.
pause
goto MENU

:SCANRED
cls
echo Escaneando dispositivos en el segmento local...
for /L %%i in (1,1,254) do start /b ping -n 1 -w 100 192.168.1.%%i | find "Reply"
echo (Si tu red no es 192.168.1.x, edita el comando en el .bat)
pause
goto MENU

:ARP
cls
arp -a
pause
goto MENU

:IPREFRESH
cls
ipconfig /release
ipconfig /renew
echo Direccion IP renovada.
pause
goto MENU

:: --- SECCION SEGURIDAD ---
:ESTABLISHED
cls
echo [CONEXIONES ACTIVAS]
netstat -ano | findstr "ESTABLISHED"
pause
goto MENU

:PORTS
cls
echo [PUERTOS EN ESCUCHA]
netstat -ano | findstr "LISTENING"
pause
goto MENU

:FORTI
cls
echo Buscando servicios/puertos Fortinet...
netstat -ano | findstr "443 10443 8013 514"
pause
goto MENU

:KILL
cls
set /p pid="Ingrese el PID o Nombre (ej: proceso.exe): "
taskkill /F /IM %pid% 2>nul || taskkill /F /PID %pid%
pause
goto MENU

:USERS
cls
echo [USUARIOS LOCALES]
net user
echo.
echo [ADMINISTRADORES]
net localgroup Administradores
pause
goto MENU

:SERVICES
cls
echo [SERVICIOS EN EJECUCION]
net start
pause
goto MENU

:STARTUP
cls
wmic startup get caption,command
pause
goto MENU

:: --- SECCION SISTEMA ---
:HARDWARE
cls
echo [SISTEMA]
wmic computersystem get model,name,totalphysicalmemory
echo [BIOS]
wmic bios get serialnumber, smbiosbiosversion
echo [CPU]
wmic cpu get name, MaxClockSpeed
pause
goto MENU

:BATT
cls
powercfg /batteryreport /output "%userprofile%\Desktop\battery_report.html"
echo Reporte generado en el Escritorio.
start %userprofile%\Desktop\battery_report.html
pause
goto MENU

:EVENTS
cls
echo Mostrando ultimos 10 errores graves en el registro de Sistema:
wevtutil qe System /c:10 /rd:true /f:text /q:"*[System[(Level=2)]]"
pause
goto MENU

:MONITOR
cls
echo Abriendo Monitor de Recursos y Rendimiento...
resmon
pause
goto MENU

:DRIVERS
cls
echo Exportando lista de drivers a drivers.txt...
driverquery > %userprofile%\Desktop\drivers.txt
echo Lista guardada en el escritorio.
pause
goto MENU

:: --- SECCION DISCO ---
:SFC
cls
echo Ejecutando reparador de integridad...
sfc /scannow
pause
goto MENU

:DISK
cls
wmic logicaldisk get caption,size,freespace,filesystem
pause
goto MENU

:CLEAN
cls
echo Limpiando temporales y cache...
del /s /f /q %temp%\*.* >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
echo [OK] Limpieza basica terminada.
pause
goto MENU

:CHK
cls
echo Verificando disco C: (Solo lectura)
chkdsk C:
pause
goto MENU

:DEFRAG
cls
echo Optimizando unidades de disco...
defrag C: /O
pause
goto MENU