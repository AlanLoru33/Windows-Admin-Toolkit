@echo off
title INMUNIZADOR DE DISPOSITIVOS EXTRAIBLES
color 0e
cls

echo ======================================================
echo    INMUNIZADOR DE PENDRIVES - MODO SEGURIDAD
echo ======================================================
echo.
set /p letra=Introduzca la letra de su pendrive (Ejemplo F): 
set unidad=%letra%:

if not exist %unidad%\ (
    echo [ERROR] La unidad %unidad% no existe.
    pause
    exit
)

echo.
echo 1. ELIMINANDO ATRIBUTOS DE VIRUS (RECUPERANDO ARCHIVOS)...
:: Quita atributos de oculto, sistema y lectura para ver archivos que el virus escondio
attrib -r -a -s -h %unidad%\*.* /s /d

echo 2. LIMPIANDO ACCESOS DIRECTOS FALSOS...
del %unidad%\*.lnk /q /f
del %unidad%\*.vbs /q /f
del %unidad%\*.exe /q /f

echo 3. CREANDO ESTRUCTURA DE SEGURIDAD...
:: Crea la carpeta donde guardaras tus cosas
if not exist "%unidad%\DATOS_SEGUROS" mkdir "%unidad%\DATOS_SEGUROS"

echo 4. APLICANDO PERMISOS DE INMUNIZACION (NTFS)...
:: Deniega escritura en la RAIZ para todos, pero permite lectura
icacls %unidad%\ /deny "Todos":(W)
:: Permite CONTROL TOTAL solo en la carpeta DATOS_SEGUROS
icacls "%unidad%\DATOS_SEGUROS" /grant "Todos":(F)

echo.
echo ======================================================
echo    PROCESO COMPLETADO
echo ======================================================
echo IMPORTANTE: 
echo - Ahora NO puedes guardar nada en la raiz del pendrive.
echo - Guarda todos tus archivos dentro de "DATOS_SEGUROS".
echo - Los virus no podran crear accesos directos ni ocultar carpetas.
echo ======================================================
pause