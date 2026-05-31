@echo off
:: ==========================================
:: Creado por: Eichhh
:: Versión: 10.5 integracion de MRT y nuevas claves de registro
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
set "VERSION_ACTUAL=10.5"
:: ==========================================

:: ==========================================
:: CONFIGURACIÓN DE LOGS
:: ==========================================
set "LOG_DIR=%TEMP%"
set "LOG_FILE=%TEMP%\RTIC_Log.csv"
:: ==========================================

:: ==========================================
:: INICIALIZAR SISTEMA DE LOGS
:: ==========================================
set "LOG_DIR=%TEMP%\RTIC_Updates"
set "LOG_FILE=%TEMP%\RTIC_Updates\RTIC_Log.csv"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
if exist "%LOG_FILE%" del /f /q "%LOG_FILE%" >nul 2>&1
type nul > "%LOG_FILE%"
for /f "tokens=2 delims==." %%a in ('wmic os get LocalDateTime /value 2^>nul') do set "DT=%%a"
set "LOG_FECHA=%DT:~0,4%-%DT:~4,2%-%DT:~6,2%"
set "LOG_HORA=%DT:~8,2%:%DT:~10,2%:%DT:~12,2%"

:: --- DEFINICIÓN DE COLORES ---
:: Definimos el caracter ESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"
:: --- PALETA DE COLORES ---
set "CW=%ESC%[38;2;255;255;255m"
set "RST=%ESC%[0m"
set "CG=%ESC%[90m"
set "R_ERR=%ESC%[91m"
set "ORANGE=%ESC%[38;2;200;150;0m"
set "YELL=%ESC%[38;2;255;223;80m"
set "ON=%ESC%[48;2;200;150;0m%ESC%[38;2;0;0;0m"
set "OFF=%ESC%[48;2;0;0;0m%ESC%[38;2;18;18;18m"
set "ERR_COL=%ESC%[48;2;160;0;0m%ESC%[38;2;255;255;255m"
set "MINT=%ESC%[38;2;80;255;180m"
set "LBLUE=%ESC%[38;2;100;200;255m"
set "DGRAY=%ESC%[38;2;110;110;110m"
set "MGRAY=%ESC%[38;2;160;160;160m"
set "BOLD=%ESC%[1m"
set "RED=%ESC%[38;2;220;70;70m"
set "SCR=%ESC%[38;2;80;210;190m"
set "OPT=%ESC%[38;2;140;230;100m"
set "ACT=%ESC%[38;2;255;185;100m"
set "SYS=%ESC%[38;2;190;175;255m"
:: -----------------------------------------------

:: ==========================================
:: OPERADOR
:: ==========================================
set "OPERADOR="
set /p "OPERADOR=Ingresa tu nombre de operador: "

title RTIC_HUB_FCA

:: ==========================================
:: PANTALLA DE CARGA + VERIFICACIONES
:: ==========================================

mode con: cols=90 lines=42
echo %ESC%[?25l

set "L0=                                 "
set "L1= ██████╗ ████████╗██╗  ██████╗   "
set "L2= ██╔══██╗╚══██╔══╝██║ ██╔════╝   "
set "L3= ██████╔╝   ██║   ██║ ██║        "
set "L4= ██╔══██╗   ██║   ██║ ██║        "
set "L5= ██║  ██║   ██║   ██║ ╚██████╗   "
set "L6= ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═════╝   "
set "L7=                                 "

set "H1=                          "
set "H2= ██╗  ██╗██╗   ██╗██████╗ "
set "H3= ██║  ██║██║   ██║██╔══██╗"
set "H4= ███████║██║   ██║██████╔╝"
set "H5= ██╔══██║██║   ██║██╔══██╗"
set "H6= ██║  ██║╚██████╔╝██████╔╝"
set "H7= ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ "
set "H8=                          "

set "MOD[1]=                       Iniciando nucleo..."
set "MOD[2]=               Verificando conexion a internet..."
set "MOD[3]=            Verificando permisos de administrador..."
set "MOD[4]=                 Consultando Actualizaciones..."
set "MOD[5]=                 Cargando modulos del sistema..."
set "MOD[6]=                    Cargando instaladores..."
set "MOD[7]=                Preparando modulo de pantalla..."
set "MOD[8]=                     Cargando optimizador..."
set "MOD[9]=                    Verificando licencias..."
set "MOD[10]=                       Preparando menus..."
set "MOD[11]=                Aplicando configuracion visual..."
set "MOD[12]=              Verificando integridad del sistema..."
set "MOD[13]=                             Listo."

:: PRE-CHECKS silenciosos
set "FLAG_INTERNET=OK"
ping -n 1 -w 2000 8.8.8.8 >nul 2>&1
if %errorlevel% NEQ 0 set "FLAG_INTERNET=FAIL"

set "FLAG_ADMIN=OK"
net session >nul 2>&1
if %errorlevel% NEQ 0 set "FLAG_ADMIN=FAIL"

set "FLAG_UPDATE=OK"
set "VERSION_REMOTA="
if "%FLAG_INTERNET%"=="OK" (
  if not "%1"=="skipupdate" (
    if not exist "%TEMP%\RTIC_Updates" mkdir "%TEMP%\RTIC_Updates" >nul 2>&1
    curl -L -s -f "https://raw.githubusercontent.com/%GITHUB_USER%/%GITHUB_REPO%/refs/heads/main/version.txt" -o "%TEMP%\RTIC_Updates\version.txt" 2>nul
    curl -L -s -f "https://raw.githubusercontent.com/%GITHUB_USER%/%GITHUB_REPO%/refs/heads/main/changelog.txt" -o "%TEMP%\RTIC_Updates\changelog.txt" 2>nul
    for /f "usebackq tokens=*" %%a in ("%TEMP%\RTIC_Updates\version.txt") do (
      if "!VERSION_REMOTA!"=="" set "VERSION_REMOTA=%%a"
    )
    if not "!VERSION_REMOTA!"=="" (
      if not "%VERSION_ACTUAL%"=="!VERSION_REMOTA!" set "FLAG_UPDATE=NEW"
    )
  )
)

:: LOOP DE ANIMACION
for /L %%S in (1,1,13) do (
  
  set /a "COLS_ON=%%S * 2"
  set "BLOQUE=!ON!"
  
  if "!FLAG_INTERNET!"=="FAIL" if %%S GEQ 2 set "BLOQUE=!ERR_COL!"
  if "!FLAG_ADMIN!"=="FAIL"    if %%S GEQ 3 set "BLOQUE=!ERR_COL!"
  if "!FLAG_UPDATE!"=="NEW"    if %%S GEQ 4 set "BLOQUE=%ESC%[48;2;255;223;80m%ESC%[38;2;0;0;0m"
  
  for /L %%R in (1,1,8) do (
    set "HROW=!H%%R!"
    call set "LEFT=%%HROW:~0,!COLS_ON!%%"
    call set "RIGHT=%%HROW:~!COLS_ON!%%"
    set "ROW%%R=!BLOQUE!!LEFT!!RST!!OFF!!RIGHT!!RST!"
  )
  
  cls
  echo.
  echo.
  echo !CW!!L0!  !ROW1! !CW!fca!RST!
  echo !CW!!L1!  !ROW2!!RST!
  echo !CW!!L2!  !ROW3!!RST!
  echo !CW!!L3!  !ROW4!!RST!
  echo !CW!!L4!  !ROW5!!RST!
  echo !CW!!L5!  !ROW6!!RST!
  echo !CW!!L6!  !ROW7!!RST!
  echo !CW!!L7!  !ROW8!!RST!
  echo.
  echo                       !CG!Creado por: Eichhh!RST!
  echo                         !CG!Version: %VERSION_ACTUAL%!RST!
  echo.
  echo !CG!!MOD[%%S]!!RST!
  
  set "DELAY=250"
  if %%S EQU 2 if "!FLAG_INTERNET!"=="FAIL" set "DELAY=1500"
  if %%S EQU 3 if "!FLAG_ADMIN!"=="FAIL"    set "DELAY=1500"
  if %%S EQU 4 if "!FLAG_UPDATE!"=="NEW"    set "DELAY=1500"
  ping -n 1 -w !DELAY! 127.255.255.255 >nul
  
  if %%S EQU 2 if "!FLAG_INTERNET!"=="FAIL" goto :ERROR_INTERNET
  if %%S EQU 3 if "!FLAG_ADMIN!"=="FAIL"  goto :ERROR_ADMIN
  if %%S EQU 4 if "!FLAG_UPDATE!"=="NEW"  goto :AVISO_UPDATE
)

echo %ESC%[?25h
goto :MENU_PRINCIPAL

:REGISTRAR_LOG
for /f "tokens=2 delims==." %%a in ('wmic os get LocalDateTime /value 2^>nul') do set "DT_NOW=%%a"
set "L_FECHA=%DT_NOW:~0,4%-%DT_NOW:~4,2%-%DT_NOW:~6,2%"
set "L_HORA=%DT_NOW:~8,2%:%DT_NOW:~10,2%:%DT_NOW:~12,2%"
echo %L_FECHA%,%L_HORA%,,%SERIAL_NUM%,,%~1,,%~2,%OPERADOR% >> "%LOG_FILE%"
goto :eof

:SKIP_LOG_FUNCTION

:: -------------------------------------------------------
:: HANDLER: SIN INTERNET
:: -------------------------------------------------------
:ERROR_INTERNET
echo %ESC%[?25h
call :REGISTRAR_LOG "INICIO_SESION" "Verificacion" "ERROR_SIN_INTERNET"
echo.
echo %R_ERR%════════════════════════════════════════════════════════════%RST%
echo %R_ERR%       ERROR: NO SE DETECTA CONEXION A INTERNET%RST%
echo %R_ERR%════════════════════════════════════════════════════════════%RST%
echo.
echo    No se recibio respuesta de los servidores.
echo    Es necesario internet para descargar los recursos.
echo.
echo    ¿Deseas ir al menu de redes para intentar
echo    restablecer la conexion?
echo.
echo    [1] SI, Entrar al menu de redes
echo    [2] NO, Salir del programa
echo.
set /p "redfix=%LBLUE%Selecciona una opcion: %RST%"
if "%redfix%"=="1" goto :SUBMENU_REDES
exit

:: -------------------------------------------------------
:: HANDLER: SIN ADMIN
:: -------------------------------------------------------
:ERROR_ADMIN
echo %ESC%[?25h
call :REGISTRAR_LOG "INICIO_SESION" "Verificacion" "ERROR_SIN_PERMISOS_ADMIN"
echo.
echo %R_ERR%════════════════════════════════════════════════════════════%RST%
echo %R_ERR%       ERROR: SE REQUIEREN PERMISOS DE ADMINISTRADOR%RST%
echo %R_ERR%════════════════════════════════════════════════════════════%RST%
echo.
echo    Windows requiere permisos elevados para modificar
echo    las politicas de seguridad.
echo.
echo    POR FAVOR: Clic derecho -^> Ejecutar como administrador.
echo.
pause
exit

:: -------------------------------------------------------
:: HANDLER: ACTUALIZACION DISPONIBLE
:: -------------------------------------------------------
:AVISO_UPDATE
echo %ESC%[?25h
echo.
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo %YELL%   NUEVA VERSION DISPONIBLE!%RST%
echo %YELL%   Version actual:   %CW%%VERSION_ACTUAL%%RST%
echo %YELL%   Nueva version:    %CW%%VERSION_REMOTA%%RST%
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo %YELL%   NOVEDADES:%RST%
echo %YELL%════════════════════════════════════════════════════════════%RST%
for /f "usebackq tokens=*" %%l in ("%TEMP%\RTIC_Updates\changelog.txt") do echo    %%l
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo.
echo    [1] SI - Descargar e instalar actualizacion
echo    [2] NO - Continuar con la version actual
echo.
set /p "update_choice=%LBLUE%Selecciona una opcion: %RST%"
if "!update_choice!"=="1" goto :PROCESAR_ACTUALIZACION
echo.
echo [INFO] Actualizacion omitida. Continuando...
timeout /t 2 /nobreak >nul
echo %ESC%[?25l
for /L %%S in (5,1,13) do (
    set /a "COLS_ON=%%S * 2"
    for /L %%R in (1,1,8) do (
        set "HROW=!H%%R!"
        call set "LEFT=%%HROW:~0,!COLS_ON!%%"
        call set "RIGHT=%%HROW:~!COLS_ON!%%"
        set "ROW%%R=!ON!!LEFT!!RST!!OFF!!RIGHT!!RST!"
    )
    cls
    echo.
    echo.
    echo !CW!!L0!  !ROW1! !CW!fca!RST!
    echo !CW!!L1!  !ROW2!!RST!
    echo !CW!!L2!  !ROW3!!RST!
    echo !CW!!L3!  !ROW4!!RST!
    echo !CW!!L4!  !ROW5!!RST!
    echo !CW!!L5!  !ROW6!!RST!
    echo !CW!!L6!  !ROW7!!RST!
    echo !CW!!L7!  !ROW8!!RST!
    echo.
    echo                       !CG!Creado por: Eichhh!RST!
    echo                         !CG!Version: %VERSION_ACTUAL%!RST!
    echo.
    echo !CG!!MOD[%%S]!!RST!
    ping -n 1 -w 250 127.255.255.255 >nul
)
echo %ESC%[?25h
goto :MENU_PRINCIPAL

:: ==========================================
:: 3. MENU PRINCIPAL
:: ==========================================
:MENU_PRINCIPAL
color 00
cls

for /f "tokens=2 delims==" %%a in ('wmic bios get serialnumber /value 2^>nul') do set "SERIAL_NUM=%%a"
set "SERIAL_NUM=%SERIAL_NUM: =%"
if "%SERIAL_NUM%"=="" set "SERIAL_NUM=No disponible"

echo.
echo  %ORANGE%═══════════════════════════════════════════════════════════%RST%
echo  %BOLD%%CW%  RTIC HUB FCA%RST%  %LBLUE%Sistema de Gestion UAEMEX%RST%  %MGRAY%v%VERSION_ACTUAL%%RST%
echo  %MGRAY%  Numero de serie del equipo: %MINT%%BOLD%%SERIAL_NUM%%RST%
echo  %ORANGE%═══════════════════════════════════════════════════════════%RST%
echo.
echo  %YELL%  [1]  %BOLD%%CW%Instalacion Inicial%RST%               %DGRAY%[ En desarrollo ]%RST%
echo  %DGRAY%       Drivers, paqueteria basica, configuracion inicial.%RST%
echo.
echo  %YELL%  [2]  %BOLD%%CW%Configuracion de Pantalla%RST%
echo  %DGRAY%       Fondo institucional, bloqueo, descarga de recursos.%RST%
echo.
echo  %YELL%  [3]  %BOLD%%CW%Optimizador del Sistema%RST%
echo  %DGRAY%       Rendimiento, nucleos al maximo, efectos visuales.%RST%
echo.
echo  %YELL%  [4]  %BOLD%%CW%Redes y Conectividad%RST%
echo  %DGRAY%       Hotspot, bloqueo de zona de cobertura, IP estatica.%RST%
echo.
echo  %YELL%  [5]  %BOLD%%CW%Activacion de Licencias%RST%
echo  %DGRAY%       Windows ^(HWID/KMS^), Office LTSC 2021.%RST%
echo.
echo  %YELL%  [6]  %BOLD%%CW%Buscar Actualizaciones%RST%
echo  %DGRAY%       Conecta con GitHub y verifica si hay nueva version.%RST%
echo.
echo  %YELL%  [7]  %BOLD%%CW%Opciones del Sistema%RST%
echo  %DGRAY%       Reiniciar equipo o cerrar sesion.%RST%
echo.
echo  %YELL%  [8]  %BOLD%%CW%Herramienta de Reparacion MRT%RST%
echo  %DGRAY%       Ejecuta el removedor de software malintencionado.%RST%
echo.
echo  %ORANGE%═══════════════════════════════════════════════════════════%RST%
echo  %RED%  [9]  %BOLD%Salir%RST%
echo  %ORANGE%═══════════════════════════════════════════════════════════%RST%
echo.
set /p opcion="%ORANGE%  >> %RST%"

if "%opcion%"=="1" goto :EN_DESARROLLO
if "%opcion%"=="2" goto :SUBMENU_PANTALLA
if "%opcion%"=="3" goto :SUBMENU_OPTIMIZADOR
if "%opcion%"=="4" goto :SUBMENU_REDES
if "%opcion%"=="5" goto :ACTIVACION
if "%opcion%"=="6" goto :VERIFICAR_ACTUALIZACIONES_MANUAL
if "%opcion%"=="7" goto :OPCIONES_SISTEMA
if "%opcion%"=="8" goto :EJECUTAR_MRT
if "%opcion%"=="9" exit
goto :MENU_PRINCIPAL

:: ==========================================
:: DESARROLLO
:: ==========================================
:EN_DESARROLLO
cls
echo.
echo %DGRAY%════════════════════════════════════════════════════════%RST%
echo %DGRAY%             MODULO EN FASE DE DESARROLLO%RST%
echo %DGRAY%════════════════════════════════════════════════════════%RST%
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
echo %SCR%════════════════════════════════════════════════════════%RST%
echo %SCR%           GESTION DE PANTALLA Y APARIENCIA%RST%
echo %SCR%════════════════════════════════════════════════════════%RST%
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
echo ════════════════════════════════════════════════════════
set /p subop="%SCR%Selecciona opcion: %RST%"

if "%subop%"=="1" goto :EN_DESARROLLO
if "%subop%"=="2" goto :PANTALLA_RESTAURAR
if "%subop%"=="3" goto :PANTALLA_SOLO_CANDADO
if "%subop%"=="4" goto :Fondos
if "%subop%"=="5" goto :MENU_PRINCIPAL
goto :SUBMENU_PANTALLA

:: --- LÓGICA DE PANTALLA ---

:PANTALLA_INSTITUCIONAL
cls
call :REGISTRAR_LOG "TWC010" "INICIADO"
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

:: Leer el fondo actual correctamente (maneja rutas con espacios)
for /f "skip=2 tokens=2,*" %%a in ('reg query "HKCU\Control Panel\Desktop" /v Wallpaper 2^>nul') do set "WALLPAPER_ACTUAL=%%b"

:: Limpiar espacios sobrantes al final
set "WALLPAPER_ACTUAL=%WALLPAPER_ACTUAL: =%"
:: Restaurar espacios en rutas (si la ruta los tiene, usa comillas en /d)

echo [DEBUG] Fondo detectado: %WALLPAPER_ACTUAL%

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v Wallpaper /t REG_SZ /d "%WALLPAPER_ACTUAL%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v WallpaperStyle /t REG_SZ /d "10" /f >nul 2>&1

:: Bloqueos Wallpaper
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /t REG_DWORD /d 1 /f >nul 2>&1

:: Bloqueos Lock Screen
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "LockScreenImage" /t REG_SZ /d "C:\Archivos_FCA_UAEMEX\lock_screen_wallpaper_fca.png" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoChangingLockScreen" /t REG_DWORD /d 1 /f >nul 2>&1

:: Ocultar opciones de personalización
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoDispBackgroundPage" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoDispBackgroundPage" /t REG_DWORD /d 1 /f >nul 2>&1

echo.
echo Actualizando politicas...
gpupdate /force >nul 2>&1
start explorer.exe
call :REGISTRAR_LOG "LWC002" "INICIADO"
call :REGISTRAR_LOG "LWC002" "COMPLETADO"
goto :EXITO_RETORNO

:PANTALLA_RESTAURAR
cls
call :REGISTRAR_LOG "UWC002" "INICIADO"
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
call :REGISTRAR_LOG "UWC002" "COMPLETADO"
goto :EXITO_RETORNO

:Fondos
cls
call :REGISTRAR_LOG "WID031" "INICIADO"
echo.
echo [1/3] Preparando carpeta C:\Archivos_FCA_UAEMEX...
if not exist "C:\Archivos_FCA_UAEMEX" mkdir "C:\Archivos_FCA_UAEMEX" >nul 2>&1
icacls "C:\Archivos_FCA_UAEMEX" /grant Todos:F /T /Q >nul 2>&1

echo [2/3] Descargando recursos...
curl -L -s -o "C:\Archivos_FCA_UAEMEX\wallpaper_fca.png" "https://raw.githubusercontent.com/azarel22/FCA/25aad0a3eaf4d5be64142873f873ada8424662bd/wallpaper_fca.png"
curl -L -s -o "C:\Archivos_FCA_UAEMEX\lock_screen_wallpaper_fca.png" "https://raw.githubusercontent.com/azarel22/FCA/25aad0a3eaf4d5be64142873f873ada8424662bd/lock_screen_wallpaper_fca.png"

echo [3/3] Abriendo carpeta...
start "" "C:\Archivos_FCA_UAEMEX"
call :REGISTRAR_LOG "WID031" "COMPLETADO"
goto :EXITO_RETORNO

:: ==========================================
:: SECCION 3: OPTIMIZADOR DEL SISTEMA
:: ==========================================
:SUBMENU_OPTIMIZADOR
cls
echo %OPT%════════════════════════════════════════════════════════%RST%
echo %OPT%         OPTIMIZADOR DE RENDIMIENTO Y ARRANQUE%RST%
echo %OPT%════════════════════════════════════════════════════════%RST%
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
echo ════════════════════════════════════════════════════════
set /p subop="%OPT%Selecciona opcion: %RST%"

if "%subop%"=="1" goto :APLICAR_OPTIMIZACION
if "%subop%"=="2" goto :RESTAURAR_OPTIMIZACION
if "%subop%"=="3" goto :MENU_PRINCIPAL
goto :SUBMENU_OPTIMIZADOR

:APLICAR_OPTIMIZACION
call :REGISTRAR_LOG "TSO013" "INICIADO"
cls
echo.
echo [1/5] Configurando ARRANQUE (Procesadores)...
:: Esto equivale a ir a msconfig y marcar el maximo de nucleos manualmente
bcdedit /set {current} numproc %NUMBER_OF_PROCESSORS% >nul 2>&1
echo  - Nucleos configurados al maximo: %NUMBER_OF_PROCESSORS%

echo [2/5] Configurando EFECTOS VISUALES (Rendimiento)...
:: Establece "Ajustar para obtener el mejor rendimiento" como base
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1

reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f >nul 2>&1

reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1

:: Acelera el despliegue de menus
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1

echo [3/5] Limpiando temporales del sistema...
del /s /f /q "%TEMP%\*.*" >nul 2>&1
for /d %%i in ("%TEMP%\*") do (
  if /i not "%%i"=="%TEMP%\RTIC_Updates" rd /s /q "%%i" >nul 2>&1
)
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%i in ("C:\Windows\Temp\*") do rd /s /q "%%i" >nul 2>&1

echo [4/5] Limpiando archivos recientes y prefetch...
del /s /f /q "%APPDATA%\Microsoft\Windows\Recent\*.*" >nul 2>&1
del /s /f /q "C:\Windows\Prefetch\*.*" >nul 2>&1

echo [5/5] Aplicando cambios visuales...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
echo.
echo [EXITO] Optimizacion aplicada.
echo  Las fuentes se veran bien, pero el resto estara optimizado.
echo  NOTA: Reinicia el equipo para aplicar los nucleos del CPU.
echo.
call :REGISTRAR_LOG "TSO013" "COMPLETADO"
pause
goto :MENU_PRINCIPAL

:RESTAURAR_OPTIMIZACION
cls
call :REGISTRAR_LOG "RSO015" "INICIADO"
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
call :REGISTRAR_LOG "RSO015" "COMPLETADO"
pause
goto :MENU_PRINCIPAL

:: ==========================================
:: SECCION 4: SUBMENU REDES
:: ==========================================
:SUBMENU_REDES
cls
echo %LBLUE%════════════════════════════════════════════════════════%RST%
echo %LBLUE%            GESTION DE REDES Y CONECTIVIDAD%RST%
echo %LBLUE%════════════════════════════════════════════════════════%RST%
echo.
echo    [1] BLOQUEAR ZONA DE COBERTURA (Mobile Hotspot)
echo        - Evita que el usuario comparta internet por WiFi.
echo        - Bloquea regedit.
echo.
echo    [2] PERMITIR ZONA DE COBERTURA (Desbloquear)
echo        - Restaura la opcion de compartir internet.
echo        - Habilita el regedit nuevamente.
echo.
echo    [3] CONFIGURACION IP (MANUAL)
echo        - Asignar IP Estatica, Mascara, Gateway y DNS.
echo.
echo    [4] TEST DE VELOCIDAD
echo        - Mide bajada, subida y latencia en tiempo real.
echo.
echo    [5] Volver al Menu Principal
echo.
echo %LBLUE%════════════════════════════════════════════════════════%RST%
set /p subop="%LBLUE%Selecciona opcion: %RST%"

if "%subop%"=="1" goto :RED_BLOQUEAR_HOTSPOT
if "%subop%"=="2" goto :RED_DESBLOQUEAR_HOTSPOT
if "%subop%"=="3" goto :RED_CONFIG_IP
if "%subop%"=="4" goto :SPEED_TEST
if "%subop%"=="5" (
  echo %RST%
  goto :MENU_PRINCIPAL
)
goto :SUBMENU_REDES

:RED_BLOQUEAR_HOTSPOT
cls
call :REGISTRAR_LOG "LHT404" "INICIADO"
echo.
echo [PROCESANDO] Aplicando politicas de red...
echo.
echo [1/4] Ocultando hotspot en Configuracion de Windows...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Network Connections" /v NC_ShowSharedAccessUI /t REG_DWORD /d 0 /f >nul 2>&1
echo [2/4] Deshabilitando servicio de hotspot (icssvc)...
sc config icssvc start= disabled >nul 2>&1
net stop icssvc >nul 2>&1
echo [3/4] Bloqueando acceso al registro...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t REG_DWORD /d 1 /f >nul 2>&1
echo [4/4] Forzando actualizacion de politicas...
gpupdate /force >nul 2>&1
echo.
echo [INFO] Bloqueo aplicado. REINICIA para ver todos los cambios.
echo.
call :REGISTRAR_LOG "LHT404" "COMPLETADO"
pause
goto :EXITO_RETORNO

:RED_DESBLOQUEAR_HOTSPOT
cls
call :REGISTRAR_LOG "UHT000" "INICIADO"
echo.
echo [PROCESANDO] Eliminando bloqueos de red...
echo.
echo [1/4] Restaurando acceso al registro...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t REG_DWORD /d 0 /f >nul 2>&1
echo [2/4] Eliminando politica de hotspot...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Network Connections" /v NC_ShowSharedAccessUI /f >nul 2>&1
echo [3/4] Reactivando servicio de hotspot...
sc config icssvc start= demand >nul 2>&1
net start icssvc >nul 2>&1
echo [4/4] Actualizando politicas...
gpupdate /force >nul 2>&1
echo.
echo [INFO] Bloqueo eliminado. Reinicia si no aparece la opcion.
echo.
call :REGISTRAR_LOG "UHT000" "COMPLETADO"
pause
goto :EXITO_RETORNO

::==========================================
:: SPEED TEST
::==========================================
:SPEED_TEST
call :REGISTRAR_LOG "SPT458" "INICIADO"
if exist "%TEMP%\speedtest_tmp.ps1" del "%TEMP%\speedtest_tmp.ps1" >nul 2>&1
curl -L -s -f "https://raw.githubusercontent.com/azarel22/FCA/refs/heads/main/speedtest.ps1" -o "%TEMP%\speedtest_tmp.ps1" 2>nul
if not exist "%TEMP%\speedtest_tmp.ps1" (
  echo.
  echo [ERROR] No se pudo descargar el modulo de Speed Test.
  echo  Verifica tu conexion a internet.
  echo.
  pause
  call :REGISTRAR_LOG "SPT458" "ERROR"
  goto :SUBMENU_REDES
)
for /f "tokens=2 delims==" %%a in ('reg query "HKCU\Console" /v FontSize 2^>nul ^| findstr FontSize') do set "FONT_BAK=%%a"
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(90,42); $host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(90,42) } 2>$null; & '%TEMP%\speedtest_tmp.ps1'"
if defined FONT_BAK reg add "HKCU\Console" /v FontSize /t REG_DWORD /d "%FONT_BAK%" /f >nul 2>&1
mode con: cols=90 lines=42
if exist "%TEMP%\speedtest_tmp.ps1" del "%TEMP%\speedtest_tmp.ps1" >nul 2>&1
call :REGISTRAR_LOG "SPT458" "COMPLETADO"
goto :SUBMENU_REDES

:RED_CONFIG_IP
cls
call :REGISTRAR_LOG "IPCv04" "INICIADO"
echo %LBLUE%════════════════════════════════════════════════════════%RST%
echo %LBLUE%        ASISTENTE DE CONFIGURACION IP (MANUAL)%RST%
echo %LBLUE%════════════════════════════════════════════════════════%RST%
echo.
echo [1/5] Identificando interfaces de red...
echo.
netsh interface show interface
echo.
echo     Escribe el nombre EXACTO de la interfaz (Ej: Ethernet).
echo.
set /p ADAPTADOR="%CW%Nombre de la interfaz: %LBLUE%"

cls
echo %LBLUE%════════════════════════════════════════════════════════%RST%
echo %LBLUE%              CONFIGURANDO: %ADAPTADOR%%RST%
echo %LBLUE%════════════════════════════════════════════════════════%RST%
echo.
echo [2/5] Ingresa los datos de conexion...
echo.
set /p IP="%CW%   - Direccion IP: %LBLUE%"
set /p MASCARA="%CW%   - Mascara (Default: 255.255.255.0): %LBLUE%"
set /p PUERTA="%CW%   - Puerta de enlace: %LBLUE%"
echo.
echo [3/5] Configurando Servidores DNS...
set /p DNS1="%CW%   - DNS Preferido: %LBLUE%"
set /p DNS2="%CW%   - DNS Alternativo: %LBLUE%"

cls
echo %LBLUE%════════════════════════════════════════════════════════%RST%
echo %LBLUE%                  RESUMEN DE DATOS%RST%
echo %LBLUE%════════════════════════════════════════════════════════%RST%
echo.
echo     Interfaz : %ADAPTADOR%
echo     IP       : %IP%
echo     DNS 1    : %DNS1%
echo.
echo ════════════════════════════════════════════════════════
echo %LBLUE%Presiona ENTER para aplicar cambios...%RST%
pause >nul

echo.
echo [4/5] Aplicando configuracion IP estatica...
netsh interface ip set address name="%ADAPTADOR%" static %IP% %MASCARA% %PUERTA% >nul 2>&1

echo [5/5] Estableciendo servidores DNS...
netsh interface ip set dns name="%ADAPTADOR%" static %DNS1% >nul 2>&1
netsh interface ip add dns name="%ADAPTADOR%" %DNS2% index=2 >nul 2>&1

echo.
echo ════════════════════════════════════════════════════════
echo %LBLUE%PROCESO FINALIZADO. Probando conexion...%RST%
ping 8.8.8.8 -n 2
echo.
call :REGISTRAR_LOG "IPCv04" "COMPLETADO"
pause
:: LIMPIEZA TOTAL ANTES DE SALIR
echo %RST%
goto :MENU_PRINCIPAL

:: ==========================================
:: SECCION 5: SUBMENU ACTIVACION
:: ==========================================
:ACTIVACION
cls
echo %ACT%════════════════════════════════════════════════════════%RST%
echo %ACT%            CENTRO DE LICENCIAS Y ACTIVACION%RST%
echo %ACT%════════════════════════════════════════════════════════%RST%
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
echo %ACT%════════════════════════════════════════════════════════%RST%
set /p actop="%ACT%Selecciona opcion: %RST%"

if "%actop%"=="1" goto :KEY_OFFICE_2021
if "%actop%"=="2" goto :MAS_POWERSHELL
if "%actop%"=="3" goto :MENU_PRINCIPAL
goto :ACTIVACION

:: --- OPCION 1: OFFICE KEY ---
:KEY_OFFICE_2021
call :REGISTRAR_LOG "OOA021" "INICIADO"
cls
echo.
echo [1/3] Buscando instalacion de Office...

:: Detectar ruta de Office (x64 o x86)
set "OFFICE_DIR="
if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" set "OFFICE_DIR=%ProgramFiles%\Microsoft Office\Office16"
if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" set "OFFICE_DIR=%ProgramFiles(x86)%\Microsoft Office\Office16"

if not defined OFFICE_DIR (
  echo.
  echo [ERROR] No se encontro Office 2016/2019/2021 instalado.
  echo  Verifica que este instalado en la ruta por defecto.
  echo.
  pause
  goto :ACTIVACION
)

echo [2/3] Instalando Clave LTSC 2021 Pro Plus...
echo  Clave: D67NW-YV8J3-CCXTQ-V3B83-M7YGK
cd /d "%OFFICE_DIR%"
cscript //nologo ospp.vbs /inpkey:D67NW-YV8J3-CCXTQ-V3B83-M7YGK

echo.
echo [3/3] Intentando activar...
cscript //nologo ospp.vbs /act

echo.
echo [RESULTADO] Proceso finalizado. Verifica los mensajes anteriores.
echo.
call :REGISTRAR_LOG "OOA021" "COMPLETADO"
pause
goto :ACTIVACION

:: --- OPCION 2: POWERSHELL Masgrave ---
:MAS_POWERSHELL
cls
call :REGISTRAR_LOG "PAA999" "INICIADO"
echo.
echo [INFO] Lanzando PowerShell como Administrador...
echo  Espera a que cargue la ventana azul.
start powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://get.activated.win | iex"
echo.
echo [PROCESO] Script ejecutado en segunda ventana.
call :REGISTRAR_LOG "PAA999" "COMPLETADO"
pause
goto :ACTIVACION

:: ==========================================
:: VERIFICACION MANUAL DE ACTUALIZACIONES
:: ==========================================
:VERIFICAR_ACTUALIZACIONES_MANUAL
cls
echo.
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo %YELL%             VERIFICADOR DE ACTUALIZACIONES%RST%
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo.
echo %CG%   Consultando repositorio GitHub...%RST%
echo.

if not exist "%TEMP%\RTIC_Updates" mkdir "%TEMP%\RTIC_Updates" >nul 2>&1

curl -L -s -f "https://raw.githubusercontent.com/azarel22/FCA/refs/heads/main/version.txt" -o "%TEMP%\RTIC_Updates\version.txt" 2>nul

if errorlevel 1 (
  echo %R_ERR%════════════════════════════════════════════════════════════%RST%
  echo %R_ERR%  ERROR: NO SE PUDO CONECTAR AL REPOSITORIO%RST%
  echo %R_ERR%════════════════════════════════════════════════════════════%RST%
  echo.
  echo  Verifica tu conexion a internet e intentalo de nuevo.
  echo.
  pause
  goto :MENU_PRINCIPAL
)

set "VERSION_REMOTA="
for /f "usebackq tokens=*" %%a in ("%TEMP%\RTIC_Updates\version.txt") do (
  set "VERSION_REMOTA=%%a"
  goto :version_leida_manual
)
:version_leida_manual

if "%VERSION_REMOTA%"=="" (
  echo %R_ERR%════════════════════════════════════════════════════════════%RST%
  echo %R_ERR%  ERROR: NO SE PUDO LEER LA INFORMACION DE VERSION%RST%
  echo %R_ERR%════════════════════════════════════════════════════════════%RST%
  echo.
  pause
  goto :MENU_PRINCIPAL
)

echo %CG%  Version instalada:  %CW%%VERSION_ACTUAL%%RST%
echo %CG%  Version en GitHub:  %CW%%VERSION_REMOTA%%RST%
echo.

if "%VERSION_ACTUAL%"=="%VERSION_REMOTA%" (
  echo %CW%════════════════════════════════════════════════════════════%RST%
  echo %YELL%  Tu sistema esta al dia. No hay actualizaciones.%RST%
  echo %CW%════════════════════════════════════════════════════════════%RST%
  echo.
  pause
  goto :MENU_PRINCIPAL
)

:: Nueva versión disponible
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo %YELL%   NUEVA VERSION DISPONIBLE!%RST%
echo %YELL%   Version actual:   %CW%%VERSION_ACTUAL%%RST%
echo %YELL%   Nueva version:    %CW%%VERSION_REMOTA%%RST%
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo %YELL%   NOVEDADES:%RST%
echo %YELL%════════════════════════════════════════════════════════════%RST%
for /f "usebackq tokens=*" %%l in ("%TEMP%\RTIC_Updates\changelog.txt") do echo    %%l
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo.
echo    [1] SI - Descargar e instalar actualizacion
echo    [2] NO - Volver al menu principal
echo.
set /p update_choice_manual="%LBLUE%Selecciona una opcion: %RST%"

if "%update_choice_manual%"=="1" goto :PROCESAR_ACTUALIZACION
goto :MENU_PRINCIPAL

:: ==========================================
:: PROCESAR ACTUALIZACION
:: ==========================================
:PROCESAR_ACTUALIZACION
cls
echo.
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo %YELL%                  ACTUALIZANDO RTIC HUB FCA%RST%
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo.
echo %CG%   Preparando entorno de actualizacion...%RST%
echo.

set "SCRIPT_PATH=%~f0"
set "SCRIPT_DIR=%~dp0"

echo %YELL%════════════════════════════════════════════════════════════%RST%
echo %CW%   1 / 4   %CG%Descargando nueva version desde GitHub...%RST%
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo.
curl -L -s -f "https://raw.githubusercontent.com/%GITHUB_USER%/%GITHUB_REPO%/refs/heads/main/%SCRIPT_NAME%" -o "%TEMP%\RTIC_Updates\nueva_version.bat"

if errorlevel 1 (
  echo.
  echo %R_ERR%════════════════════════════════════════════════════════════%RST%
  echo %R_ERR%   ERROR   No se pudo descargar la actualizacion.%RST%
  echo %R_ERR%           Verifica tu conexion a internet e intentalo%RST%
  echo %R_ERR%           de nuevo desde el menu principal.%RST%
  echo %R_ERR%════════════════════════════════════════════════════════════%RST%
  echo.
  pause
  goto :MENU_PRINCIPAL
)

echo %MINT%   Descarga completada correctamente.%RST%
echo.
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo %CW%   2 / 4   %CG%Creando respaldo de la version actual...%RST%
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo.
copy "%SCRIPT_PATH%" "%SCRIPT_DIR%RTIC_Hub_FCA_backup_%VERSION_ACTUAL%.bat" >nul 2>&1
echo %MINT%   Respaldo guardado como:%RST%
echo %CW%   RTIC_Hub_FCA_backup_%VERSION_ACTUAL%.bat%RST%
echo.
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo %CW%   3 / 4   %CG%Preparando instalador temporal...%RST%
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo.

(
  echo @echo off
  echo timeout /t 2 /nobreak ^>nul
  echo copy /y "%TEMP%\RTIC_Updates\nueva_version.bat" "%SCRIPT_PATH%" ^>nul 2^>^&1
  echo if errorlevel 1 ^(
  echo     echo ERROR: No se pudo reemplazar el archivo.
  echo     pause
  echo     exit
  echo ^)
  echo del "%TEMP%\RTIC_Updates\nueva_version.bat" ^>nul 2^>^&1
  echo start "" "%SCRIPT_PATH%" skipupdate
  echo exit
) > "%TEMP%\RTIC_Updates\update_script.bat"

echo %MINT%   Instalador listo.%RST%
echo.
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo %CW%   4 / 4   %CG%Aplicando actualizacion...%RST%
echo %YELL%════════════════════════════════════════════════════════════%RST%
echo.
echo %CW%   La aplicacion se cerrara y se reiniciara%RST%
echo %CW%   automaticamente con la nueva version.%RST%
echo.
echo %CG%   Espera un momento...%RST%
echo.
timeout /t 3 /nobreak >nul

start /min "" "%TEMP%\RTIC_Updates\update_script.bat"
exit
goto :MENU_PRINCIPAL

:: ==========================================
:: HERRAMIENTA DE REPARACION MRT
:: ==========================================
:EJECUTAR_MRT
cls
echo.
echo  %ORANGE%═══════════════════════════════════════════════════════════%RST%
echo  %BOLD%%CW%  HERRAMIENTA DE REPARACION DE WINDOWS (MRT)%RST%
echo  %ORANGE%═══════════════════════════════════════════════════════════%RST%
echo.
echo  %DGRAY%  Lanzando el Removedor de Software Malintencionado...%RST%
echo  %DGRAY%  Esta herramienta es proporcionada por Microsoft.%RST%
echo.
call :REGISTRAR_LOG "MRT02n" "INICIADO"
mrt
call :REGISTRAR_LOG "MRT02n" "COMPLETADO"
echo.
echo  %MINT%  MRT finalizado. Regresando al menu principal...%RST%
echo.
pause
goto :MENU_PRINCIPAL

:: ==========================================
:: Para aplicar cambios
:: ==========================================
:OPCIONES_SISTEMA
cls
echo.
echo %SYS%════════════════════════════════════════════════════════%RST%
echo %SYS%                 OPCIONES DEL SISTEMA%RST%
echo %SYS%════════════════════════════════════════════════════════%RST%
echo.
echo  [1] Reiniciar equipo
echo  [2] Cerrar sesion
echo  [0] Volver
echo.
set /p "OPCION_SIS=%SYS%Selecciona una opcion: %RST%"

if "%OPCION_SIS%"=="1" goto :REINICIAR
if "%OPCION_SIS%"=="2" goto :CERRAR_SESION
if "%OPCION_SIS%"=="0" goto :MENU_PRINCIPAL
goto :OPCIONES_SISTEMA

:REINICIAR
echo.
echo Reiniciando equipo...
shutdown /r /t 5 /c "El equipo se reiniciara en 5 segundos"
goto :EOF

:CERRAR_SESION
echo.
echo Cerrando sesion...
shutdown /l
goto :EOF

:: ==========================================
:: FINAL COMUN
:: ==========================================
:EXITO_RETORNO
cls
echo.
echo %MINT%════════════════════════════════════════════════════════%RST%
echo %MINT%            OPERACION COMPLETADA CON EXITO%RST%
echo %MINT%════════════════════════════════════════════════════════%RST%
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