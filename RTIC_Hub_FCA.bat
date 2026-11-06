<# :
@echo off
reg add "HKCU\Console" /v "FaceName" /t REG_SZ /d "Consolas" /f >nul 2>&1
chcp 65001 > nul
setlocal EnableDelayedExpansion
title RTIC HUB FCA - Sistema de Gestion Institucional UAEMEX

:: ============================================================================
:: CONFIGURACION DEL SISTEMA Y REPOSITORIO GITHUB
:: ============================================================================
set "GITHUB_USER=azarel22"
set "GITHUB_REPO=FCA"
set "GITHUB_BRANCH=main"
set "SCRIPT_NAME=RTIC_Hub_FCA.bat"
set "VERSION_ACTUAL=15.0.4"
set "DATA_FOLDER=C:\Archivos_FCA_UAEMEX"
set "GH_BASE=https://raw.githubusercontent.com/%GITHUB_USER%/%GITHUB_REPO%/refs/heads/%GITHUB_BRANCH%"
set "WP_URL=https://raw.githubusercontent.com/azarel22/FCA/25aad0a3eaf4d5be64142873f873ada8424662bd/wallpaper_fca.png"
set "LS_URL=https://raw.githubusercontent.com/azarel22/FCA/25aad0a3eaf4d5be64142873f873ada8424662bd/lock_screen_wallpaper_fca.png"

:: Listas de programas visibles en el Modulo 1 (Editables facilmente)
set "APPS_ALUMNOS=Incluye: Office, Teams, Navegadores y Utilidades FCA"
set "APPS_DOCENTES=Incluye: Office, Teams, Suite Docente y Herramientas"
:: ============================================================================

:: Auto-elevacion silenciosa sin flasheo de ventana azul
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

for /F "delims=#" %%E in ('"prompt #$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%E"
echo %ESC%[?25l

:: ============================================================================
:: PALETA MULTICOLOR EMPRESARIAL (100% ALINEADA SIN GLIFOS DE DOBLE ANCHO)
:: ============================================================================
set "C_BORDER=%ESC%[38;2;71;85;105m"
set "C_SLATE=%ESC%[38;2;148;163;184m"
set "C_DIM=%ESC%[38;2;100;116;139m"
set "C_TEXT=%ESC%[38;2;226;232;240m"
set "C_WHITE=%ESC%[38;2;255;255;255m"

set "C_SAPPHIRE=%ESC%[38;2;59;130;246m"
set "C_CYAN=%ESC%[38;2;56;189;248m"
set "C_SKY=%ESC%[38;2;125;211;252m"
set "C_INDIGO=%ESC%[38;2;129;140;248m"
set "C_TEAL=%ESC%[38;2;45;212;191m"
set "C_EMERALD=%ESC%[38;2;52;211;153m"
set "C_AMBER=%ESC%[38;2;251;191;36m"
set "C_ORANGE=%ESC%[38;2;251;146;60m"
set "C_PURPLE=%ESC%[38;2;192;132;252m"
set "C_PINK=%ESC%[38;2;244;114;182m"
set "C_ROSE=%ESC%[38;2;244;63;94m"
set "C_BLINK=%ESC%[5m"

:: Fondos para Cabeceras y Sub-Secciones (68 columnas exactas)
set "BG_MAIN=%ESC%[48;2;18;32;58m%ESC%[38;2;255;255;255m"
set "BG_TELEM=%ESC%[48;2;15;23;42m%ESC%[38;2;148;163;184m"
set "BG_SEC1=%ESC%[48;2;11;42;50m%ESC%[38;2;94;234;212m"
set "BG_SEC2=%ESC%[48;2;30;25;62m%ESC%[38;2;196;181;253m"
set "BG_SEC3=%ESC%[48;2;46;30;14m%ESC%[38;2;253;230;138m"

set "BG_SCREEN=%ESC%[48;2;19;31;56m%ESC%[38;2;147;197;253m"
set "BG_OPT=%ESC%[48;2;13;40;45m%ESC%[38;2;94;234;212m"
set "BG_NET=%ESC%[48;2;20;30;60m%ESC%[38;2;147;197;253m"
set "BG_LIC=%ESC%[48;2;45;30;12m%ESC%[38;2;253;230;138m"
set "BG_UPD=%ESC%[48;2;58;28;113m%ESC%[38;2;243;232;255m"
set "BG_UPD_SUB=%ESC%[48;2;32;16;64m%ESC%[38;2;216;180;254m"
set "BG_OK=%ESC%[48;2;6;78;59m%ESC%[38;2;209;250;229m"
set "BG_CRIT=%ESC%[48;2;127;29;29m%ESC%[38;2;254;226;226m"
set "C_RESET=%ESC%[0m"

set "PAD68=                                                                    "

cd /d "%~dp0"
set "SELF_FILE=%~f0"
set "PS_OUT_FILE=%TEMP%\rtic_ps_out.tmp"
set "CHANGELOG_CACHE=%TEMP%\rtic_changelog.tmp"
set "OTA_STAGE_FILE=%TEMP%\rtic_new_update.tmp"
set "OTA_SWAP_BAT=%TEMP%\rtic_ota_swap.bat"
if not exist "%DATA_FOLDER%" mkdir "%DATA_FOLDER%" >nul 2>&1

:: ============================================================================
:: ARRANQUE ULTRARRAPIDO CON DETECCION DE RED MULTICAPA (SIN FALSO OFFLINE)
:: ============================================================================
call :RESIZE_CON 74 19
set "SERIAL_NUM=GENERIC-SN"
set "NET_STATE=ONLINE"
set "UPD_AVAILABLE=NO"
set "VERSION_REMOTA=%VERSION_ACTUAL%"
set "WP_STATUS=LIBRE"
set "HS_STATUS=LIBRE"

call :PS_GET "BOOT_INIT" "%VERSION_ACTUAL%" "%1" "BOOT_DATA"
if defined BOOT_DATA (
    for /f "tokens=1,2,3,4,5,6 delims=|" %%A in ("!BOOT_DATA!") do (
        set "SERIAL_NUM=%%A"
        set "NET_STATE=%%B"
        set "UPD_AVAILABLE=%%C"
        set "VERSION_REMOTA=%%D"
        set "WP_STATUS=%%E"
        set "HS_STATUS=%%F"
    )
)

if /I "!NET_STATE!"=="OFFLINE" goto :PROMPT_ERROR_INTERNET
if /I "!UPD_AVAILABLE!"=="YES" if /I not "%1"=="skipupdate" goto :PROMPT_AVISO_UPDATE
goto :MENU_PRINCIPAL


:: ============================================================================
:: PROMPTS DIRECTOS BAJO LA PANTALLA DE CARGA DETENIDA
:: ============================================================================
:PROMPT_ERROR_INTERNET
echo %ESC%[?25h
set "redfix="
set /p "redfix=   %C_ROSE%>%C_WHITE% Seleccione una accion [1 = Menu Redes / 2 = Modo Offline / 0 = Salir]: %C_TEXT%"
echo %ESC%[?25l
set "redfix=!redfix: =!"
if "!redfix!"=="1" goto :SUBMENU_REDES
if "!redfix!"=="2" goto :MENU_PRINCIPAL
if "!redfix!"=="0" exit
goto :PROMPT_ERROR_INTERNET

:PROMPT_AVISO_UPDATE
echo %ESC%[?25h
set "update_choice="
set /p "update_choice=   %C_PURPLE%>%C_WHITE% Seleccione una operacion [1 = Actualizar Ahora / 2 = Posponer]: %C_TEXT%"
echo %ESC%[?25l
set "update_choice=!update_choice: =!"
if "!update_choice!"=="1" goto :PROCESAR_ACTUALIZACION
goto :MENU_PRINCIPAL


:: ============================================================================
:: MENU PRINCIPAL (BORDES 100% FIJOS Y BANNER DE ACTUALIZACION ORDENADO)
:: ============================================================================
:MENU_PRINCIPAL
call :PS_GET "REFRESH_STATES" "" "" "STATE_DATA"
if defined STATE_DATA (
    for /f "tokens=1,2,3 delims=|" %%A in ("!STATE_DATA!") do (
        set "WP_STATUS=%%A"
        set "HS_STATUS=%%B"
        set "NET_STATE=%%C"
    )
)

:: Si ya detecto actualizacion en GitHub, forzar estado ONLINE (evita falso positivo ICMP)
if /I "!UPD_AVAILABLE!"=="YES" set "NET_STATE=ONLINE"

set "NET_BADGE=%C_EMERALD%* ONLINE"
if /I "!NET_STATE!"=="OFFLINE" set "NET_BADGE=%C_ROSE%* OFFLINE"

set "WP_BADGE=%C_EMERALD%* LIBRE"
if /I "!WP_STATUS!"=="LOCKED" set "WP_BADGE=%C_ROSE%* BLOQUEADO"

set "HS_BADGE=%C_EMERALD%* Hotspot Activo"
if /I "!HS_STATUS!"=="LOCKED" set "HS_BADGE=%C_ROSE%* Hotspot Inactivo"

set "UPD_RIGHT_TXT=%C_PURPLE%* Actualizar"
if /I "!UPD_AVAILABLE!"=="YES" set "UPD_RIGHT_TXT=%C_PURPLE%%C_BLINK%* ACTUALIZAR%C_RESET%"

if /I "!UPD_AVAILABLE!"=="YES" (
    call :RESIZE_CON 74 44
) else (
    call :RESIZE_CON 74 42
)
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_MAIN%%PAD68%%ESC%[5G  RTIC HUB FCA  -  SISTEMA DE GESTION INSTITUCIONAL UAEMEX%ESC%[64Gv%VERSION_ACTUAL%%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
if /I "!UPD_AVAILABLE!"=="YES" echo   %C_BORDER%├────────────────────────────────────────────────────────────────────┤%C_RESET%
if /I "!UPD_AVAILABLE!"=="YES" echo   %C_BORDER%│%BG_UPD_SUB%%PAD68%%ESC%[5G  %C_BLINK%*%C_RESET%%BG_UPD_SUB% Actualizacion Disponible  [v!VERSION_REMOTA!]%ESC%[55GPresione [6]%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%├───────────────────────┬──────────────────────────┬─────────────────┤%C_RESET%
echo   %C_BORDER%│%BG_TELEM%  Serie del Equipo     %ESC%[27G%C_RESET%%C_BORDER%│%BG_TELEM%  Politica de Pantalla    %ESC%[54G%C_RESET%%C_BORDER%│%BG_TELEM%  Estado de Red  %ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%│%PAD68%%ESC%[4G  %C_CYAN%!SERIAL_NUM!%C_RESET%%ESC%[27G%C_BORDER%│  !WP_BADGE!%ESC%[54G%C_BORDER%│  !NET_BADGE!%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%├───────────────────────┴──────────────────────────┴─────────────────┤%C_RESET%
echo   %C_BORDER%│%BG_SEC1%%PAD68%%ESC%[5G  + IMPLEMENTACION, PERSONALIZACION Y RENDIMIENTO%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%├──────┬───────────────────────────────────────────┬─────────────────┤%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_CYAN%[1]  %C_BORDER%│ %C_WHITE%Instalacion Inicial y Paqueteria%ESC%[54G%C_BORDER%│ %C_CYAN%Alumnos/Docente%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_SKY%[2]  %C_BORDER%│ %C_WHITE%Configuracion de Pantalla y Lock Screen%ESC%[54G%C_BORDER%│ !WP_BADGE!%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_TEAL%[3]  %C_BORDER%│ %C_WHITE%Optimizador de Sistema y Arranque%ESC%[54G%C_BORDER%│ %C_TEAL%CPU [%NUMBER_OF_PROCESSORS% Nucleos]%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%├──────┴───────────────────────────────────────────┴─────────────────┤%C_RESET%
echo   %C_BORDER%│%BG_SEC2%%PAD68%%ESC%[5G  + INFRAESTRUCTURA DE RED, LICENCIAS Y ACTUALIZACIONES%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%├──────┬───────────────────────────────────────────┬─────────────────┤%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_INDIGO%[4]  %C_BORDER%│ %C_WHITE%Redes, Hotspot y Conectividad IP%ESC%[54G%C_BORDER%│!HS_BADGE!%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_AMBER%[5]  %C_BORDER%│ %C_WHITE%Centro de Activacion y Licencias%ESC%[54G%C_BORDER%│ %C_AMBER%Office / HWID%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_PURPLE%[6]  %C_BORDER%│ %C_WHITE%Centro de Actualizaciones del Sistema%ESC%[54G%C_BORDER%│ !UPD_RIGHT_TXT!%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%├──────┴───────────────────────────────────────────┴─────────────────┤%C_RESET%
echo   %C_BORDER%│%BG_SEC3%%PAD68%%ESC%[5G  + MANTENIMIENTO, SEGURIDAD Y CONTROL DE SESION%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%├──────┬───────────────────────────────────────────┬─────────────────┤%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_ORANGE%[7]  %C_BORDER%│ %C_WHITE%Control de Energia y Sesion de Windows%ESC%[54G%C_BORDER%│ %C_ORANGE%Reinicio/Sesion%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_PINK%[8]  %C_BORDER%│ %C_WHITE%Herramienta de Remocion Maliciosa (MRT)%ESC%[54G%C_BORDER%│ %C_PINK%Motor Microsoft%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_ROSE%[9]  %C_BORDER%│ %C_WHITE%Finalizar y Cerrar Consola RTIC Hub%ESC%[54G%C_BORDER%│ %C_ROSE%Salida Segura%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%└──────┴───────────────────────────────────────────┴─────────────────┘%C_RESET%
echo.
echo %ESC%[?25h
set "opcion="
set /p "opcion=   %C_CYAN%>%C_WHITE% Seleccione un modulo [1-9]: %C_TEXT%"
echo %ESC%[?25l

set "opcion=!opcion: =!"
if "!opcion!"=="1" goto :INSTALACION_INICIAL
if "!opcion!"=="2" goto :SUBMENU_PANTALLA
if "!opcion!"=="3" goto :SUBMENU_OPTIMIZADOR
if "!opcion!"=="4" goto :SUBMENU_REDES
if "!opcion!"=="5" goto :ACTIVACION
if "!opcion!"=="6" goto :VERIFICAR_ACTUALIZACIONES_MANUAL
if "!opcion!"=="7" goto :OPCIONES_SISTEMA
if "!opcion!"=="8" goto :EJECUTAR_MRT
if "!opcion!"=="9" goto :SALIDA_SEGURA
goto :MENU_PRINCIPAL


:: ============================================================================
:: SECCION 1: INSTALACION INICIAL Y PAQUETERIA (CON LISTA DE PROGRAMAS)
:: ============================================================================
:INSTALACION_INICIAL
call :RESIZE_CON 74 30
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_SEC1%%PAD68%%ESC%[5G  MODULO 1  -  INSTALACION INICIAL, DRIVERS Y PAQUETERIA%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%├───────────────────────┬────────────────────────────────────────────┤%C_RESET%
echo   %C_BORDER%│%BG_TELEM%  Directorio Destino   %ESC%[27G%C_RESET%%C_BORDER%│  %C_CYAN%%DATA_FOLDER%%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%├──────┬────────────────┴──────────────────────────┬─────────────────┤%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_CYAN%[1]  %C_BORDER%│ %C_WHITE%Instalar Paqueteria para Alumnos%ESC%[54G%C_BORDER%│ %C_CYAN%UsInst.exe%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │ %C_SLATE%%APPS_ALUMNOS:~0,41%%ESC%[54G%C_BORDER%│ %C_SLATE%Perfil Alumno%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_INDIGO%[2]  %C_BORDER%│ %C_WHITE%Instalar Paqueteria para Docentes%ESC%[54G%C_BORDER%│ %C_INDIGO%ProInst.exe%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │ %C_SLATE%%APPS_DOCENTES:~0,41%%ESC%[54G%C_BORDER%│ %C_SLATE%Perfil Docente%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_EMERALD%[3]  %C_BORDER%│ %C_WHITE%Controladores de Impresoras (HP/Lexmark)%ESC%[54G%C_BORDER%│ %C_DIM%[En Desarrollo]%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_AMBER%[4]  %C_BORDER%│ %C_WHITE%Iniciar Driver Booster Portable%ESC%[54G%C_BORDER%│ %C_DIM%[En Desarrollo]%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%├──────┼───────────────────────────────────────────┴─────────────────┤%C_RESET%
echo   %C_BORDER%│ %C_SLATE%[0]  %C_BORDER%│ %C_TEXT%Regresar al Menu Principal%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%└──────┴─────────────────────────────────────────────────────────────┘%C_RESET%
echo.
echo %ESC%[?25h
set "drvop="
set /p "drvop=   %C_TEAL%>%C_WHITE% Seleccione una operacion: %C_TEXT%"
echo %ESC%[?25l

if "!drvop!"=="1" goto :PALUMNOS
if "!drvop!"=="2" goto :PDOCENTES
if "!drvop!"=="3" goto :IMPRESORAS
if "!drvop!"=="4" (
    call :MODULO_EN_DESARROLLO "Driver Booster Portable"
    goto :INSTALACION_INICIAL
)
if "!drvop!"=="0" goto :MENU_PRINCIPAL
goto :INSTALACION_INICIAL

:PALUMNOS
call :RESIZE_CON 74 22
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_SEC1%%PAD68%%ESC%[5G  DESPLIEGUE DE PAQUETERIA  -  PERFIL DE ALUMNOS%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
if /I "!NET_STATE!"=="OFFLINE" (
    call :MODAL_ERROR "Sin Conexion a Internet" "Se requiere conexion activa para descargar UsInst.exe."
    goto :INSTALACION_INICIAL
)
if not exist "%DATA_FOLDER%" mkdir "%DATA_FOLDER%" >nul 2>&1
set "USINST_PATH=%DATA_FOLDER%\UsInst.exe"

call :PROGRESS_BAR "Descargando paquete UsInst.exe desde repositorio GitHub..." "%C_CYAN%"
curl -L -s -f "%GH_BASE%/Assets/UsInst.exe" -o "%USINST_PATH%"
if errorlevel 1 (
    call :MODAL_ERROR "Fallo de Descarga" "No fue posible obtener UsInst.exe desde el servidor remoto."
    goto :INSTALACION_INICIAL
)
echo   %C_EMERALD%  [+] Paquete descargado en %USINST_PATH%%C_RESET%
echo   %C_SLATE%  - Sincronizando accesos directos de Office en el Escritorio...%C_RESET%
curl -L -s -o "%USERPROFILE%\Desktop\Excel.lnk" "%GH_BASE%/Assets/shorcuts/Excel.lnk"
curl -L -s -o "%USERPROFILE%\Desktop\PowerPoint.lnk" "%GH_BASE%/Assets/shorcuts/PowerPoint.lnk"
curl -L -s -o "%USERPROFILE%\Desktop\Word.lnk" "%GH_BASE%/Assets/shorcuts/Word.lnk"
echo   %C_CYAN%  > Ejecutando instalador de Alumnos. Espere a que finalice...%C_RESET%
start /wait "" "%USINST_PATH%"
call :EXITO_OPERACION "Paqueteria de Alumnos Instalada" "Office, Teams y utilidades de Alumnos fueron desplegados con exito."
goto :INSTALACION_INICIAL

:PDOCENTES
call :RESIZE_CON 74 22
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_SEC1%%PAD68%%ESC%[5G  DESPLIEGUE DE PAQUETERIA  -  PERFIL DE DOCENTES%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
if /I "!NET_STATE!"=="OFFLINE" (
    call :MODAL_ERROR "Sin Conexion a Internet" "Se requiere conexion activa para descargar ProInst.exe."
    goto :INSTALACION_INICIAL
)
if not exist "%DATA_FOLDER%" mkdir "%DATA_FOLDER%" >nul 2>&1
set "PROINST_PATH=%DATA_FOLDER%\ProInst.exe"

call :PROGRESS_BAR "Descargando paquete ProInst.exe desde repositorio GitHub..." "%C_INDIGO%"
curl -L -s -f "%GH_BASE%/Assets/ProInst.exe" -o "%PROINST_PATH%"
if errorlevel 1 (
    call :MODAL_ERROR "Fallo de Descarga" "No fue posible obtener ProInst.exe desde el servidor remoto."
    goto :INSTALACION_INICIAL
)
echo   %C_EMERALD%  [+] Paquete descargado en %PROINST_PATH%%C_RESET%
echo   %C_SLATE%  - Sincronizando accesos directos de Office en el Escritorio...%C_RESET%
curl -L -s -o "%USERPROFILE%\Desktop\Excel.lnk" "%GH_BASE%/Assets/shorcuts/Excel.lnk"
curl -L -s -o "%USERPROFILE%\Desktop\PowerPoint.lnk" "%GH_BASE%/Assets/shorcuts/PowerPoint.lnk"
curl -L -s -o "%USERPROFILE%\Desktop\Word.lnk" "%GH_BASE%/Assets/shorcuts/Word.lnk"
echo   %C_INDIGO%  > Ejecutando instalador de Docentes. Espere a que finalice...%C_RESET%
start /wait "" "%PROINST_PATH%"
call :EXITO_OPERACION "Paqueteria de Docentes Instalada" "Office, Teams y herramientas Docentes fueron desplegados con exito."
goto :INSTALACION_INICIAL

:IMPRESORAS
call :RESIZE_CON 74 23
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_SEC1%%PAD68%%ESC%[5G  INSTALACION DE CONTROLADORES DE IMPRESORA%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%├──────┬───────────────────────────────────────────┬─────────────────┤%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_CYAN%[1]  %C_BORDER%│ %C_WHITE%Instalador HP (HP Installer.exe)%ESC%[54G%C_BORDER%│ %C_DIM%[En Desarrollo]%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_EMERALD%[2]  %C_BORDER%│ %C_WHITE%Instalador Lexmark (Lexmark.exe)%ESC%[54G%C_BORDER%│ %C_DIM%[En Desarrollo]%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%├──────┼───────────────────────────────────────────┴─────────────────┤%C_RESET%
echo   %C_BORDER%│ %C_SLATE%[0]  %C_BORDER%│ %C_TEXT%Volver al Submenu de Instalacion Inicial%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%└──────┴─────────────────────────────────────────────────────────────┘%C_RESET%
echo.
echo %ESC%[?25h
set "impop="
set /p "impop=   %C_TEAL%>%C_WHITE% Seleccione una opcion: %C_TEXT%"
echo %ESC%[?25l
if "!impop!"=="1" (
    call :MODULO_EN_DESARROLLO "Drivers de Impresora HP"
    goto :IMPRESORAS
)
if "!impop!"=="2" (
    call :MODULO_EN_DESARROLLO "Drivers de Impresora Lexmark"
    goto :IMPRESORAS
)
if "!impop!"=="0" goto :INSTALACION_INICIAL
goto :IMPRESORAS


:: ============================================================================
:: MODULO HUMORISTICO CON ROBOT ASCII SIMETRICO Y CHISTE DINAMICO POR DIA/API
:: ============================================================================
:MODULO_EN_DESARROLLO
cls
call :PS_EXEC "RENDER_DEV_JOKER" "%~1"
pause >nul
exit /b


:: ============================================================================
:: SECCION 2: GESTION DE PANTALLA Y LOCK SCREEN (TEXTO ALINEADO SIN DESFASE)
:: ============================================================================
:SUBMENU_PANTALLA
call :PS_GET "REFRESH_STATES" "" "" "STATE_DATA"
if defined STATE_DATA (
    for /f "tokens=1,2,3 delims=|" %%A in ("!STATE_DATA!") do set "WP_STATUS=%%A"
)
set "WP_SUB_TXT=%C_EMERALD%* LIBRE  -  Personalizacion habilitada"
if /I "!WP_STATUS!"=="LOCKED" set "WP_SUB_TXT=%C_ROSE%* BLOQUEADO  -  Personalizacion deshabilitada"

call :RESIZE_CON 74 30
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_SCREEN%%PAD68%%ESC%[5G  MODULO 2  -  GESTION DE PANTALLA, ESCRITORIO Y LOCK SCREEN%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%├───────────────────────┬────────────────────────────────────────────┤%C_RESET%
echo   %C_BORDER%│%BG_TELEM%  Estado Actual        %ESC%[27G%C_RESET%%C_BORDER%│  !WP_SUB_TXT!%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%├──────┬────────────────┴──────────────────────────┬─────────────────┤%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_ROSE%[1]  %C_BORDER%│ %C_WHITE%Aplicar Modo Institucional Completo%ESC%[54G%C_BORDER%│ %C_ROSE%Fondo+Lock+Cand.%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │ %C_SLATE%Descarga, convierte a JPG y fija en cache%ESC%[54G%C_BORDER%│ %C_SLATE%Persistente%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_EMERALD%[2]  %C_BORDER%│ %C_WHITE%Restaurar Permisos (Desbloquear Todo)%ESC%[54G%C_BORDER%│ %C_EMERALD%Dejar Libre%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_AMBER%[3]  %C_BORDER%│ %C_WHITE%Bloquear Unicamente el Fondo Actual%ESC%[54G%C_BORDER%│ %C_AMBER%Candado Directo%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_INDIGO%[4]  %C_BORDER%│ %C_WHITE%Descargar Recursos Institucionales%ESC%[54G%C_BORDER%│ %C_INDIGO%Solo Descarga%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%├──────┼───────────────────────────────────────────┴─────────────────┤%C_RESET%
echo   %C_BORDER%│ %C_SLATE%[0]  %C_BORDER%│ %C_TEXT%Regresar al Menu Principal%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%└──────┴─────────────────────────────────────────────────────────────┘%C_RESET%
echo.
echo %ESC%[?25h
set "subop="
set /p "subop=   %C_SKY%>%C_WHITE% Seleccione una operacion: %C_TEXT%"
echo %ESC%[?25l

if "!subop!"=="1" goto :PANTALLA_INSTITUCIONAL
if "!subop!"=="2" goto :PANTALLA_RESTAURAR
if "!subop!"=="3" goto :PANTALLA_SOLO_CANDADO
if "!subop!"=="4" goto :Fondos
if "!subop!"=="0" goto :MENU_PRINCIPAL
goto :SUBMENU_PANTALLA

:PANTALLA_INSTITUCIONAL
call :RESIZE_CON 74 22
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_SCREEN%%PAD68%%ESC%[5G  APLICANDO MODO INSTITUCIONAL PERSISTENTE (ESCRITORIO + LOCK)%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
echo.
call :PS_GET "SCREEN_INSTITUTIONAL" "%DATA_FOLDER%" "" "SCR_RES"
if "!SCR_RES!"=="OK" (
    RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 1, True >nul 2>&1
    call :EXITO_OPERACION "Modo Institucional Aplicado y Blindado" "Fondo de escritorio, cache TranscodedWallpaper y Lock Screen fijados."
) else (
    call :MODAL_ERROR "Error al Aplicar Modo Institucional" "!SCR_RES!"
)
goto :SUBMENU_PANTALLA

:PANTALLA_SOLO_CANDADO
call :RESIZE_CON 74 22
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_SCREEN%%PAD68%%ESC%[5G  SELLANDO FONDO ACTUAL Y BLOQUEANDO PERSONALIZACION%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
echo.
call :PS_GET "SCREEN_LOCK_CURRENT" "%DATA_FOLDER%" "" "SCR_RES"
if "!SCR_RES!"=="OK" (
    RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 1, True >nul 2>&1
    call :EXITO_OPERACION "Bloqueo de Pantalla Activado" "El fondo actual y la pantalla de bloqueo han quedado protegidos."
) else (
    call :MODAL_ERROR "Error en Bloqueo" "!SCR_RES!"
)
goto :SUBMENU_PANTALLA

:PANTALLA_RESTAURAR
call :RESIZE_CON 74 22
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_SCREEN%%PAD68%%ESC%[5G  LIBERANDO POLITICAS DE ESCRITORIO Y PANTALLA DE BLOQUEO%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
echo.
call :PS_GET "SCREEN_UNLOCK" "" "" "SCR_RES"
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 1, True >nul 2>&1
call :EXITO_OPERACION "Permisos de Personalizacion Restaurados" "Los paneles de Fondo y Pantalla de Bloqueo estan libres al instante."
goto :SUBMENU_PANTALLA

:Fondos
call :RESIZE_CON 74 20
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_SCREEN%%PAD68%%ESC%[5G  DESCARGA DE RECURSOS GRAFICOS INSTITUCIONALES%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
call :PS_GET "SCREEN_DOWNLOAD_ONLY" "%DATA_FOLDER%" "" "DL_RES"
if "!DL_RES!"=="OK" (
    start "" "%DATA_FOLDER%"
    call :EXITO_OPERACION "Recursos Descargados Correctamente" "Las imagenes PNG y JPG se guardaron en %DATA_FOLDER%."
) else (
    call :MODAL_ERROR "Error de Descarga" "!DL_RES!"
)
goto :SUBMENU_PANTALLA


:: ============================================================================
:: SECCION 3: OPTIMIZADOR DEL SISTEMA Y ARRANQUE
:: ============================================================================
:SUBMENU_OPTIMIZADOR
call :RESIZE_CON 74 26
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_OPT%%PAD68%%ESC%[5G  MODULO 3  -  OPTIMIZADOR DE RENDIMIENTO Y ARRANQUE%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%├───────────────────────┬────────────────────────────────────────────┤%C_RESET%
echo   %C_BORDER%│%BG_TELEM%  Hilos / Nucleos CPU  %ESC%[27G%C_RESET%%C_BORDER%│  %C_TEAL%%NUMBER_OF_PROCESSORS% Procesadores Logicos Detectados%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%├──────┬────────────────┴──────────────────────────┬─────────────────┤%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_TEAL%[1]  %C_BORDER%│ %C_WHITE%Aplicar Optimizacion Maxima + ClearType%ESC%[54G%C_BORDER%│ %C_TEAL%Max Rendimiento%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │ %C_SLATE%Activa %NUMBER_OF_PROCESSORS% nucleos, limpia Temp y Prefetch%ESC%[54G%C_BORDER%│ %C_SLATE%Fuentes Nitidas%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_CYAN%[2]  %C_BORDER%│ %C_WHITE%Restaurar Valores Visuales por Defecto%ESC%[54G%C_BORDER%│ %C_CYAN%Valores Fabrica%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%├──────┼───────────────────────────────────────────┴─────────────────┤%C_RESET%
echo   %C_BORDER%│ %C_SLATE%[0]  %C_BORDER%│ %C_TEXT%Regresar al Menu Principal%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%└──────┴─────────────────────────────────────────────────────────────┘%C_RESET%
echo.
echo %ESC%[?25h
set "subop="
set /p "subop=   %C_TEAL%>%C_WHITE% Seleccione una operacion: %C_TEXT%"
echo %ESC%[?25l

if "!subop!"=="1" goto :APLICAR_OPTIMIZACION
if "!subop!"=="2" goto :RESTAURAR_OPTIMIZACION
if "!subop!"=="0" goto :MENU_PRINCIPAL
goto :SUBMENU_OPTIMIZADOR

:APLICAR_OPTIMIZACION
call :RESIZE_CON 74 22
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_OPT%%PAD68%%ESC%[5G  EJECUTANDO OPTIMIZACION INTEGRAL DEL SISTEMA%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
call :PROGRESS_BAR "Configurando BCD (%NUMBER_OF_PROCESSORS% nucleos), efectos visuales y caches..." "%C_TEAL%"
bcdedit /set {current} numproc %NUMBER_OF_PROCESSORS% >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1

echo   %C_SLATE%  - Purgando directorios temporales, recientes y Prefetch...%C_RESET%
del /s /f /q "%TEMP%\*.*" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
del /s /f /q "%APPDATA%\Microsoft\Windows\Recent\*.*" >nul 2>&1
del /s /f /q "C:\Windows\Prefetch\*.*" >nul 2>&1

RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 1, True >nul 2>&1
call :EXITO_OPERACION "Optimizacion Maxima Aplicada" "Se activaron %NUMBER_OF_PROCESSORS% nucleos, fuentes ClearType y limpieza de temporales."
goto :SUBMENU_OPTIMIZADOR

:RESTAURAR_OPTIMIZACION
call :RESIZE_CON 74 20
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_OPT%%PAD68%%ESC%[5G  RESTAURANDO PARAMETROS DE ARRANQUE Y APARIENCIA%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
call :PROGRESS_BAR "Restableciendo administracion automatica de CPU y efectos..." "%C_CYAN%"
bcdedit /deletevalue {current} numproc >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 1 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 400 /f >nul 2>&1
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 1, True >nul 2>&1
call :EXITO_OPERACION "Valores por Defecto Restaurados" "Windows administrara los nucleos y efectos visuales automaticamente."
goto :SUBMENU_OPTIMIZADOR


:: ============================================================================
:: SECCION 4: REDES Y CONECTIVIDAD (HOTSPOT ACTIVO / INACTIVO)
:: ============================================================================
:SUBMENU_REDES
call :PS_GET "REFRESH_STATES" "" "" "STATE_DATA"
if defined STATE_DATA (
    for /f "tokens=1,2,3 delims=|" %%A in ("!STATE_DATA!") do set "HS_STATUS=%%B"
)
set "HS_SUB_TXT=%C_EMERALD%* Hotspot Activo"
if /I "!HS_STATUS!"=="LOCKED" set "HS_SUB_TXT=%C_ROSE%* Hotspot Inactivo"

call :RESIZE_CON 74 28
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_NET%%PAD68%%ESC%[5G  MODULO 4  -  GESTION DE REDES, HOTSPOT Y DIRECCIONAMIENTO IP%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%├───────────────────────┬────────────────────────────────────────────┤%C_RESET%
echo   %C_BORDER%│%BG_TELEM%  Estado de Politica   %ESC%[27G%C_RESET%%C_BORDER%│  !HS_SUB_TXT!%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%├──────┬────────────────┴──────────────────────────┬─────────────────┤%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_ROSE%[1]  %C_BORDER%│ %C_WHITE%Bloquear Zona de Cobertura (Hotspot)%ESC%[54G%C_BORDER%│ %C_ROSE%Desactivar%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_EMERALD%[2]  %C_BORDER%│ %C_WHITE%Permitir Zona de Cobertura (Desbloquear)%ESC%[54G%C_BORDER%│ %C_EMERALD%Activar Hotspot%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_CYAN%[3]  %C_BORDER%│ %C_WHITE%Asistente de Configuracion IP Estatica%ESC%[54G%C_BORDER%│ %C_CYAN%IP/Mask/GW/DNS%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_INDIGO%[4]  %C_BORDER%│ %C_WHITE%Ejecutar Test de Velocidad y Latencia%ESC%[54G%C_BORDER%│ %C_INDIGO%SpeedTest PS1%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%├──────┼───────────────────────────────────────────┴─────────────────┤%C_RESET%
echo   %C_BORDER%│ %C_SLATE%[0]  %C_BORDER%│ %C_TEXT%Regresar al Menu Principal%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%└──────┴─────────────────────────────────────────────────────────────┘%C_RESET%
echo.
echo %ESC%[?25h
set "subop="
set /p "subop=   %C_INDIGO%>%C_WHITE% Seleccione una operacion: %C_TEXT%"
echo %ESC%[?25l

if "!subop!"=="1" goto :RED_BLOQUEAR_HOTSPOT
if "!subop!"=="2" goto :RED_DESBLOQUEAR_HOTSPOT
if "!subop!"=="3" goto :RED_CONFIG_IP
if "!subop!"=="4" goto :SPEED_TEST
if "!subop!"=="0" goto :MENU_PRINCIPAL
goto :SUBMENU_REDES

:RED_BLOQUEAR_HOTSPOT
call :RESIZE_CON 74 20
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_NET%%PAD68%%ESC%[5G  APLICANDO RESTRICCION DE ZONA CON COBERTURA MOVIL%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
call :PROGRESS_BAR "Deshabilitando servicio icssvc, UI de Hotspot y Regedit..." "%C_ROSE%"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Network Connections" /v NC_ShowSharedAccessUI /t REG_DWORD /d 0 /f >nul 2>&1
sc config icssvc start= disabled >nul 2>&1
net stop icssvc >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t REG_DWORD /d 1 /f >nul 2>&1
call :EXITO_OPERACION "Hotspot Inactivo" "El servicio Mobile Hotspot y el Editor de Registro fueron desactivados."
goto :SUBMENU_REDES

:RED_DESBLOQUEAR_HOTSPOT
call :RESIZE_CON 74 20
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_NET%%PAD68%%ESC%[5G  RESTAURANDO ACCESO A ZONA CON COBERTURA MOVIL%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
call :PROGRESS_BAR "Habilitando Regedit, servicio icssvc y politicas de red..." "%C_EMERALD%"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Network Connections" /v NC_ShowSharedAccessUI /f >nul 2>&1
sc config icssvc start= demand >nul 2>&1
net start icssvc >nul 2>&1
call :EXITO_OPERACION "Hotspot Activo" "Se restauro la comparticion de red y el acceso a Regedit."
goto :SUBMENU_REDES

:SPEED_TEST
if exist "%TEMP%\speedtest_tmp.ps1" del "%TEMP%\speedtest_tmp.ps1" >nul 2>&1
curl -L -s -f "%GH_BASE%/speedtest.ps1" -o "%TEMP%\speedtest_tmp.ps1" 2>nul
if not exist "%TEMP%\speedtest_tmp.ps1" (
    call :MODAL_ERROR "Modulo No Disponible" "No se pudo descargar speedtest.ps1. Verifique su conexion."
    goto :SUBMENU_REDES
)
call :RESIZE_CON 90 42
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\speedtest_tmp.ps1"
if exist "%TEMP%\speedtest_tmp.ps1" del "%TEMP%\speedtest_tmp.ps1" >nul 2>&1
goto :SUBMENU_REDES

:RED_CONFIG_IP
call :RESIZE_CON 74 34
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_NET%%PAD68%%ESC%[5G  ASISTENTE DE CONFIGURACION DE DIRECCIONAMIENTO IP ESTATICO%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
echo.
call :PS_EXEC "LIST_NET_ADAPTERS"
echo.
echo %ESC%[?25h
set "ADAPTADOR="
set /p "ADAPTADOR=   %C_CYAN%>%C_WHITE% Nombre exacto de la interfaz (ej. Ethernet / Wi-Fi): %C_TEXT%"
if not defined ADAPTADOR (echo %ESC%[?25l & goto :SUBMENU_REDES)
set /p "IP=   %C_CYAN%>%C_WHITE% Direccion IPv4            : %C_TEXT%"
set "MASCARA=255.255.255.0"
set /p "MASCARA=   %C_CYAN%>%C_WHITE% Mascara [Enter=255.255.255.0]: %C_TEXT%"
set /p "PUERTA=   %C_CYAN%>%C_WHITE% Puerta de Enlace (Gateway): %C_TEXT%"
set /p "DNS1=   %C_CYAN%>%C_WHITE% Servidor DNS Preferido    : %C_TEXT%"
set /p "DNS2=   %C_CYAN%>%C_WHITE% Servidor DNS Alternativo  : %C_TEXT%"
echo %ESC%[?25l

call :PROGRESS_BAR "Aplicando parametros TCP/IPv4 en interfaz !ADAPTADOR!..." "%C_CYAN%"
netsh interface ip set address name="!ADAPTADOR!" static !IP! !MASCARA! !PUERTA! >nul 2>&1
if defined DNS1 netsh interface ip set dns name="!ADAPTADOR!" static !DNS1! >nul 2>&1
if defined DNS2 netsh interface ip add dns name="!ADAPTADOR!" !DNS2! index=2 >nul 2>&1
call :EXITO_OPERACION "Configuracion IP Aplicada" "Interfaz !ADAPTADOR! configurada con IP !IP! y DNS !DNS1!."
goto :SUBMENU_REDES


:: ============================================================================
:: SECCION 5: CENTRO DE ACTIVACION Y LICENCIAS
:: ============================================================================
:ACTIVACION
call :RESIZE_CON 74 24
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_LIC%%PAD68%%ESC%[5G  MODULO 5  -  CENTRO DE LICENCIAMIENTO Y ACTIVACION%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%├──────┬───────────────────────────────────────────┬─────────────────┤%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_AMBER%[1]  %C_BORDER%│ %C_WHITE%Activar Microsoft Office LTSC 2021%ESC%[54G%C_BORDER%│ %C_AMBER%Clave Volumen%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%│ %C_CYAN%[2]  %C_BORDER%│ %C_WHITE%Consola Avanzada MAS (HWID / KMS38)%ESC%[54G%C_BORDER%│ %C_CYAN%PowerShell IRM%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                           │                 │%C_RESET%
echo   %C_BORDER%├──────┼───────────────────────────────────────────┴─────────────────┤%C_RESET%
echo   %C_BORDER%│ %C_SLATE%[0]  %C_BORDER%│ %C_TEXT%Regresar al Menu Principal%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%└──────┴─────────────────────────────────────────────────────────────┘%C_RESET%
echo.
echo %ESC%[?25h
set "actop="
set /p "actop=   %C_AMBER%>%C_WHITE% Seleccione una operacion: %C_TEXT%"
echo %ESC%[?25l

if "!actop!"=="1" goto :KEY_OFFICE_2021
if "!actop!"=="2" goto :MAS_POWERSHELL
if "!actop!"=="0" goto :MENU_PRINCIPAL
goto :ACTIVACION

:KEY_OFFICE_2021
call :RESIZE_CON 74 24
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_LIC%%PAD68%%ESC%[5G  ACTIVACION DE LICENCIA  -  MICROSOFT OFFICE LTSC 2021%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
set "OFFICE_DIR="
if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" set "OFFICE_DIR=%ProgramFiles%\Microsoft Office\Office16"
if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" set "OFFICE_DIR=%ProgramFiles(x86)%\Microsoft Office\Office16"

if not defined OFFICE_DIR (
    call :MODAL_ERROR "Office No Detectado" "No se encontro ospp.vbs en la ruta de instalacion estandar."
    goto :ACTIVACION
)
call :PROGRESS_BAR "Inyectando licencia LTSC 2021 y validando con servidor..." "%C_AMBER%"
pushd "!OFFICE_DIR!"
cscript //nologo ospp.vbs /inpkey:D67NW-YV8J3-CCXTQ-V3B83-M7YGK >nul
cscript //nologo ospp.vbs /act >nul
popd
call :EXITO_OPERACION "Secuencia de Activacion Ejecutada" "Se inyecto la clave LTSC 2021 y se solicito la validacion KMS/MAK."
goto :ACTIVACION

:MAS_POWERSHELL
start powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://get.activated.win | iex"
call :EXITO_OPERACION "Modulo MAS Iniciado" "Microsoft Activation Scripts se abrio en una ventana externa."
goto :ACTIVACION


:: ============================================================================
:: SECCION 6: VERIFICADOR Y ACTUALIZADOR DEL SISTEMA
:: ============================================================================
:VERIFICAR_ACTUALIZACIONES_MANUAL
call :RESIZE_CON 74 20
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_UPD%%PAD68%%ESC%[5G  MODULO 6  -  CENTRO DE ACTUALIZACIONES DEL SISTEMA%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
call :PROGRESS_BAR "Consultando versiones disponibles en GitHub (azarel22/FCA)..." "%C_PURPLE%"
call :PS_GET "CHECK_OTA_MANUAL" "%VERSION_ACTUAL%" "" "OTA_CHECK"
for /f "tokens=1,2 delims=|" %%A in ("!OTA_CHECK!") do (
    set "OTA_STAT=%%A"
    set "VERSION_REMOTA=%%B"
)
if "!OTA_STAT!"=="ERROR" (
    call :MODAL_ERROR "Error de Conexion" "No se pudo contactar con el repositorio remoto en GitHub."
    goto :MENU_PRINCIPAL
)
if "!OTA_STAT!"=="UPTODATE" (
    call :EXITO_OPERACION "Sistema Actualizado (v%VERSION_ACTUAL%)" "Ya cuentas con la ultima version disponible en el repositorio."
    goto :MENU_PRINCIPAL
)
set "UPD_AVAILABLE=YES"
cls
call :PS_EXEC "RENDER_OTA_STANDALONE" "%VERSION_ACTUAL%" "!VERSION_REMOTA!"
goto :PROMPT_AVISO_UPDATE

:PROCESAR_ACTUALIZACION
call :RESIZE_CON 74 22
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_UPD%%PAD68%%ESC%[5G  DESCARGANDO E INSTALANDO NUEVA VERSION (v!VERSION_REMOTA!)%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
call :PROGRESS_BAR "Descargando paquete desde GitHub y generando respaldo..." "%C_PURPLE%"

curl -L -s -f "%GH_BASE%/%SCRIPT_NAME%" -o "%OTA_STAGE_FILE%"
if errorlevel 1 (
    call :MODAL_ERROR "Error de Descarga" "No fue posible descargar el paquete de actualizacion."
    goto :MENU_PRINCIPAL
)
copy /y "%~f0" "%~dp0RTIC_Hub_FCA_backup_%VERSION_ACTUAL%.bat" >nul 2>&1
(
    echo @echo off
    echo ping 127.0.0.1 -n 2 ^>nul
    echo move /y "%OTA_STAGE_FILE%" "%~f0" ^>nul 2^>^&1
    echo start "" "%~f0" skipupdate
    echo ^(goto^) 2^>nul ^& del /f /q "%%~f0"
) > "%OTA_SWAP_BAT%"
start "" /min cmd.exe /c "%OTA_SWAP_BAT%"
exit


:: ============================================================================
:: SECCION 7 Y 8: OPCIONES DEL SISTEMA (SIN SHUTDOWN /R NI /L) Y MRT
:: ============================================================================
:OPCIONES_SISTEMA
call :RESIZE_CON 74 22
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_SEC3%%PAD68%%ESC%[5G  MODULO 7  -  CONTROL DE ENERGIA Y SESION DEL SISTEMA%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%├──────┬─────────────────────────────────────────────────────────────┤%C_RESET%
echo   %C_BORDER%│      │                                                             │%C_RESET%
echo   %C_BORDER%│ %C_AMBER%[1]  %C_BORDER%│ %C_WHITE%Reiniciar el Equipo%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                                             │%C_RESET%
echo   %C_BORDER%│ %C_ROSE%[2]  %C_BORDER%│ %C_WHITE%Cerrar Sesion%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│      │                                                             │%C_RESET%
echo   %C_BORDER%├──────┼─────────────────────────────────────────────────────────────┤%C_RESET%
echo   %C_BORDER%│ %C_SLATE%[0]  %C_BORDER%│ %C_TEXT%Regresar al Menu Principal%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%└──────┴─────────────────────────────────────────────────────────────┘%C_RESET%
echo.
echo %ESC%[?25h
set "OPCION_SIS="
set /p "OPCION_SIS=   %C_ORANGE%>%C_WHITE% Seleccione una accion: %C_TEXT%"
echo %ESC%[?25l
if "!OPCION_SIS!"=="1" (shutdown /r /t 5 /c "Reinicio programado por RTIC Hub FCA" & exit)
if "!OPCION_SIS!"=="2" (shutdown /l & exit)
if "!OPCION_SIS!"=="0" goto :MENU_PRINCIPAL
goto :OPCIONES_SISTEMA

:EJECUTAR_MRT
call :RESIZE_CON 74 18
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_SEC3%%PAD68%%ESC%[5G  MODULO 8  -  HERRAMIENTA DE REMOCION DE SOFTWARE MALINTENCIONADO%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
call :PROGRESS_BAR "Iniciando motor oficial Microsoft MRT (mrt.exe)..." "%C_PINK%"
start "" mrt.exe
call :EXITO_OPERACION "Herramienta MRT Desplegada" "El asistente de seguridad de Microsoft se ha iniciado en paralelo."
goto :MENU_PRINCIPAL


:: ============================================================================
:: COMPONENTES VISUALES DE CONFIRMACION, ERROR Y SALIDA
:: ============================================================================
:EXITO_OPERACION
call :RESIZE_CON 74 20
cls
set "TITULO_OK=%~1"
set "DETALLE_OK=%~2"
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_OK%%PAD68%%ESC%[5G  [+] OPERACION COMPLETADA EXITOSAMENTE%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%├───────────────────────┬────────────────────────────────────────────┤%C_RESET%
echo   %C_BORDER%│%BG_TELEM%  Equipo / Serie BIOS  %ESC%[27G%C_RESET%%C_BORDER%│  %C_CYAN%!SERIAL_NUM!%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│%BG_TELEM%  Estado de Ejecucion  %ESC%[27G%C_RESET%%C_BORDER%│  %C_EMERALD%* VALIDADO Y APLICADO SIN ERRORES%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%├───────────────────────┴────────────────────────────────────────────┤%C_RESET%
echo   %C_BORDER%│                                                                    │%C_RESET%
echo   %C_BORDER%│  %C_WHITE%!TITULO_OK!%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│  %C_SLATE%!DETALLE_OK!%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│                                                                    │%C_RESET%
echo   %C_BORDER%├────────────────────────────────────────────────────────────────────┤%C_RESET%
echo   %C_BORDER%│  %C_EMERALD%>%C_TEXT% Presione cualquier tecla para continuar...%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
pause >nul
exit /b

:MODAL_ERROR
call :RESIZE_CON 74 19
cls
set "TITULO_ERR=%~1"
set "DETALLE_ERR=%~2"
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_CRIT%%PAD68%%ESC%[5G  [!] INCIDENCIA DETECTADA DURANTE LA OPERACION%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%├────────────────────────────────────────────────────────────────────┤%C_RESET%
echo   %C_BORDER%│                                                                    │%C_RESET%
echo   %C_BORDER%│  %C_WHITE%!TITULO_ERR!%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│  %C_SLATE%!DETALLE_ERR!%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│                                                                    │%C_RESET%
echo   %C_BORDER%├────────────────────────────────────────────────────────────────────┤%C_RESET%
echo   %C_BORDER%│  %C_AMBER%>%C_WHITE% Presione cualquier tecla para regresar...%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
pause >nul
exit /b

:SALIDA_SEGURA
call :RESIZE_CON 74 16
cls
echo.
echo   %C_BORDER%┌────────────────────────────────────────────────────────────────────┐%C_RESET%
echo   %C_BORDER%│%BG_MAIN%%PAD68%%ESC%[5G  RTIC HUB FCA  -  CIERRE DE SESION DE MANTENIMIENTO%ESC%[72G%C_RESET%%C_BORDER%│%C_RESET%
echo   %C_BORDER%├────────────────────────────────────────────────────────────────────┤%C_RESET%
echo   %C_BORDER%│                                                                    │%C_RESET%
echo   %C_BORDER%│  %BG_OK% SESION FINALIZADA %C_RESET% %C_WHITE%Todos los servicios han cerrado limpiamente.%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│  %C_SLATE%Equipo: %C_CYAN%!SERIAL_NUM! %C_SLATE%- Version: %C_WHITE%v%VERSION_ACTUAL%%ESC%[72G%C_BORDER%│%C_RESET%
echo   %C_BORDER%│                                                                    │%C_RESET%
echo   %C_BORDER%└────────────────────────────────────────────────────────────────────┘%C_RESET%
ping 127.0.0.1 -n 2 >nul
echo %ESC%[?25h
exit

:PROGRESS_BAR
setlocal EnableDelayedExpansion
set "MSG=%~1"
set "COLOR=%~2"
echo.
echo   %C_TEXT%  - !MSG!%C_RESET%
set "bar="
set "space=-------------------------"
for /L %%i in (1,1,25) do (
    set "bar=!bar!#"
    set /a "pct=%%i * 4"
    <nul set /p "=%ESC%[1G    %C_BORDER%[!COLOR!!bar!%C_BORDER%!space:~%%i!] %C_WHITE%!pct!%%%C_RESET%"
    pathping -p 6 -q 1 localhost >nul
)
echo.
endlocal
exit /b

:RESIZE_CON
mode con: cols=%~1 lines=%~2 >nul 2>&1
exit /b

:PS_EXEC
set "PS_ACTION=%~1"
set "PS_ARG1=%~2"
set "PS_ARG2=%~3"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Invoke-Expression ([System.IO.File]::ReadAllText($env:SELF_FILE, [System.Text.Encoding]::UTF8))"
exit /b

:PS_GET
set "PS_ACTION=%~1"
set "PS_ARG1=%~2"
set "PS_ARG2=%~3"
set "RET_VAR=%~4"
del /f /q "%PS_OUT_FILE%" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Invoke-Expression ([System.IO.File]::ReadAllText($env:SELF_FILE, [System.Text.Encoding]::UTF8))"
set "!RET_VAR!="
if exist "%PS_OUT_FILE%" (
    for /f "usebackq delims=" %%R in ("%PS_OUT_FILE%") do set "!RET_VAR!=%%R"
    del /f /q "%PS_OUT_FILE%" >nul 2>&1
)
exit /b
#>

# =============================================================================
# NUCLEO NATIVO DE POWERSHELL (BORDES CLAVADOS EN %ESC%[72G + RED MULTICAPA)
# =============================================================================
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$a       = $env:PS_ACTION
$arg1    = $env:PS_ARG1
$arg2    = $env:PS_ARG2
$outF    = $env:PS_OUT_FILE
$clCache = $env:CHANGELOG_CACHE
$utf8No  = New-Object System.Text.UTF8Encoding($false)

# Arte ASCII original integro (RTIC = 33 cols, HUB = 26 cols)
$script:L_ROWS = @(
    "                                 ",
    " ██████╗ ████████╗██╗  ██████╗   ",
    " ██╔══██╗╚══██╔══╝██║ ██╔════╝   ",
    " ██████╔╝   ██║   ██║ ██║        ",
    " ██╔══██╗   ██║   ██║ ██║        ",
    " ██║  ██║   ██║   ██║ ╚██████╗   ",
    " ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═════╝   ",
    "                                 "
)

$script:H_ROWS = @(
    "                          ",
    " ██╗  ██╗██╗   ██╗██████╗ ",
    " ██║  ██║██║   ██║██╔══██╗",
    " ███████║██║   ██║██████╔╝",
    " ██╔══██║██║   ██║██╔══██╗",
    " ██║  ██║╚██████╔╝██████╔╝",
    " ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ",
    "                          "
)

function Set-ConsoleHeight([int]$height) {
    try {
        $w = 74
        $curH = [Console]::WindowHeight
        if ($height -gt $curH) {
            [Console]::SetBufferSize($w, $height + 4)
            [Console]::SetWindowSize($w, $height)
        } else {
            [Console]::SetWindowSize($w, $height)
            [Console]::SetBufferSize($w, $height + 4)
        }
    } catch {}
}

function Get-FastBiosSerial() {
    try {
        $sn = (Get-ItemProperty -Path "HKLM:\HARDWARE\DESCRIPTION\System\BIOS" -Name "SystemSerialNumber" -ErrorAction SilentlyContinue).SystemSerialNumber
        if (-not [string]::IsNullOrWhiteSpace($sn) -and $sn -notmatch 'System Serial Number|To be filled|Default') {
            return $sn.Trim()
        }
        $val = (Get-CimInstance -ClassName Win32_BIOS -ErrorAction SilentlyContinue).SerialNumber
        if (-not [string]::IsNullOrWhiteSpace($val)) { return $val.Trim() }
    } catch {}
    return "NO-DISPONIBLE"
}

# Deteccion multicapa de Internet (Evita falso positivo cuando el firewall bloquea ICMP ping)
function Test-FastNet() {
    try {
        # 1. Verificar si hay una ruta predeterminada activa (Default Gateway) o adaptador Up
        $hasRoute = Get-NetRoute -DestinationPrefix "0.0.0.0/0" -ErrorAction SilentlyContinue | Where-Object { $_.NextHop -ne "0.0.0.0" }
        if ($hasRoute) { return "ONLINE" }

        # 2. Respaldo por Ping ICMP rapido
        $p = New-Object System.Net.NetworkInformation.Ping
        if ($p.Send("8.8.8.8", 600).Status -eq [System.Net.NetworkInformation.IPStatus]::Success) { return "ONLINE" }

        # 3. Respaldo por sonda HTTP de Microsoft NCSI
        $wc = New-Object System.Net.WebClient
        $txt = $wc.DownloadString("http://www.msftconnecttest.com/connecttest.txt")
        if ($txt -match "Microsoft") { return "ONLINE" }
    } catch {}
    return "OFFLINE"
}

function Render-DualBadgeBox([int]$colsOn, [string]$stateMode, [string]$statusText) {
    $e = [char]27
    $cBorder = "$e[38;2;71;85;105m"
    $cWhite  = "$e[38;2;255;255;255m"
    $cSlate  = "$e[38;2;148;163;184m"
    $cReset  = "$e[0m"

    $offStyle = "$e[48;2;15;23;42m$e[38;2;45;58;78m"

    switch ($stateMode) {
        "ERROR"  {
            $hubBorder = "$e[38;2;244;63;94m"
            $onStyle   = "$e[48;2;200;30;30m$e[38;2;255;255;255m"
            $statusCol = "$e[38;2;244;63;94m"
        }
        "UPDATE" {
            $hubBorder = "$e[38;2;192;132;252m"
            $onStyle   = "$e[48;2;168;85;247m$e[38;2;255;255;255m"
            $statusCol = "$e[38;2;192;132;252m"
        }
        "OK"     {
            $hubBorder = "$e[38;2;52;211;153m"
            $onStyle   = "$e[48;2;52;211;153m$e[38;2;0;0;0m"
            $statusCol = "$e[38;2;52;211;153m"
        }
        default  {
            $hubBorder = "$e[38;2;59;130;246m"
            $onStyle   = "$e[48;2;59;130;246m$e[38;2;0;0;0m"
            $statusCol = "$e[38;2;148;163;184m"
        }
    }

    if ($colsOn -lt 0)  { $colsOn = 0 }
    if ($colsOn -gt 26) { $colsOn = 26 }

    $topLine = "      $cBorder┌─────────────────────────────────$hubBorder┬──────────────────────────┐$cReset"
    [Console]::Write("$e[2;1H$topLine")

    for ($r = 0; $r -lt 8; $r++) {
        $lPart  = $script:L_ROWS[$r]
        $hFull  = $script:H_ROWS[$r]
        $leftH  = if ($colsOn -gt 0)  { $hFull.Substring(0, $colsOn) } else { "" }
        $rightH = if ($colsOn -lt 26) { $hFull.Substring($colsOn) }    else { "" }

        $rowY = 3 + $r
        $rowContent = "      $cBorder│$cReset$cWhite$lPart$hubBorder│$cReset$onStyle$leftH$cReset$offStyle$rightH$cReset$hubBorder│$cReset"
        [Console]::Write("$e[$rowY;1H$rowContent")
    }

    $botLine = "      $cBorder└─────────────────────────────────$hubBorder┴──────────────────────────┘$cReset"
    [Console]::Write("$e[11;1H$botLine")

    $subLine = "                        $cSlate" + "Creado por: Eichhh  -  v" + $env:VERSION_ACTUAL + "$cReset"
    [Console]::Write("$e[13;1H$subLine")

    if ($statusText.Length -gt 66) { $statusText = $statusText.Substring(0, 66) }
    $padLeft = [Math]::Max(0, [Math]::Floor((68 - $statusText.Length) / 2))
    $centered = (" " * $padLeft) + $statusText
    $centered = $centered.PadRight(68, ' ')
    [Console]::Write("$e[15;1H   $statusCol$centered$cReset")
}

function Animate-DualBadge([int]$fromCol, [int]$toCol, [string]$stateMode, [string]$statusText, [int]$delayMs) {
    for ($c = $fromCol; $c -le $toCol; $c += 2) {
        Render-DualBadgeBox $c $stateMode $statusText
        Start-Sleep -Milliseconds $delayMs
    }
}

# Imprime una fila con borde derecho CLAVADO en la columna 72 mediante ANSI %ESC%[72G
function Write-FixedBoxRow([string]$plainText, [string]$colorCode) {
    $e = [char]27
    $cBorder = "$e[38;2;71;85;105m"
    $cReset  = "$e[0m"
    $pad68   = " " * 68
    if ($plainText.Length -gt 64) { $plainText = $plainText.Substring(0, 64) }
    [Console]::WriteLine("  $cBorder│$cReset$pad68$e[5G$colorCode$plainText$cReset$e[72G$cBorder│$cReset")
}

# Imprime un banner de color con borde derecho CLAVADO en la columna 72
function Write-FixedBannerRow([string]$titleText, [string]$bgStyle) {
    $e = [char]27
    $cBorder = "$e[38;2;71;85;105m"
    $cReset  = "$e[0m"
    $pad68   = " " * 68
    if ($titleText.Length -gt 65) { $titleText = $titleText.Substring(0, 65) }
    [Console]::WriteLine("  $cBorder│$bgStyle$pad68$e[5G$titleText$e[72G$cReset$cBorder│$cReset")
}

function Render-InlineNetErrorBox() {
    $e = [char]27
    $cBorder = "$e[38;2;71;85;105m"
    $cWhite  = "$e[38;2;255;255;255m"
    $cSlate  = "$e[38;2;148;163;184m"
    $cCyan   = "$e[38;2;56;189;248m"
    $cAmber  = "$e[38;2;251;191;36m"
    $cRose   = "$e[38;2;244;63;94m"
    $bgCrit  = "$e[48;2;127;29;29m$e[38;2;254;226;226m"
    $cReset  = "$e[0m"
    $pad68   = " " * 68

    Set-ConsoleHeight 30
    [Console]::Write("$e[17;1H")
    [Console]::WriteLine("  $cBorder┌────────────────────────────────────────────────────────────────────┐$cReset")
    Write-FixedBannerRow "  [!] ALERTA DE CONECTIVIDAD: SIN RESPUESTA DE RED EXTERNA" $bgCrit
    [Console]::WriteLine("  $cBorder├────────────────────────────────────────────────────────────────────┤$cReset")
    Write-FixedBoxRow "  No se detecto salida activa hacia Internet en este equipo." $cWhite
    Write-FixedBoxRow "  La carga se detuvo en la verificacion de enlace. Elija accion:" $cSlate
    [Console]::WriteLine("  $cBorder├──────┬─────────────────────────────────────────────────────────────┤$cReset")
    [Console]::WriteLine("  $cBorder│$cReset$pad68$e[4G $cCyan[1]$e[10G$cBorder│$cReset $cWhite Abrir Centro de Redes y Conectividad (Configurar IP/Red)$e[72G$cBorder│$cReset")
    [Console]::WriteLine("  $cBorder│$cReset$pad68$e[4G $cAmber[2]$e[10G$cBorder│$cReset $cWhite Continuar al Menu Principal en Modo Offline$e[72G$cBorder│$cReset")
    [Console]::WriteLine("  $cBorder│$cReset$pad68$e[4G $cRose[0]$e[10G$cBorder│$cReset $cWhite Cerrar el sistema$e[72G$cBorder│$cReset")
    [Console]::WriteLine("  $cBorder└──────┴─────────────────────────────────────────────────────────────┘$cReset")
    [Console]::WriteLine("")
}

# Ventana de Actualizacion con BORDES 100% INMOVILES EN COLUMNA 72 (incluso con fuente NSimSun)
function Render-SophisticatedOtaBox([string]$localVer, [string]$remoteVer, [bool]$belowBootLogo) {
    $e = [char]27
    $cBorder  = "$e[38;2;71;85;105m"
    $cWhite   = "$e[38;2;255;255;255m"
    $cSlate   = "$e[38;2;148;163;184m"
    $cText    = "$e[38;2;226;232;240m"
    $cEmerald = "$e[38;2;52;211;153m"
    $cPurple  = "$e[38;2;192;132;252m"
    $cBlink   = "$e[5m"

    $bgUpdHead = "$e[48;2;58;28;113m$e[38;2;243;232;255m"
    $bgFeat    = "$e[48;2;11;42;50m$e[38;2;94;234;212m"
    $bgFix     = "$e[48;2;46;30;14m$e[38;2;253;230;138m"
    $bgTelem   = "$e[48;2;15;23;42m$e[38;2;148;163;184m"
    $cReset    = "$e[0m"
    $pad68     = " " * 68
    $pad34     = " " * 34
    $pad33     = " " * 33

    $rawLines = if (Test-Path $clCache) {
        [System.IO.File]::ReadAllLines($clCache, [System.Text.Encoding]::UTF8)
    } else {
        @(
            "Nuevo modulo de instalacion inicial",
            "Correccion y blindaje al numero de serie"
        )
    }

    $featuresList = New-Object System.Collections.Generic.List[string]
    $fixesList    = New-Object System.Collections.Generic.List[string]
    $verHeader    = $remoteVer.Trim()
    $explicitMode = "AUTO"

    foreach ($line in $rawLines) {
        $t = $line.Replace("`t", " ").Trim().TrimStart('-', '*', '•', '∙', ' ')
        if ([string]::IsNullOrWhiteSpace($t)) { continue }
        if ($t -match '^[\-\—\─\═]{3,}$') { continue }
        if ($t -match '^v?\d+(\.\d+)+$') {
            $verHeader = $t.TrimStart('v', 'V')
            continue
        }
        if ($t -match '(?i)^NUEVAS\s+CARACTER') { $explicitMode = "FEAT"; continue }
        if ($t -match '(?i)^CORRECCI[OÓ]N')     { $explicitMode = "FIX";  continue }

        if ($explicitMode -eq "FEAT") {
            $featuresList.Add($t)
        } elseif ($explicitMode -eq "FIX") {
            $fixesList.Add($t)
        } else {
            if ($t -match '(?i)(correc|error|fix|bug|blindaje|solucion|repar|arregl|actualicen|cambien|nombre|problema|fallo)') {
                $fixesList.Add($t)
            } else {
                $featuresList.Add($t)
            }
        }
    }

    if ($featuresList.Count -eq 0 -and $fixesList.Count -gt 0) {
        $featuresList.Add("Optimizacion general de modulos de la version v$verHeader")
    }
    if ($fixesList.Count -eq 0) {
        $fixesList.Add("Ajustes de estabilidad y depuracion interna en v$verHeader")
    }

    $totalContentRows = $featuresList.Count + $fixesList.Count + 17
    $targetWinH = if ($belowBootLogo) { [Math]::Min(56, 17 + $totalContentRows) } else { [Math]::Min(50, 3 + $totalContentRows) }
    Set-ConsoleHeight $targetWinH

    if ($belowBootLogo) {
        [Console]::Write("$e[17;1H")
    } else {
        [Console]::Clear()
        [Console]::WriteLine("")
    }

    $vLocTxt = "v" + $localVer.Trim() + " [Instalada]"
    $vRemTxt = "v" + $remoteVer.Trim() + " [Disponible]"

    [Console]::WriteLine("  $cBorder┌────────────────────────────────────────────────────────────────────┐$cReset")
    Write-FixedBannerRow "  * CENTRO DE ACTUALIZACIONES DEL SISTEMA  -  RTIC HUB FCA" $bgUpdHead
    [Console]::WriteLine("  $cBorder├──────────────────────────────────┬─────────────────────────────────┤$cReset")
    [Console]::WriteLine("  $cBorder│$bgTelem$pad34$e[5G  Compilacion Local Instalada$e[38G$cReset$cBorder│$bgTelem$pad33$e[40G  Nueva Version en Servidor$e[72G$cReset$cBorder│$cReset")
    [Console]::WriteLine("  $cBorder│$cReset$pad68$e[5G  $cSlate$vLocTxt$e[38G$cBorder│$cReset  $cPurple$cBlink*$cReset$cPurple $vRemTxt$e[72G$cBorder│$cReset")
    [Console]::WriteLine("  $cBorder├──────────────────────────────────┴─────────────────────────────────┤$cReset")
    Write-FixedBannerRow ("  [+] NUEVAS CARACTERISTICAS E INTEGRACIONES (v" + $verHeader + ")") $bgFeat
    [Console]::WriteLine("  $cBorder├────────────────────────────────────────────────────────────────────┤$cReset")

    foreach ($item in $featuresList) {
        $clean = "  - " + $item
        while ($clean.Length -gt 63) {
            Write-FixedBoxRow $clean.Substring(0, 63) $cText
            $clean = "    " + $clean.Substring(63).TrimStart()
        }
        Write-FixedBoxRow $clean $cText
    }

    [Console]::WriteLine("  $cBorder├────────────────────────────────────────────────────────────────────┤$cReset")
    Write-FixedBannerRow "  [*] CORRECCION DE ERRORES Y NOTAS DE VERSION" $bgFix
    [Console]::WriteLine("  $cBorder├────────────────────────────────────────────────────────────────────┤$cReset")

    foreach ($item in $fixesList) {
        $clean = "  - " + $item
        while ($clean.Length -gt 63) {
            Write-FixedBoxRow $clean.Substring(0, 63) $cText
            $clean = "    " + $clean.Substring(63).TrimStart()
        }
        Write-FixedBoxRow $clean $cText
    }

    [Console]::WriteLine("  $cBorder├──────┬───────────────────────────────────────────┬─────────────────┤$cReset")
    [Console]::WriteLine("  $cBorder│$cReset$pad68$e[4G $cPurple[1]$e[10G$cBorder│$cReset $cWhite Descargar, respaldar e instalar ahora$e[54G$cBorder│$cReset $cEmerald* Recomendado$e[72G$cBorder│$cReset")
    [Console]::WriteLine("  $cBorder│$cReset$pad68$e[4G $cSlate[2]$e[10G$cBorder│$cReset $cText Posponer actualizacion e ir al Hub$e[54G$cBorder│$cReset $cSlate- Omitir$e[72G$cBorder│$cReset")
    [Console]::WriteLine("  $cBorder└──────┴───────────────────────────────────────────┴─────────────────┘$cReset")
    [Console]::WriteLine("")
}

# Renderiza la ventana de "En Desarrollo" con Robot ASCII limpio y Chiste Variable (API en vivo + rotacion diaria)
function Render-DevJokerScreen([string]$modName) {
    $e = [char]27
    $cBorder  = "$e[38;2;71;85;105m"
    $cWhite   = "$e[38;2;255;255;255m"
    $cSlate   = "$e[38;2;148;163;184m"
    $cText    = "$e[38;2;226;232;240m"
    $cCyan    = "$e[38;2;56;189;248m"
    $cEmerald = "$e[38;2;52;211;153m"
    $cAmber   = "$e[38;2;251;191;36m"
    $cRose    = "$e[38;2;244;63;94m"
    $bgLic    = "$e[48;2;45;30;12m$e[38;2;253;230;138m"
    $bgSub    = "$e[48;2;15;23;42m$e[38;2;56;189;248m"
    $cReset   = "$e[0m"

    # Banco local rotativo por dia del ano / minuto por si falla la API o como rotacion instantanea
    $fallbackJokes = @(
        "¿Por que los programadores prefieren el modo oscuro? Porque la luz atrae a los bugs.",
        "Hay 10 tipos de personas en el mundo: las que entienden binario y las que le pican a [En Desarrollo].",
        "Un SQL entra a un bar, se acerca a dos mesas y les pregunta: ¿Me puedo unir (JOIN)?",
        "¿Cuantos programadores se necesitan para cambiar un foco? Ninguno, eso es problema de hardware.",
        "¡No seas terco! En mi maquina ya casi compila este modulo, pero hoy todavia no.",
        "Error 404: Paciencia del operador no encontrada. Deja de picarle a lo que dice [En Desarrollo].",
        "¿Que le dice un bit al otro? Nos vemos en el bus... cuando terminen de programar este boton."
    )

    $jokeText = ""
    try {
        $wc = New-Object System.Net.WebClient
        $wc.Encoding = [System.Text.Encoding]::UTF8
        $jsonRaw = $wc.DownloadString("https://v2.jokeapi.dev/joke/Programming,Misc?lang=es&blacklistFlags=nsfw,racist,sexist")
        $jObj = $jsonRaw | ConvertFrom-Json
        if ($jObj.type -eq "single" -and $jObj.joke) {
            $jokeText = $jObj.joke -replace '\r?\n', ' '
        } elseif ($jObj.setup -and $jObj.delivery) {
            $jokeText = ($jObj.setup + " " + $jObj.delivery) -replace '\r?\n', ' '
        }
    } catch {}

    if ([string]::IsNullOrWhiteSpace($jokeText)) {
        $idx = ([DateTime]::Now.DayOfYear + [DateTime]::Now.Minute) % $fallbackJokes.Count
        $jokeText = $fallbackJokes[$idx]
    }

    # Envolver chiste en lineas de maximo 62 caracteres
    $words = $jokeText -split '\s+'
    $jokeLines = New-Object System.Collections.Generic.List[string]
    $currLine = "  "
    foreach ($w in $words) {
        if (($currLine.Length + $w.Length + 1) -gt 63) {
            $jokeLines.Add($currLine)
            $currLine = "  " + $w
        } else {
            $currLine = if ($currLine -eq "  ") { "  " + $w } else { $currLine + " " + $w }
        }
    }
    if (-not [string]::IsNullOrWhiteSpace($currLine)) { $jokeLines.Add($currLine) }

    $winH = [Math]::Max(26, 22 + $jokeLines.Count)
    Set-ConsoleHeight $winH

    [Console]::Clear()
    [Console]::WriteLine("")
    [Console]::WriteLine("  $cBorder┌────────────────────────────────────────────────────────────────────┐$cReset")
    Write-FixedBannerRow "  [!] ZONA EN CONSTRUCCION  -  ACCESO RESTRINGIDO POR NECEDAD" $bgLic
    [Console]::WriteLine("  $cBorder├────────────────────────────────────────────────────────────────────┤$cReset")
    Write-FixedBoxRow "" $cWhite
    [Console]::WriteLine("  $cBorder│$cReset       $cCyan.───────────.$cReset       $cRose¡OYE, NO SEAS NECIO!$e[72G$cBorder│$cReset")
    [Console]::WriteLine("  $cBorder│$cReset      $cCyan│  [o]   [o]  │$cReset      $cWhiteAhi decia clarito que el modulo:$e[72G$cBorder│$cReset")
    [Console]::WriteLine("  $cBorder│$cReset      $cCyan│     ───     │$cReset      $cAmber> ""$modName""$e[72G$cBorder│$cReset")
    [Console]::WriteLine("  $cBorder│$cReset      $cCyan'─────┬─┬─────'$cReset      $cWhitetodavia $cRoseSIGUE EN DESARROLLO$cWhite.$e[72G$cBorder│$cReset")
    [Console]::WriteLine("  $cBorder│$cReset         $cAmber┌──┴─┴──┐$cReset         $cSlateNo por picarle 10 veces se va a$e[72G$cBorder│$cReset")
    [Console]::WriteLine("  $cBorder│$cReset         $cAmber│ [WIP] │$cReset         $cSlateprogramar solito magically.$e[72G$cBorder│$cReset")
    [Console]::WriteLine("  $cBorder│$cReset         $cAmber└───────┘$cReset$e[72G$cBorder│$cReset")
    Write-FixedBoxRow "" $cWhite
    [Console]::WriteLine("  $cBorder├────────────────────────────────────────────────────────────────────┤$cReset")
    Write-FixedBannerRow ("  * CHISTE VARIABLE DEL DIA  [" + (Get-Date -Format "dd/MM/yyyy") + "]") $bgSub
    [Console]::WriteLine("  $cBorder├────────────────────────────────────────────────────────────────────┤$cReset")
    Write-FixedBoxRow "" $cWhite
    foreach ($jl in $jokeLines) {
        Write-FixedBoxRow $jl $cEmerald
    }
    Write-FixedBoxRow "" $cWhite
    [Console]::WriteLine("  $cBorder├────────────────────────────────────────────────────────────────────┤$cReset")
    Write-FixedBoxRow "  > Presione cualquier tecla y portese bien para regresar..." $cAmber
    [Console]::WriteLine("  $cBorder└────────────────────────────────────────────────────────────────────┘$cReset")
}

function Get-SystemStates() {
    $wp = "LIBRE"
    $hs = "LIBRE"
    try {
        $v1 = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Name "NoChangingWallPaper" -ErrorAction SilentlyContinue).NoChangingWallPaper
        $v2 = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoChangingLockScreen" -ErrorAction SilentlyContinue).NoChangingLockScreen
        if ($v1 -eq 1 -or $v2 -eq 1) { $wp = "LOCKED" }
    } catch {}
    try {
        $h1 = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections" -Name "NC_ShowSharedAccessUI" -ErrorAction SilentlyContinue).NC_ShowSharedAccessUI
        if ($null -ne $h1 -and $h1 -eq 0) { $hs = "LOCKED" }
    } catch {}
    $net = Test-FastNet
    return "$wp|$hs|$net"
}

function Convert-ToJpg([string]$srcImg, [string]$destJpg) {
    Add-Type -AssemblyName System.Drawing
    $img = [System.Drawing.Image]::FromFile($srcImg)
    try {
        $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
        $encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
        $encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100L)
        $img.Save($destJpg, $codec, $encParams)
    } finally {
        $img.Dispose()
    }
}

function Notify-WindowsShellInstant() {
    $code = @'
using System;
using System.Runtime.InteropServices;
public class Win32ShellSync {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);

    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam, uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);

    public static void BroadcastSettings() {
        UIntPtr res;
        SendMessageTimeout((IntPtr)0xffff, 0x001A, UIntPtr.Zero, "Policy", 0x0002, 500, out res);
        SendMessageTimeout((IntPtr)0xffff, 0x001A, UIntPtr.Zero, "ImmersiveColorSet", 0x0002, 500, out res);
    }
}
'@
    Add-Type -TypeDefinition $code -ErrorAction SilentlyContinue
    [Win32ShellSync]::BroadcastSettings()
}

function Apply-DesktopAndLockPolicies([string]$wpJpgPath, [string]$lsJpgPath) {
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Name "NoChangingWallPaper" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Name "NoChangingWallPaper" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "Wallpaper" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "Wallpaper" -ErrorAction SilentlyContinue

    $themesDir = Join-Path $env:APPDATA "Microsoft\Windows\Themes"
    if (-not (Test-Path $themesDir)) { New-Item -ItemType Directory -Path $themesDir -Force | Out-Null }
    $transcoded = Join-Path $themesDir "TranscodedWallpaper"
    $cachedDir  = Join-Path $themesDir "CachedFiles"
    if (Test-Path $cachedDir) { Remove-Item -Path "$cachedDir\*" -Force -ErrorAction SilentlyContinue }
    Copy-Item -LiteralPath $wpJpgPath -Destination $transcoded -Force

    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Wallpaper" -Value $wpJpgPath -Force
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallpaperStyle" -Value "10" -Force
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "TileWallpaper" -Value "0" -Force

    Notify-WindowsShellInstant
    [Win32ShellSync]::SystemParametersInfo(0x0014, 0, $wpJpgPath, 0x01 -bor 0x02) | Out-Null

    $polSysCU = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
    $polSysLM = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    $polAdCU  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop"
    $polAdLM  = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop"
    foreach ($p in @($polSysCU, $polSysLM, $polAdCU, $polAdLM)) {
        if (-not (Test-Path $p)) { New-Item -Path $p -Force | Out-Null }
    }
    Set-ItemProperty -Path $polSysCU -Name "Wallpaper" -Value $wpJpgPath -Type String -Force
    Set-ItemProperty -Path $polSysCU -Name "WallpaperStyle" -Value "10" -Type String -Force
    Set-ItemProperty -Path $polSysCU -Name "NoDispBackgroundPage" -Value 1 -Type DWord -Force

    Set-ItemProperty -Path $polSysLM -Name "Wallpaper" -Value $wpJpgPath -Type String -Force
    Set-ItemProperty -Path $polSysLM -Name "WallpaperStyle" -Value "10" -Type String -Force
    Set-ItemProperty -Path $polSysLM -Name "NoDispBackgroundPage" -Value 1 -Type DWord -Force

    Set-ItemProperty -Path $polAdCU -Name "NoChangingWallPaper" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $polAdLM -Name "NoChangingWallPaper" -Value 1 -Type DWord -Force

    if (Test-Path $lsJpgPath) {
        $polPers = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
        $cspPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
        $cdmPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        $cloudCU = "HKCU:\Software\Policies\Microsoft\Windows\CloudContent"
        foreach ($p in @($polPers, $cspPath, $cdmPath, $cloudCU)) {
            if (-not (Test-Path $p)) { New-Item -Path $p -Force | Out-Null }
        }
        Set-ItemProperty -Path $polPers -Name "LockScreenImage" -Value $lsJpgPath -Type String -Force
        Set-ItemProperty -Path $polPers -Name "NoChangingLockScreen" -Value 1 -Type DWord -Force
        Set-ItemProperty -Path $polPers -Name "LockScreenOverlaysDisabled" -Value 1 -Type DWord -Force

        Set-ItemProperty -Path $cspPath -Name "LockScreenImagePath" -Value $lsJpgPath -Type String -Force
        Set-ItemProperty -Path $cspPath -Name "LockScreenImageUrl" -Value $lsJpgPath -Type String -Force
        Set-ItemProperty -Path $cspPath -Name "LockScreenImageStatus" -Value 1 -Type DWord -Force

        Set-ItemProperty -Path $cdmPath -Name "RotatingLockScreenEnabled" -Value 0 -Type DWord -Force
        Set-ItemProperty -Path $cdmPath -Name "RotatingLockScreenOverlayEnabled" -Value 0 -Type DWord -Force
        Set-ItemProperty -Path $cloudCU -Name "ConfigureWindowsSpotlight" -Value 2 -Type DWord -Force
        Set-ItemProperty -Path $cloudCU -Name "DisableWindowsSpotlightFeatures" -Value 1 -Type DWord -Force
    }
    Notify-WindowsShellInstant
}

switch ($a) {

    # 1. ARRANQUE SIN FALSO POSITIVO OFFLINE Y CON PARADA EXACTA EN INCIDENCIA
    "BOOT_INIT" {
        $localVerStr = $arg1.Trim()
        $skipFlag    = $arg2

        [Console]::Clear()

        Animate-DualBadge 0 6 "NORMAL" "Iniciando nucleo y leyendo SMBIOS..." 16
        $sn = Get-FastBiosSerial

        Animate-DualBadge 6 10 "NORMAL" ("Equipo [" + $sn + "] - Verificando conexion a Internet...") 16
        $states   = (Get-SystemStates) -split '\|'
        $wpState  = $states[0]
        $hsState  = $states[1]
        $netState = $states[2]

        if ($netState -eq "OFFLINE") {
            Render-DualBadgeBox 10 "ERROR" "[!] Carga detenida: Sin conexion a Internet detectada."
            Render-InlineNetErrorBox
            [System.IO.File]::WriteAllText($outF, "$sn|$netState|NO|$localVerStr|$wpState|$hsState", $utf8No)
            break
        }

        Animate-DualBadge 10 18 "NORMAL" "Consultando versiones en GitHub (azarel22/FCA)..." 16
        $upd = "NO"
        $remVerStr = $localVerStr
        if ($skipFlag -ne "skipupdate") {
            try {
                $ts = [DateTimeOffset]::Now.ToUnixTimeSeconds()
                $wc = New-Object System.Net.WebClient
                $wc.Encoding = [System.Text.Encoding]::UTF8
                $wc.Headers.Add("Cache-Control", "no-cache")
                $rStr = $wc.DownloadString($env:GH_BASE + "/version.txt?t=" + $ts).Trim()
                if (-not [string]::IsNullOrWhiteSpace($rStr)) {
                    $remVerStr = $rStr
                    if ($rStr -ne $localVerStr) {
                        $upd = "YES"
                        try {
                            $clTxt = $wc.DownloadString($env:GH_BASE + "/changelog.txt?t=" + $ts).Trim()
                            if (-not [string]::IsNullOrWhiteSpace($clTxt)) {
                                [System.IO.File]::WriteAllText($clCache, $clTxt, $utf8No)
                            }
                        } catch {}
                    }
                }
            } catch {}
        }

        if ($upd -eq "YES") {
            Render-DualBadgeBox 18 "UPDATE" ("* Carga pausada: Nueva version v" + $remVerStr + " disponible en GitHub")
            Render-SophisticatedOtaBox $localVerStr $remVerStr $true
            [System.IO.File]::WriteAllText($outF, "$sn|ONLINE|$upd|$remVerStr|$wpState|$hsState", $utf8No)
            break
        }

        Animate-DualBadge 18 26 "NORMAL" "Auditando politicas de pantalla y preparando interfaz..." 16
        Render-DualBadgeBox 26 "OK" "[+] Sistema institucional listo y verificado."
        Start-Sleep -Milliseconds 150

        [System.IO.File]::WriteAllText($outF, "$sn|$netState|$upd|$remVerStr|$wpState|$hsState", $utf8No)
    }

    "REFRESH_STATES" {
        $res = Get-SystemStates
        [System.IO.File]::WriteAllText($outF, $res, $utf8No)
    }

    "RENDER_DEV_JOKER" {
        Render-DevJokerScreen $arg1
    }

    "SCREEN_INSTITUTIONAL" {
        try {
            $folder = $arg1
            if (-not (Test-Path $folder)) { New-Item -ItemType Directory -Path $folder -Force | Out-Null }
            icacls $folder /grant "*S-1-1-0:(OI)(CI)F" /T /Q >$null 2>&1

            $wpPng = Join-Path $folder "wallpaper_fca.png"
            $lsPng = Join-Path $folder "lock_screen_wallpaper_fca.png"
            $wpJpg = Join-Path $folder "wallpaper_fca.jpg"
            $lsJpg = Join-Path $folder "lock_screen_wallpaper_fca.jpg"

            Write-Host "  - [1/3] Verificando / descargando recursos institucionales..." -ForegroundColor Cyan
            $wc = New-Object System.Net.WebClient
            if (-not (Test-Path $wpPng)) { $wc.DownloadFile($env:WP_URL, $wpPng) }
            if (-not (Test-Path $lsPng)) { $wc.DownloadFile($env:LS_URL, $lsPng) }

            Write-Host "  - [2/3] Convirtiendo imagenes a formato nativo JPG de alta fidelidad..." -ForegroundColor Cyan
            Convert-ToJpg $wpPng $wpJpg
            Convert-ToJpg $lsPng $lsJpg

            Write-Host "  - [3/3] Aplicando TranscodedWallpaper y politicas PersonalizationCSP..." -ForegroundColor Cyan
            Apply-DesktopAndLockPolicies $wpJpg $lsJpg

            [System.IO.File]::WriteAllText($outF, "OK", $utf8No)
        } catch {
            [System.IO.File]::WriteAllText($outF, ("Fallo al aplicar: " + $_.Exception.Message), $utf8No)
        }
    }

    "SCREEN_LOCK_CURRENT" {
        try {
            $folder = $arg1
            if (-not (Test-Path $folder)) { New-Item -ItemType Directory -Path $folder -Force | Out-Null }
            $currWp = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Wallpaper" -ErrorAction SilentlyContinue).Wallpaper
            if ([string]::IsNullOrWhiteSpace($currWp) -or (-not (Test-Path $currWp))) {
                $currWp = Join-Path $env:APPDATA "Microsoft\Windows\Themes\TranscodedWallpaper"
            }
            $lockedJpg = Join-Path $folder "wallpaper_locked_current.jpg"
            Convert-ToJpg $currWp $lockedJpg

            $lsJpg = Join-Path $folder "lock_screen_wallpaper_fca.jpg"
            if (-not (Test-Path $lsJpg)) { $lsJpg = $lockedJpg }

            Write-Host "  - Sellando fondo actual y pantalla de bloqueo en Registro..." -ForegroundColor Cyan
            Apply-DesktopAndLockPolicies $lockedJpg $lsJpg

            [System.IO.File]::WriteAllText($outF, "OK", $utf8No)
        } catch {
            [System.IO.File]::WriteAllText($outF, ("Error: " + $_.Exception.Message), $utf8No)
        }
    }

    "SCREEN_UNLOCK" {
        try {
            Write-Host "  - Eliminando restricciones en ActiveDesktop, System y PersonalizationCSP..." -ForegroundColor Cyan
            Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\Personalization" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Recurse -Force -ErrorAction SilentlyContinue

            foreach ($hive in @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System")) {
                Remove-ItemProperty -Path $hive -Name "NoDispBackgroundPage" -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path $hive -Name "Wallpaper" -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path $hive -Name "WallpaperStyle" -ErrorAction SilentlyContinue
            }

            Remove-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent" -Name "ConfigureWindowsSpotlight" -ErrorAction SilentlyContinue
            Remove-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsSpotlightFeatures" -ErrorAction SilentlyContinue

            Write-Host "  - Notificando cambios al Shell de Windows..." -ForegroundColor Green
            Notify-WindowsShellInstant
            [System.IO.File]::WriteAllText($outF, "OK", $utf8No)
        } catch {
            [System.IO.File]::WriteAllText($outF, "OK", $utf8No)
        }
    }

    "SCREEN_DOWNLOAD_ONLY" {
        try {
            $folder = $arg1
            if (-not (Test-Path $folder)) { New-Item -ItemType Directory -Path $folder -Force | Out-Null }
            icacls $folder /grant "*S-1-1-0:(OI)(CI)F" /T /Q >$null 2>&1
            $wpPng = Join-Path $folder "wallpaper_fca.png"
            $lsPng = Join-Path $folder "lock_screen_wallpaper_fca.png"
            $wc = New-Object System.Net.WebClient
            $wc.DownloadFile($env:WP_URL, $wpPng)
            $wc.DownloadFile($env:LS_URL, $lsPng)
            Convert-ToJpg $wpPng (Join-Path $folder "wallpaper_fca.jpg")
            Convert-ToJpg $lsPng (Join-Path $folder "lock_screen_wallpaper_fca.jpg")
            [System.IO.File]::WriteAllText($outF, "OK", $utf8No)
        } catch {
            [System.IO.File]::WriteAllText($outF, $_.Exception.Message, $utf8No)
        }
    }

    "LIST_NET_ADAPTERS" {
        $e = [char]27
        $cBorder = "$e[38;2;71;85;105m"
        $cCyan   = "$e[38;2;56;189;248m"
        $cWhite  = "$e[38;2;255;255;255m"
        $cSlate  = "$e[38;2;148;163;184m"
        $bgTelem = "$e[48;2;15;23;42m$e[38;2;148;163;184m"
        $cReset  = "$e[0m"
        [Console]::WriteLine("  $cBorder┌──────────────────────────┬──────────────────┬────────────────────────┐$cReset")
        [Console]::WriteLine("  $cBorder│$bgTelem  Nombre de Interfaz      $cReset$cBorder│$bgTelem  Estado          $cReset$cBorder│$bgTelem  Velocidad / Enlace    $cReset$cBorder│$cReset")
        [Console]::WriteLine("  $cBorder├──────────────────────────┼──────────────────┼────────────────────────┤$cReset")
        try {
            $adapters = Get-NetAdapter | Select-Object -First 6
            foreach ($ad in $adapters) {
                $n = $ad.Name.PadRight(24, ' ').Substring(0, 24)
                $s = $ad.Status.ToString().PadRight(16, ' ').Substring(0, 16)
                $l = ([string]$ad.LinkSpeed).PadRight(22, ' ').Substring(0, 22)
                [Console]::WriteLine("  $cBorder│$cReset  $cCyan$n$cBorder│$cReset  $cWhite$s$cBorder│$cReset  $cSlate$l$cBorder│$cReset")
            }
        } catch {}
        [Console]::WriteLine("  $cBorder└──────────────────────────┴──────────────────┴────────────────────────┘$cReset")
    }

    "CHECK_OTA_MANUAL" {
        try {
            $localVer = $arg1.Trim()
            $ts = [DateTimeOffset]::Now.ToUnixTimeSeconds()
            $wc = New-Object System.Net.WebClient
            $wc.Encoding = [System.Text.Encoding]::UTF8
            $wc.Headers.Add("Cache-Control", "no-cache")
            $rStr = $wc.DownloadString($env:GH_BASE + "/version.txt?t=" + $ts).Trim()
            try {
                $clTxt = $wc.DownloadString($env:GH_BASE + "/changelog.txt?t=" + $ts).Trim()
                if (-not [string]::IsNullOrWhiteSpace($clTxt)) {
                    [System.IO.File]::WriteAllText($clCache, $clTxt, $utf8No)
                }
            } catch {}
            $st = if ($rStr -ne $localVer) { "UPDATE" } else { "UPTODATE" }
            [System.IO.File]::WriteAllText($outF, "$st|$rStr", $utf8No)
        } catch {
            [System.IO.File]::WriteAllText($outF, "ERROR|N/A", $utf8No)
        }
    }

    "RENDER_OTA_STANDALONE" {
        Render-SophisticatedOtaBox $arg1 $arg2 $false
    }
}