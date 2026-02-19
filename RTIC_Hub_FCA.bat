@echo off
:: ==========================================
:: Creado por: Eichhh
:: Versión: 9.3.12 (Integracion de fondos y regedit)
:: ==========================================

:: Deja de ver mi codigo, inche chismoso
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⠀⠀⠀⣴⠏⠁⠀⠙⢿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡏⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⠶⣶⣿⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠏⠀⠀⠈⣿⠀⠀⠀⠀⠀⢸⣷⣦⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡿⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⢸⠇⠀⠀⠉⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⢿⠇⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠸⡷⠤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡾⠋⠀⣾⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⣧⠀⠀⠹⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠏⠀⠀⠀⣿⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⢹⡄⠀⠀⢹⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡏⠀⠀⠀⠀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠇⠀⠀⠀⢻⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
::⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡏⠀⠀⠀⠀⠀⠀⠀⠀

chcp 65001 >nul
setlocal EnableDelayedExpansion
:: ==========================================
:: CONFIGURACIÓN DE AUTO-ACTUALIZACIÓN
:: ==========================================
set "GITHUB_USER=azarel22"
set "GITHUB_REPO=FCA"
set "GITHUB_BRANCH=main"
set "SCRIPT_NAME=RTIC_Hub_FCA.bat"
set "VERSION_ACTUAL=9.3.12"
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
:: -----------------------------------------------

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
:: VERIFICAR ACTUALIZACIONES AL INICIO
:: ==========================================
if "%1"=="skipupdate" goto :SKIP_UPDATE_CHECK

cls
echo.
echo [AUTO-UPDATE] Verificando actualizaciones...
echo.

:: Crear carpeta temporal si no existe
if not exist "%TEMP%\RTIC_Updates" mkdir "%TEMP%\RTIC_Updates" >nul 2>&1

:: Descargar archivo de versión desde GitHub
echo   - Consultando repositorio GitHub...
curl -L -s -f "https://raw.githubusercontent.com/azarel22/FCA/refs/heads/main/version.txt" -o "%TEMP%\RTIC_Updates\version.txt" 2>nul
:: Descargar changelog
curl -L -s -f "https://raw.githubusercontent.com/azarel22/FCA/refs/heads/main/changelog.txt" -o "%TEMP%\RTIC_Updates\changelog.txt" 2>nul

if errorlevel 1 (
    echo   [AVISO] No se pudo verificar actualizaciones.
    echo   Continuando con version actual: %VERSION_ACTUAL%
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
    echo   [AVISO] No se pudo leer la version remota.
    timeout /t 2 /nobreak >nul
    goto :SKIP_UPDATE_CHECK
)

echo.

:: Comparar versiones
if "%VERSION_ACTUAL%"=="%VERSION_REMOTA%" (
    echo   [OK] Ya tienes la ultima version instalada.
    timeout /t 2 /nobreak >nul
    goto :SKIP_UPDATE_CHECK
)

:: Nueva versión disponible
echo ════════════════════════════════════════════════════════════
echo       ¡NUEVA VERSION DISPONIBLE!
echo ════════════════════════════════════════════════════════════
echo.
echo   Version actual:      %VERSION_ACTUAL%
echo   Nueva version:       %VERSION_REMOTA%
echo.
echo ════════════════════════════════════════════════════════════
echo   NOVEDADES:
echo ════════════════════════════════════════════════════════════
for /f "usebackq tokens=*" %%l in ("%TEMP%\RTIC_Updates\changelog.txt") do (
    echo   %%l
)
echo ════════════════════════════════════════════════════════════
echo.
echo ¿Deseas actualizar ahora?
echo.
echo    [1] SI - Descargar e instalar actualizacion
echo    [2] NO - Continuar con la version actual
echo.
set /p update_choice="Selecciona una opcion: "

if not "%update_choice%"=="1" (
    echo.
    echo [INFO] Actualizacion omitida. Continuando...
    timeout /t 2 /nobreak >nul
    goto :SKIP_UPDATE_CHECK
)

:: Proceder con la actualización
goto :PROCESAR_ACTUALIZACION

:PROCESAR_ACTUALIZACION
cls
echo.
echo ════════════════════════════════════════════════════════════
echo             ACTUALIZANDO RTIC HUB FCA
echo ════════════════════════════════════════════════════════════
echo.

:: Obtener ruta completa del script actual
set "SCRIPT_PATH=%~f0"
set "SCRIPT_DIR=%~dp0"

echo [1/4] Descargando nueva version...
curl -L -s -f "https://raw.githubusercontent.com/azarel22/FCA/refs/heads/main/RTIC_Hub_FCA.bat" -o "%TEMP%\RTIC_Updates\nueva_version.bat"

if errorlevel 1 (
    echo.
    echo [ERROR] No se pudo descargar la actualizacion.
    echo Verifica tu conexion a internet.
    echo.
    pause
    goto :SKIP_UPDATE_CHECK
)

echo   ✓ Descarga completada
echo.
echo [2/4] Creando respaldo de version actual...
copy "%SCRIPT_PATH%" "%SCRIPT_DIR%RTIC_Hub_FCA_backup_%VERSION_ACTUAL%.bat" >nul 2>&1
echo   ✓ Respaldo creado: RTIC_Hub_FCA_backup_%VERSION_ACTUAL%.bat
echo.

echo [3/4] Preparando instalacion...

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

echo   ✓ Script de instalacion preparado
echo.
echo [4/4] Aplicando actualizacion...
echo.
echo La aplicacion se reiniciara automaticamente.
timeout /t 3 /nobreak >nul

:: Ejecutar script de actualización y salir
start /min "" "%TEMP%\RTIC_Updates\update_script.bat"
exit

:SKIP_UPDATE_CHECK

:: ==========================================
:: PANTALLA DE CARGA
:: ==========================================

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
echo    [1] MODO INSTITUCIONAL (Recomendado)(EN DESARROLLO)
echo        - Descarga fondo FCA, lo aplica y bloquea cambios.
echo.
echo    [2] RESTAURAR PERMISOS (Desbloquear)
echo        - Permite cambiar el fondo manualmente.
echo        - NO elimina las imagenes descargadas.
echo.
echo    [3] SOLO BLOQUEAR FONDO ACTUAL
echo        - Mantiene tu imagen actual pero impide cambiarla.
echo.
echo    [4] Descarga de fondos
echo        - Descarga los fondos institucionales
echo        - Crea la carpeta donde se almacenan
echo.
echo    [5] Volver al Menu Principal
echo.
echo --------------------------------------------------------
set /p subop="Selecciona opcion: "

if "%subop%"=="1" goto :EN_DESARROLLO
if "%subop%"=="2" goto :PANTALLA_RESTAURAR
if "%subop%"=="3" goto :PANTALLA_SOLO_CANDADO
if "%subop%"=="4" goto :Fondos
if "%subop%"=="5" goto :MENU_PRINCIPAL
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
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
echo [5/7] Esperando aplicacion de cambios...
timeout /t 2 /nobreak >nul
goto :RUTINA_CANDADO_COMUN

:PANTALLA_SOLO_CANDADO
cls
echo.
echo [1/3] Preparando bloqueo...
taskkill /f /im explorer.exe >nul 2>&1
echo [2/3] Aplicando seguridad al fondo actual...
goto :RUTINA_CANDADO_COMUN

:RUTINA_CANDADO_COMUN
echo [PROCESANDO] Aplicando candados de seguridad (HKLM y HKCU)...
:: Leer y fijar el fondo actual como politica persistente
for /f "tokens=3*" %%a in ('reg query "HKCU\Control Panel\Desktop" /v Wallpaper 2^>nul') do set "WALLPAPER_ACTUAL=%%a %%b"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v Wallpaper /t REG_SZ /d "%WALLPAPER_ACTUAL%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v WallpaperStyle /t REG_SZ /d "10" /f >nul 2>&1
:: Bloqueos Wallpaper
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /t REG_DWORD /d 1 /f >nul 2>&1
:: Bloqueos Lock Screen
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "LockScreenImage" /t REG_SZ /d "C:\Archivos_FCA_UAEMEX\lock_screen_wallpaper_fca.png" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoChangingLockScreen" /t REG_DWORD /d 1 /f >nul 2>&1
:: Ocultar opciones
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoDispBackgroundPage" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoDispBackgroundPage" /t REG_DWORD /d 1 /f >nul 2>&1

echo.
echo Actualizando politicas...
gpupdate /force >nul 2>&1
start explorer.exe
goto :EXITO_RETORNO

:PANTALLA_RESTAURAR
cls
echo.
echo [1/3] Deteniendo interfaz...
taskkill /f /im explorer.exe >nul 2>&1
echo [2/3] Eliminando Politicas de Restriccion (HKLM y HKCU)...
:: HKLM
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v NoDispBackgroundPage /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v Wallpaper /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v WallpaperStyle /f >nul 2>&1
:: HKCU
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f >nul 2>&1
reg delete "HKCU\Software\Policies\Microsoft\Windows\Personalization" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v NoDispBackgroundPage /f >nul 2>&1

echo [3/3] Restaurando interfaz...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ThemeManager" /v "ThemeRoaming" /t REG_DWORD /d 1 /f >nul 2>&1
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
gpupdate /force >nul 2>&1
start explorer.exe
goto :EXITO_RETORNO


:Fondos
cls
echo.
echo [1/3] Preparando carpeta C:\Archivos_FCA_UAEMEX...
if not exist "C:\Archivos_FCA_UAEMEX" mkdir "C:\Archivos_FCA_UAEMEX" >nul 2>&1
icacls "C:\Archivos_FCA_UAEMEX" /grant Todos:F /T /Q >nul 2>&1

echo [2/3] Descargando recursos...
curl -L -s -o "C:\Archivos_FCA_UAEMEX\wallpaper_fca.png" "https://raw.githubusercontent.com/azarel22/FCA/25aad0a3eaf4d5be64142873f873ada8424662bd/wallpaper_fca.png"
curl -L -s -o "C:\Archivos_FCA_UAEMEX\lock_screen_wallpaper_fca.png" "https://raw.githubusercontent.com/azarel22/FCA/25aad0a3eaf4d5be64142873f873ada8424662bd/lock_screen_wallpaper_fca.png"

echo [3/3] Abriendo carpeta...
start "" "C:\Archivos_FCA_UAEMEX"

goto :EXITO_RETORNO


:: ==========================================
:: SECCION 3: OPTIMIZADOR DEL SISTEMA
:: ==========================================
:SUBMENU_OPTIMIZADOR
cls
echo ========================================================
echo        OPTIMIZADOR DE RENDIMIENTO Y ARRANQUE
echo ========================================================
echo.
echo    [1] APLICAR OPTIMIZACION (MAX RENDIMIENTO + FUENTES)
echo        - Boot: Activa TODOS los procesadores (%NUMBER_OF_PROCESSORS%).
echo        - Visual: Desactiva animaciones y sombras innecesarias.
echo        - Visual: MANTIENE suavizado de bordes en fuentes.
echo.
echo    [2] RESTAURAR VALORES POR DEFECTO
echo        - Boot: Deja que Windows administre los nucleos.
echo        - Visual: "Dejar que Windows elija".
echo.
echo    [3] Volver al Menu Principal
echo.
echo --------------------------------------------------------
set /p subop="Selecciona opcion: "

if "%subop%"=="1" goto :APLICAR_OPTIMIZACION
if "%subop%"=="2" goto :RESTAURAR_OPTIMIZACION
if "%subop%"=="3" goto :MENU_PRINCIPAL
goto :SUBMENU_OPTIMIZADOR

:APLICAR_OPTIMIZACION
cls
echo.
echo [1/3] Configurando ARRANQUE (Procesadores)...
:: Esto equivale a ir a msconfig y marcar el maximo de nucleos manualmente
bcdedit /set {current} numproc %NUMBER_OF_PROCESSORS% >nul 2>&1
echo      - Nucleos configurados al maximo: %NUMBER_OF_PROCESSORS%

echo [2/3] Configurando EFECTOS VISUALES (Rendimiento)...
:: Establece "Ajustar para obtener el mejor rendimiento" como base
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1

reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f >nul 2>&1

reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1

:: Acelera el despliegue de menus
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1

echo [3/3] Aplicando cambios...
:: Reiniciar explorer para aplicar efectos visuales
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
echo.
echo [EXITO] Optimizacion aplicada.
echo         Las fuentes se veran bien, pero el resto estara optimizado.
echo         NOTA: Reinicia el equipo para aplicar los nucleos del CPU.
echo.
pause
goto :MENU_PRINCIPAL

:RESTAURAR_OPTIMIZACION
cls
echo.
echo [1/3] Restaurando ARRANQUE (Default)...
:: Borra la entrada numproc para que Windows decida (Default)
bcdedit /deletevalue {current} numproc >nul 2>&1

echo [2/3] Restaurando EFECTOS VISUALES (Equilibrado)...
:: Establece "Dejar que Windows elija"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 1 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 400 /f >nul 2>&1

echo [3/3] Aplicando cambios...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
echo.
echo [EXITO] Configuracion restaurada a valores de fabrica.
echo.
pause
goto :MENU_PRINCIPAL



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
echo        - Bloquea regedit para los que intentan activar la zona nuevamente.
echo.
echo    [2] PERMITIR ZONA DE COBERTURA (Desbloquear)
echo        - Restaura la opcion de compartir internet.
echo        - Habilita el regedit nuevamente.
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
echo [1/3] Modificando registro (Network Connections)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Network Connections" /v NC_ShowSharedAccessUI /t REG_DWORD /d 0 /f >nul 2>&1

echo [2/3] El Editor del Registro ha sido bloqueado.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t REG_DWORD /d 1 /f


echo [3/3] Forzando actualizacion de politicas...
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
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t REG_DWORD /d 0 /f

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
:: VERIFICACION MANUAL DE ACTUALIZACIONES
:: ==========================================
:VERIFICAR_ACTUALIZACIONES_MANUAL
cls
echo.
echo [AUTO-UPDATE] Verificando actualizaciones...
echo.

:: Crear carpeta temporal si no existe
if not exist "%TEMP%\RTIC_Updates" mkdir "%TEMP%\RTIC_Updates" >nul 2>&1

:: Descargar archivo de versión desde GitHub
echo   - Consultando repositorio GitHub...
curl -L -s -f "https://raw.githubusercontent.com/azarel22/FCA/refs/heads/main/version.txt" -o "%TEMP%\RTIC_Updates\version.txt" 2>nul

if errorlevel 1 (
    echo.
    echo [ERROR] No se pudo conectar al repositorio.
    echo Verifica tu conexion a internet.
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
    echo [ERROR] No se pudo leer la informacion de version.
    echo.
    pause
    goto :MENU_PRINCIPAL
)

echo.

:: Comparar versiones
if "%VERSION_ACTUAL%"=="%VERSION_REMOTA%" (
    echo [OK] Ya tienes la ultima version instalada.
    echo.
    pause
    goto :MENU_PRINCIPAL
)

:: Nueva versión disponible
echo ════════════════════════════════════════════════════════════
echo       ¡NUEVA VERSION DISPONIBLE!
echo ════════════════════════════════════════════════════════════
echo.
echo   Version actual:      %VERSION_ACTUAL%
echo   Nueva version:       %VERSION_REMOTA%
echo.
echo ════════════════════════════════════════════════════════════
echo.
echo ¿Deseas actualizar ahora?
echo.
echo    [1] SI - Descargar e instalar actualizacion
echo    [2] NO - Volver al menu principal
echo.
set /p update_choice_manual="Selecciona una opcion: "

if "%update_choice_manual%"=="1" goto :PROCESAR_ACTUALIZACION
goto :MENU_PRINCIPAL


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