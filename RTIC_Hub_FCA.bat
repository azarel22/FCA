@echo off
:: ==========================================
:: Creado por: Eichhh
:: Versión: 9.3.10 (Prueba lista)
:: ==========================================

chcp 65001 >nul

:: ==========================================
:: CONFIGURACIÓN DE AUTO-ACTUALIZACIÓN
:: ==========================================
:: IMPORTANTE: Modifica estos valores según tu repositorio
set "GITHUB_USER=azarel22"
set "GITHUB_REPO=FCA"
set "GITHUB_BRANCH=main"
set "SCRIPT_NAME=RTIC_Hub_FCA.bat"
set "VERSION_ACTUAL=9.3.10"
:: ==========================================

:: --- DEFINICIÓN DE COLORES ---
:: Definimos el caracter ESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"
:: --- PALETA DE COLORES ---
set "CW=%ESC%[38;2;255;255;255m"
set "CH=%ESC%[48;2;255;150;0m%ESC%[38;2;0;0;0m"
set "RST=%ESC%[0m"
set "CG=%ESC%[90m"
set "P141=%ESC%[38;5;141m"
set "R_ERR=%ESC%[91m"
set "CYAN=%ESC%[96m"
set "ORANGE=%ESC%[38;5;208m"
set "GREEN=%ESC%[92m"
:: -----------------------------------------------

title RTIC_HUB_FCA (Verificando actualizaciones...)

:: ==========================================
:: VERIFICAR ACTUALIZACIONES AL INICIO
:: ==========================================
if "%1"=="skipupdate" goto :SKIP_UPDATE_CHECK

cls
echo.
echo %CYAN%[AUTO-UPDATE] Verificando actualizaciones...%RST%
echo.

:: Crear carpeta temporal si no existe
if not exist "%TEMP%\RTIC_Updates" mkdir "%TEMP%\RTIC_Updates" >nul 2>&1

:: Descargar archivo de versión desde GitHub
echo %CG%  - Consultando repositorio GitHub...%RST%
curl -L -s -f "https://raw.githubusercontent.com/azarel22/FCA/refs/heads/main/version.txt" -o "%TEMP%\RTIC_Updates\version.txt" 2>nul

if errorlevel 1 (
    echo %ORANGE%  [AVISO] No se pudo verificar actualizaciones.%RST%
    echo %CG%  Continuando con version actual: %VERSION_ACTUAL%%RST%
    timeout /t 2 /nobreak >nul
    goto :SKIP_UPDATE_CHECK
)

:: Leer versión desde el archivo descargado
set "VERSION_REMOTA="
for /f "usebackq tokens=*" %%a in ("%TEMP%\RTIC_Updates\version.txt") do (
    set "VERSION_REMOTA=%%a"
    goto :version_leida
)
:version_leida

if "%VERSION_REMOTA%"=="" (
    echo %ORANGE%  [AVISO] No se pudo leer la version remota.%RST%
    timeout /t 2 /nobreak >nul
    goto :SKIP_UPDATE_CHECK
)

echo %CG%  - Version actual: %VERSION_ACTUAL%%RST%
echo %CG%  - Version disponible: %VERSION_REMOTA%%RST%
echo.

:: Comparar versiones
if "%VERSION_ACTUAL%"=="%VERSION_REMOTA%" (
    echo %GREEN%  [OK] Ya tienes la ultima version instalada.%RST%
    timeout /t 2 /nobreak >nul
    goto :SKIP_UPDATE_CHECK
)

:: Nueva versión disponible
echo %GREEN%╔════════════════════════════════════════════════════════════╗%RST%
echo %GREEN%║      ¡NUEVA VERSION DISPONIBLE!                           ║%RST%
echo %GREEN%║                                                            ║%RST%
echo %GREEN%║  Version actual:      %VERSION_ACTUAL%                               ║%RST%
echo %GREEN%║  Nueva version:       %VERSION_REMOTA%                               ║%RST%
echo %GREEN%║                                                            ║%RST%
echo %GREEN%╚════════════════════════════════════════════════════════════╝%RST%
echo.
echo %CYAN%¿Deseas actualizar ahora?%RST%
echo.
echo    [1] SI - Descargar e instalar actualizacion
echo    [2] NO - Continuar con la version actual
echo.
set /p update_choice="%CYAN%Selecciona una opcion: %RST%"

if not "%update_choice%"=="1" (
    echo.
    echo %ORANGE%[INFO] Actualizacion omitida. Continuando...%RST%
    timeout /t 2 /nobreak >nul
    goto :SKIP_UPDATE_CHECK
)

:: Proceder con la actualización
goto :PROCESAR_ACTUALIZACION

:PROCESAR_ACTUALIZACION
cls
echo.
echo %GREEN%════════════════════════════════════════════════════════════%RST%
echo %GREEN%            ACTUALIZANDO RTIC HUB FCA%RST%
echo %GREEN%════════════════════════════════════════════════════════════%RST%
echo.

:: Obtener ruta completa del script actual
set "SCRIPT_PATH=%~f0"
set "SCRIPT_DIR=%~dp0"

echo %CG%[1/4] Descargando nueva version...%RST%
curl -L -s -f "https://raw.githubusercontent.com/azarel22/FCA/refs/heads/main/RTIC_Hub_FCA.bat" -o "%TEMP%\RTIC_Updates\nueva_version.bat"

if errorlevel 1 (
    echo.
    echo %R_ERR%[ERROR] No se pudo descargar la actualizacion.%RST%
    echo %ORANGE%Verifica tu conexion a internet.%RST%
    echo.
    pause
    goto :SKIP_UPDATE_CHECK
)

echo %GREEN%  ✓ Descarga completada%RST%
echo.
echo %CG%[2/4] Creando respaldo de version actual...%RST%
copy "%SCRIPT_PATH%" "%SCRIPT_DIR%RTIC_Hub_FCA_backup_%VERSION_ACTUAL%.bat" >nul 2>&1
echo %GREEN%  ✓ Respaldo creado: RTIC_Hub_FCA_backup_%VERSION_ACTUAL%.bat%RST%
echo.

echo %CG%[3/4] Preparando instalacion...%RST%

:: Crear script de actualización temporal
echo @echo off > "%TEMP%\RTIC_Updates\update_script.bat"
echo timeout /t 2 /nobreak ^>nul >> "%TEMP%\RTIC_Updates\update_script.bat"
echo copy /y "%TEMP%\RTIC_Updates\nueva_version.bat" "%SCRIPT_PATH%" ^>nul 2^>^&1 >> "%TEMP%\RTIC_Updates\update_script.bat"
echo if errorlevel 1 ( >> "%TEMP%\RTIC_Updates\update_script.bat"
echo     echo ERROR: No se pudo reemplazar el archivo. >> "%TEMP%\RTIC_Updates\update_script.bat"
echo     pause >> "%TEMP%\RTIC_Updates\update_script.bat"
echo     exit >> "%TEMP%\RTIC_Updates\update_script.bat"
echo ) >> "%TEMP%\RTIC_Updates\update_script.bat"
echo del "%TEMP%\RTIC_Updates\nueva_version.bat" ^>nul 2^>^&1 >> "%TEMP%\RTIC_Updates\update_script.bat"
echo start "" "%SCRIPT_PATH%" skipupdate >> "%TEMP%\RTIC_Updates\update_script.bat"
echo exit >> "%TEMP%\RTIC_Updates\update_script.bat"

echo %GREEN%  ✓ Script de instalacion preparado%RST%
echo.
echo %CG%[4/4] Aplicando actualizacion...%RST%
echo.
echo %GREEN%La aplicacion se reiniciara automaticamente.%RST%
timeout /t 3 /nobreak >nul

:: Ejecutar script de actualización y salir
start /min "" "%TEMP%\RTIC_Updates\update_script.bat"
exit

:SKIP_UPDATE_CHECK
title RTIC_HUB_FCA

:: ==========================================
:: 1. VERIFICACION DE INTERNET (ESTRICTO)
:: ==========================================
cls
color 0B
echo.
echo  [SYSTEM] Verificando conectividad...
ping -n 1 -w 2000 8.8.8.8 >nul
if %errorlevel% NEQ 0 goto :SIN_INTERNET

:: ==========================================
:: 2. VERIFICACION DE ADMINISTRADOR
:: ==========================================
net session >nul 2>&1
if %errorLevel% == 0 goto :ES_ADMIN

:NO_ADMIN
color 0C
cls
echo.
echo ======================================================
echo    [ERROR] NECESITAS PERMISOS DE ADMINISTRADOR
echo ======================================================
echo.
echo    Windows requiere permisos elevados para modificar
echo    las politicas de seguridad.
echo.
echo    POR FAVOR: Clic derecho -^> Ejecutar como administrador.
echo.
pause
exit

:SIN_INTERNET
cls
echo.
echo %R_ERR%======================================================
echo      [ERROR] NO SE DETECTA CONEXION A INTERNET
echo ======================================================%CW%
echo.
echo    No se recibio respuesta de internet
echo    Es necesario internet para descargar los recursos.
echo.
echo    ¿Deseas ir al menu de redes para intentar
echo    restablecer la conexion?
echo.
echo    [1] SI, Entrar al menu de redes
echo    [2] NO, Salir del programa
echo.
set /p redfix="%CYAN%Selecciona una opcion: %RST%"

if "%redfix%"=="1" goto :SUBMENU_REDES
exit

:ES_ADMIN
color 0B

:: ==========================================
:: PANTALLA DE CARGA
:: ==========================================
setlocal EnableDelayedExpansion

:: Aumentamos tamaño de ventana para el logo
mode con: cols=90 lines=30

:: Ocultar cursor
echo %ESC%[?25l

set "L1=                                  %CH%                          %RST%%CW% fca%RST%"
set "L2= %CW%██████╗ ████████╗██╗  ██████╗    %CH% ██╗  ██╗██╗   ██╗██████╗ %RST%"
set "L3= %CW%██╔══██╗╚══██╔══╝██║ ██╔════╝    %CH% ██║  ██║██║   ██║██╔══██╗%RST%"
set "L4= %CW%██████╔╝   ██║   ██║ ██║         %CH% ███████║██║   ██║██████╔╝%RST%"
set "L5= %CW%██╔══██╗   ██║   ██║ ██║         %CH% ██╔══██║██║   ██║██╔══██╗%RST%"
set "L6= %CW%██║  ██║   ██║   ██║ ╚██████╗    %CH% ██║  ██║╚██████╔╝██████╔╝%RST%"
set "L7= %CW%╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═════╝    %CH% ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ %RST%"
set "L8=                                  %CH%                          %RST%"

:: --- BUCLE DE CARGA ---
set "BARRA="
set "TOTAL_STEPS=13"

for /L %%i in (1,1,%TOTAL_STEPS%) do (
    cls
    echo.
    echo.
    echo %L1%
    echo %L2%
    echo %L3%
    echo %L4%
    echo %L5%
    echo %L6%
    echo %L7%
    echo %L8%
    echo.
    echo                      %CG%Creado por: Eichhh%RST%
    echo                        %CG%Version: %VERSION_ACTUAL%%RST%
    echo.
    
    :: Logica de barra de progreso
    set "BARRA=!BARRA!██"
    echo                  %ORANGE%!BARRA!%RST%                     
    echo                  Cargando modulos...  %%i/13
    
    :: METODO PING (Mas ligero y estable que powershell)
    ping -n 1 -w 200 127.255.255.255 >nul
)

echo %ESC%[?25h
goto :MENU_PRINCIPAL


:: ==========================================
:: 3. MENU PRINCIPAL (JERARQUICO)
:: ==========================================
:MENU_PRINCIPAL
color 0B
cls
echo ========================================================
echo        SISTEMA DE GESTION FCA - UAEMEX
echo ========================================================
echo.
echo    Selecciona una categoria:
echo.
echo    [1] INSTALACION INICIAL (EN DESARROLLO)
echo        - Drivers, paqueteria basica, etc.
echo.
echo    [2] CONFIGURACION DE PANTALLA Y FONDO
echo        - Modo institucional, bloquear fondos, restaurar.
echo.
echo    [3] OPTIMIZADOR DEL SISTEMA
echo        - Limpieza, rendimiento, temporales.
echo.
echo    [4] GESTION DE REDES, CONECTIVIDAD Y CONFIGURACION
echo        - Bloquear compartir internet (Hotspot), WiFi.
echo.
echo    [5] ACTIVACION DE LICENCIAS
echo        - Windows y Office.
echo.
echo    [6] BUSCAR ACTUALIZACIONES
echo        - Verificar si hay nueva version disponible.
echo.
echo    [7] SALIR
echo.
echo --------------------------------------------------------
set /p opcion="Escribe el numero y presiona Enter: "

if "%opcion%"=="1" goto :EN_DESARROLLO
if "%opcion%"=="2" goto :SUBMENU_PANTALLA
if "%opcion%"=="3" goto :SUBMENU_OPTIMIZADOR
if "%opcion%"=="4" goto :SUBMENU_REDES
if "%opcion%"=="5" goto :ACTIVACION
if "%opcion%"=="6" goto :VERIFICAR_ACTUALIZACIONES_MANUAL
if "%opcion%"=="7" exit
goto :MENU_PRINCIPAL

:: ==========================================
:: VERIFICACION MANUAL DE ACTUALIZACIONES
:: ==========================================
:VERIFICAR_ACTUALIZACIONES_MANUAL
cls
echo.
echo %CYAN%[AUTO-UPDATE] Verificando actualizaciones...%RST%
echo.

:: Crear carpeta temporal si no existe
if not exist "%TEMP%\RTIC_Updates" mkdir "%TEMP%\RTIC_Updates" >nul 2>&1

:: Descargar archivo de versión desde GitHub
echo %CG%  - Consultando repositorio GitHub...%RST%
curl -L -s -f "https://raw.githubusercontent.com/azarel22/FCA/refs/heads/main/version.txt" -o "%TEMP%\RTIC_Updates\version.txt" 2>nul

if errorlevel 1 (
    echo.
    echo %R_ERR%[ERROR] No se pudo conectar al repositorio.%RST%
    echo %ORANGE%Verifica tu conexion a internet.%RST%
    echo.
    pause
    goto :MENU_PRINCIPAL
)

:: Leer versión desde el archivo descargado
set "VERSION_REMOTA="
for /f "usebackq tokens=*" %%a in ("%TEMP%\RTIC_Updates\version.txt") do (
    set "VERSION_REMOTA=%%a"
    goto :version_leida_manual
)
:version_leida_manual

if "%VERSION_REMOTA%"=="" (
    echo.
    echo %R_ERR%[ERROR] No se pudo leer la informacion de version.%RST%
    echo.
    pause
    goto :MENU_PRINCIPAL
)

echo %CG%  - Version actual: %VERSION_ACTUAL%%RST%
echo %CG%  - Version disponible: %VERSION_REMOTA%%RST%
echo.

:: Comparar versiones
if "%VERSION_ACTUAL%"=="%VERSION_REMOTA%" (
    echo %GREEN%[OK] Ya tienes la ultima version instalada.%RST%
    echo.
    pause
    goto :MENU_PRINCIPAL
)

:: Nueva versión disponible
echo %GREEN%╔════════════════════════════════════════════════════════════╗%RST%
echo %GREEN%║      ¡NUEVA VERSION DISPONIBLE!                           ║%RST%
echo %GREEN%║                                                            ║%RST%
echo %GREEN%║  Version actual:      %VERSION_ACTUAL%                               ║%RST%
echo %GREEN%║  Nueva version:       %VERSION_REMOTA%                               ║%RST%
echo %GREEN%║                                                            ║%RST%
echo %GREEN%╚════════════════════════════════════════════════════════════╝%RST%
echo.
echo %CYAN%¿Deseas actualizar ahora?%RST%
echo.
echo    [1] SI - Descargar e instalar actualizacion
echo    [2] NO - Volver al menu principal
echo.
set /p update_choice_manual="%CYAN%Selecciona una opcion: %RST%"

if "%update_choice_manual%"=="1" goto :PROCESAR_ACTUALIZACION
goto :MENU_PRINCIPAL

:: ==========================================
:: DESARROLLO
:: ==========================================
:EN_DESARROLLO
cls
echo.
echo ======================================================
echo        MODULO EN FASE DE DESARROLLO
echo ======================================================
echo.
echo    Esta funcion estara disponible en la proxima
echo    actualizacion del script.
echo.
pause
goto :MENU_PRINCIPAL

:: ==========================================
:: SECCION 2: SUBMENU PANTALLA
:: ==========================================
:SUBMENU_PANTALLA
cls
echo ========================================================
echo        GESTION DE PANTALLA Y APARIENCIA
echo ========================================================
echo.
echo    [1] MODO INSTITUCIONAL (Recomendado)
echo        - Descarga fondo FCA, lo aplica y bloquea cambios.
echo.
echo    [2] RESTAURAR PERMISOS (Desbloquear)
echo        - Permite cambiar el fondo manualmente.
echo        - NO elimina las imagenes descargadas.
echo.
echo    [3] SOLO BLOQUEAR FONDO ACTUAL
echo        - Mantiene tu imagen actual pero impide cambiarla.
echo.
echo    [4] Volver al Menu Principal
echo.
echo --------------------------------------------------------
set /p subop="Selecciona opcion: "

if "%subop%"=="1" goto :PANTALLA_INSTITUCIONAL
if "%subop%"=="2" goto :PANTALLA_RESTAURAR
if "%subop%"=="3" goto :PANTALLA_SOLO_CANDADO
if "%subop%"=="4" goto :MENU_PRINCIPAL
goto :SUBMENU_PANTALLA

:: --- LÓGICA DE PANTALLA ---


:PANTALLA_INSTITUCIONAL
cls
echo.
echo [1/7] Deteniendo interfaz visual...
taskkill /f /im explorer.exe >nul 2>&1

:: Limpieza previa
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f >nul 2>&1

echo [2/7] Preparando carpeta C:\Archivos_FCA_UAEMEX...
if not exist "C:\Archivos_FCA_UAEMEX" mkdir "C:\Archivos_FCA_UAEMEX" >nul 2>&1
icacls "C:\Archivos_FCA_UAEMEX" /grant Todos:F /T /Q >nul 2>&1

echo [3/7] Descargando recursos...
curl -L -s -o "C:\Archivos_FCA_UAEMEX\wallpaper_fca.png" "https://raw.githubusercontent.com/azarel22/FCA/25aad0a3eaf4d5be64142873f873ada8424662bd/wallpaper_fca.png"
curl -L -s -o "C:\Archivos_FCA_UAEMEX\lock_screen_wallpaper_fca.png" "https://raw.githubusercontent.com/azarel22/FCA/25aad0a3eaf4d5be64142873f873ada8424662bd/lock_screen_wallpaper_fca.png"

echo [4/7] Aplicando fondo al sistema...
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Archivos_FCA_UAEMEX\wallpaper_fca.png" /f >nul 2>&1

reg add "HKCU\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d "10" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v TileWallpaper /t REG_SZ /d "0" /f >nul 2>&1
:: -------------------------------

powershell -inputformat none -outputformat none -NonInteractive -Command "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class WP { [DllImport(\"user32.dll\")] public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni); }'; [WP]::SystemParametersInfo(20, 0, 'C:\Archivos_FCA_UAEMEX\wallpaper_fca.png', 3)"

echo [5/7] Aplicando bloqueo de pantalla...
reg add "HKLM\Software\Policies\Microsoft\Windows\Personalization" /v LockScreenImage /t REG_SZ /d "C:\Archivos_FCA_UAEMEX\lock_screen_wallpaper_fca.png" /f >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\Personalization" /v PersonalColors_Background /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\Personalization" /v PersonalColors_Accent /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\Personalization" /v NoChangingLockScreen /t REG_DWORD /d 1 /f >nul 2>&1

echo [6/7] Bloqueando cambio de fondo...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoChangingWallPaper /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoChangingWallPaper /t REG_DWORD /d 1 /f >nul 2>&1

echo [7/7] Aplicando cambios...
gpupdate /force >nul 2>&1
start explorer.exe

echo.
echo [EXITO] Configuracion completada correctamente.
echo.
pause
goto :MENU_PRINCIPAL



:PANTALLA_SOLO_CANDADO
cls
echo.
echo [1/3] Bloqueando cambio de fondo de escritorio...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoChangingWallPaper /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoChangingWallPaper /t REG_DWORD /d 1 /f >nul 2>&1

echo [2/3] Bloqueando pantalla de bloqueo...
reg add "HKLM\Software\Policies\Microsoft\Windows\Personalization" /v NoChangingLockScreen /t REG_DWORD /d 1 /f >nul 2>&1

echo [3/3] Aplicando politicas...
gpupdate /force >nul 2>&1

echo.
echo [EXITO] Imagen actual bloqueada.
echo.
pause
goto :MENU_PRINCIPAL


:PANTALLA_RESTAURAR
cls
echo.
echo [1/3] Restaurando permisos de personalizacion...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f >nul 2>&1
reg delete "HKLM\Software\Policies\Microsoft\Windows\Personalization" /f >nul 2>&1

echo [2/3] Habilitando cambio de fondo y bloqueo...
reg add "HKCU\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d "10" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v TileWallpaper /t REG_SZ /d "0" /f >nul 2>&1

echo [3/3] Aplicando cambios...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
echo.
echo [EXITO] Configuracion restaurada a valores de fabrica.
echo.
pause
goto :MENU_PRINCIPAL



:: ==========================================
:: SECCION 3: SUBMENU OPTIMIZADOR
:: ==========================================
:SUBMENU_OPTIMIZADOR
cls
echo ========================================================
echo         OPTIMIZADOR DEL SISTEMA
echo ========================================================
echo.
echo    [1] LIMPIEZA COMPLETA
echo        - Archivos temporales, cache, prefetch.
echo.
echo    [2] OPTIMIZACION DE INICIO
echo        - Deshabilita programas innecesarios al arranque.
echo.
echo    [3] LIMPIEZA DEL DISCO (Windows)
echo        - Ejecuta la herramienta de Windows.
echo.
echo    [4] Volver al Menu Principal
echo.
echo --------------------------------------------------------
set /p optop="Selecciona opcion: "

if "%optop%"=="1" goto :OPT_LIMPIEZA
if "%optop%"=="2" goto :EN_DESARROLLO
if "%optop%"=="3" goto :OPT_DISCO
if "%optop%"=="4" goto :MENU_PRINCIPAL
goto :SUBMENU_OPTIMIZADOR

:OPT_LIMPIEZA
cls
echo.
echo [PROCESANDO] Limpieza del sistema...
echo.
echo [1/5] Limpiando archivos temporales...
del /q /f /s %TEMP%\* >nul 2>&1
del /q /f /s C:\Windows\Temp\* >nul 2>&1

echo [2/5] Limpiando prefetch...
del /q /f /s C:\Windows\Prefetch\* >nul 2>&1

echo [3/5] Limpiando cache de Windows Update...
net stop wuauserv >nul 2>&1
del /q /f /s C:\Windows\SoftwareDistribution\Download\* >nul 2>&1
net start wuauserv >nul 2>&1

echo [4/5] Limpiando papelera de reciclaje...
rd /s /q C:\$Recycle.Bin >nul 2>&1

echo [5/5] Finalizando...
echo.
echo [EXITO] Limpieza completada.
echo.
pause
goto :SUBMENU_OPTIMIZADOR

:OPT_DISCO
cls
echo.
echo [INFO] Abriendo herramienta de limpieza de disco...
cleanmgr /d C:
pause
goto :SUBMENU_OPTIMIZADOR


:: ==========================================
:: SECCION 4: SUBMENU REDES
:: ==========================================
:SUBMENU_REDES
cls
echo %P141%
echo ========================================================
echo        GESTION DE REDES Y CONECTIVIDAD
echo ========================================================
echo.
echo    [1] BLOQUEAR ZONA DE COBERTURA (Mobile Hotspot)
echo        - Evita que el usuario comparta internet por WiFi.
echo.
echo    [2] PERMITIR ZONA DE COBERTURA (Desbloquear)
echo        - Restaura la opcion de compartir internet.
echo.
echo    [3] CONFIGURACION IP (MANUAL)
echo        - Asignar IP Estatica, Mascara, Gateway y DNS.
echo.
echo    [4] Volver al Menu Principal
echo.
echo --------------------------------------------------------
set /p subop="Selecciona opcion: "

if "%subop%"=="1" goto :RED_BLOQUEAR_HOTSPOT
if "%subop%"=="2" goto :RED_DESBLOQUEAR_HOTSPOT
if "%subop%"=="3" goto :RED_CONFIG_IP
if "%subop%"=="4" (
    echo %RST%
    goto :MENU_PRINCIPAL
)
goto :SUBMENU_REDES

:RED_BLOQUEAR_HOTSPOT
cls
echo.
echo [PROCESANDO] Aplicando politicas de red...
echo.
echo [1/2] Modificando registro (Network Connections)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Network Connections" /v NC_ShowSharedAccessUI /t REG_DWORD /d 0 /f >nul 2>&1

echo [2/2] Forzando actualizacion de politicas...
gpupdate /force >nul 2>&1

echo.
echo [INFO] Bloqueo aplicado.
echo        Es probable que requieras REINICIAR el equipo.
echo.
pause
goto :EXITO_RETORNO

:RED_DESBLOQUEAR_HOTSPOT
cls
echo.
echo [PROCESANDO] Eliminando bloqueos de red...
echo.
echo [1/2] Eliminando politica de restriccion...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Network Connections" /v NC_ShowSharedAccessUI /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Network Connections" /f >nul 2>&1

echo [2/2] Actualizando politicas...
gpupdate /force >nul 2>&1

echo.
echo [INFO] Bloqueo eliminado. Si no aparece la opcion, reinicia.
echo.
pause
goto :EXITO_RETORNO

:RED_CONFIG_IP
cls
echo %P141%
echo ========================================================
echo         ASISTENTE DE CONFIGURACION IP (MANUAL)
echo ========================================================
echo.
echo [1/5] Identificando interfaces de red...
echo.
netsh interface show interface
echo.
echo     Escribe el nombre EXACTO de la interfaz (Ej: Ethernet).
echo.
set /p ADAPTADOR="%CW%Nombre de la interfaz: %P141%"

cls
echo ========================================================
echo         CONFIGURANDO: %ADAPTADOR%
echo ========================================================
echo.
echo [2/5] Ingresa los datos de conexion...
echo.
set /p IP="%CW%   - Direccion IP: %P141%"
set /p MASCARA="%CW%   - Mascara (Default: 255.255.255.0): %P141%"
set /p PUERTA="%CW%   - Puerta de enlace: %P141%"
echo.
echo [3/5] Configurando Servidores DNS...
set /p DNS1="%CW%   - DNS Preferido: %P141%"
set /p DNS2="%CW%   - DNS Alternativo: %P141%"

cls
echo ========================================================
echo                   RESUMEN DE DATOS
echo ========================================================
echo.
echo     Interfaz : %ADAPTADOR%
echo     IP       : %IP%
echo     DNS 1    : %DNS1%
echo.
echo --------------------------------------------------------
echo %CW%Presiona ENTER para aplicar cambios...%P141%
pause >nul

echo.
echo [4/5] Aplicando configuracion IP estatica...
netsh interface ip set address name="%ADAPTADOR%" static %IP% %MASCARA% %PUERTA% >nul 2>&1

echo [5/5] Estableciendo servidores DNS...
netsh interface ip set dns name="%ADAPTADOR%" static %DNS1% >nul 2>&1
netsh interface ip add dns name="%ADAPTADOR%" %DNS2% index=2 >nul 2>&1

echo.
echo --------------------------------------------------------
echo %CW%PROCESO FINALIZADO. Probando conexion...%P141%
ping 8.8.8.8 -n 2
echo.
pause
:: LIMPIEZA TOTAL ANTES DE SALIR
echo %RST%
goto :MENU_PRINCIPAL



:: ==========================================
:: SECCION 5: SUBMENU ACTIVACION
:: ==========================================
:ACTIVACION
color 0B
cls
echo ========================================================
echo        CENTRO DE LICENCIAS Y ACTIVACION
echo ========================================================
echo.
echo    [1] INSTALAR KEY OFFICE LTSC 2021
echo        - Instala la clave para Office Pro Plus 2021.
echo        - Intenta activar inmediatamente.
echo.
echo    [2] MENU DE ACTIVACION AVANZADO (MASGRAVE)
echo        - Abre PowerShell con el script "Microsoft Activation Scripts".
echo        - Opciones para Windows, HWID, KMS38, etc.
echo.
echo    [3] Volver al Menu Principal
echo.
echo --------------------------------------------------------
set /p actop="Selecciona opcion: "

if "%actop%"=="1" goto :KEY_OFFICE_2021
if "%actop%"=="2" goto :MAS_POWERSHELL
if "%actop%"=="3" goto :MENU_PRINCIPAL
goto :ACTIVACION

:: --- OPCION 1: OFFICE KEY ---
:KEY_OFFICE_2021
cls
echo.
echo [1/3] Buscando instalacion de Office...

:: Detectar ruta de Office (x64 o x86)
set "OFFICE_DIR="
if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" set "OFFICE_DIR=%ProgramFiles%\Microsoft Office\Office16"
if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" set "OFFICE_DIR=%ProgramFiles(x86)%\Microsoft Office\Office16"

if not defined OFFICE_DIR (
    color 0C
    echo.
    echo [ERROR] No se encontro Office 2016/2019/2021 instalado.
    echo         Verifica que este instalado en la ruta por defecto.
    echo.
    pause
    goto :ACTIVACION
)

echo [2/3] Instalando Clave LTSC 2021 Pro Plus...
echo        Clave: D67NW-YV8J3-CCXTQ-V3B83-M7YGK
cd /d "%OFFICE_DIR%"
cscript //nologo ospp.vbs /inpkey:D67NW-YV8J3-CCXTQ-V3B83-M7YGK

echo.
echo [3/3] Intentando activar...
cscript //nologo ospp.vbs /act

echo.
echo [RESULTADO] Proceso finalizado. Verifica los mensajes anteriores.
echo.
pause
goto :ACTIVACION

:: --- OPCION 2: POWERSHELL Masgrave ---
:MAS_POWERSHELL
cls
echo.
echo [INFO] Lanzando PowerShell como Administrador...
echo        Espera a que cargue la ventana azul.
start powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://get.activated.win | iex"
echo.
echo [PROCESO] Script ejecutado en segunda ventana.
pause
goto :ACTIVACION


:: ==========================================
:: FINAL COMUN
:: ==========================================
:EXITO_RETORNO
cls
echo.
echo ========================================================
echo          OPERACION COMPLETADA CON EXITO
echo ========================================================
echo.
echo ⠀⠀⠀⠀⠀⣴⠉⡙⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠤⣚⡯⠴⢬⣱⡀⠀
echo ⠀⠀⠀⠀⢰⡇⣷⡌⢲⣄⡑⢢⡀⠀⠀⠀⠀⠀⢠⠾⢋⠔⣨⣴⣿⣷⡌⠇⡇⠀
echo ⠀⠀⠀⠀⢸⢹⣿⣿⣄⢻⣿⣷⣝⠷⢤⣤⣤⡶⢋⣴⣑⠟⠿⠿⠿⣿⣿⡀⡇⠀
echo ⠀⠀⠀⠀⢸⢸⣿⡄⢁⣸⣿⣋⣥⣶⣶⣶⣶⣶⣶⣿⣿⣶⣟⡁⠚⣿⣿⡇⡇⠀
echo ⢀⣠⡤⠤⠾⡘⠋⢀⣘⠋⠉⠉⠉⠉⢭⣭⣭⣭⣍⠉⢩⣭⠉⠉⠂⠙⠛⠃⣇⡀
echo ⠏⠀⠀⢿⣿⣷⡀⠀⢿⡄⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣆⠀⢿⣇⠀⠀⠀⠀⠀⠀⠈⢱
echo ⣦⠀⠀⠈⢿⣿⣧⠀⠘⣿⠀⠀⠀⡀⠀⠀⠘⣿⣿⣿⣿⡆⠀⢻⡆⠀⠀⠀⠀⠀⠀⢸
echo ⢻⡄⠀⠀⠘⠛⠉⠂⠀⠙⠁⠀⣼⣧⠀⠀⠀⠈⠀⠀⠈⠙⠀⠘⠓⠀⠀⠀⠀⠀⢀⡟
echo ⠀⢳⡀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⣏⠀
echo ⠀⠀⠛⢶⢰⣶⢢⣤⣤⣄⠲⣶⠖⠀⣙⣀⠀⠀⠀⠤⢤⣀⣀⡀⣀⣠⣾⠟⡌⠀
echo ⠀⠀⠀⠘⢄⠃⣿⣿⣿⣿⠗⠀⠾⢿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣶⠸⠟⣡⣤⡳⢦
echo ⠀⠀⠀⠀⠀⢻⡆⣙⡿⢷⣾⣿⣶⣾⣿⣿⣿⣿⣿⣿⣿⡿⠟⢡⣴⣾⣿⣿⣿⣦
echo ⠀⠀⠀⠀⠀⡼⢁⡟⣫⣶⣍⡙⠛⠛⠛⠛⠛⣽⡖⣉⣠⣶⣶⣌⠛⢿⣿⣿⣿⣿
echo ⠀⠀⠀⢀⠔⢡⢎⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠹⣿⣿⣿
echo ⠀⢠⠖⢁⣴⡿⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢹⣿⣿
echo.
pause
goto :MENU_PRINCIPAL
