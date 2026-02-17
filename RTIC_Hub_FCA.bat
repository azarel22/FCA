@echo off
:: ==========================================
:: Creado por: Eichhh
:: Versión: 9.3.10 (Prueba lista)
:: ==========================================

chcp 65001 >nul

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
if %errorLevel% == 0 goto :CHECK_UPDATE

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


:: ==========================================
:: 2.5 VERIFICACION DE ACTUALIZACIONES (MODO SEGURO)
:: ==========================================
:CHECK_UPDATE
set "V_LOCAL=9.3.10"
set "URL_VERSION=https://raw.githubusercontent.com/azarel22/FCA/main/version.txt"
set "URL_SCRIPT=https://raw.githubusercontent.com/azarel22/FCA/main/RTIC_Hub_FCA.bat"

echo %CYAN%[SYSTEM] Buscando actualizaciones en GitHub...%RST%

:: 1. Intentar descargar el archivo de versión
curl -sL --connect-timeout 5 "%URL_VERSION%" -o "%temp%\v_remota.txt"

:: 2. Verificar si el comando curl tuvo éxito
if %errorlevel% NEQ 0 (
    echo %R_ERR%[!] No se pudo conectar con el servidor de actualizaciones.%RST%
    timeout /t 2 >nul
    goto :PANTALLA_CARGA
)

:: 3. Si el archivo no existe, saltar
if not exist "%temp%\v_remota.txt" goto :PANTALLA_CARGA

:: 4. Leer la versión remota de forma segura
set "V_REMOTA="
for /f "usebackq tokens=*" %%a in ("%temp%\v_remota.txt") do set "V_REMOTA=%%a"

:: Limpiar el archivo temporal de inmediato
del "%temp%\v_remota.txt" >nul 2>&1

:: 5. Validar que se obtuvo una versión
if "%V_REMOTA%"=="" goto :PANTALLA_CARGA

:: 6. Limpiar posibles espacios en blanco
set "V_REMOTA=%V_REMOTA: =%"

:: 7. Comparación
if "%V_REMOTA%" == "%V_LOCAL%" (
    echo %CG%[OK] El sistema esta actualizado (v%V_LOCAL%)%RST%
    timeout /t 1 >nul
    goto :PANTALLA_CARGA
)

:: --- Si detecta versión distinta ---
echo.
echo %ORANGE%======================================================
echo    [UPDATE] NUEVA VERSION DETECTADA: %V_REMOTA%
echo ======================================================%RST%
echo.
echo    Tu version: %V_LOCAL%
echo.
set /p upd="¿Deseas actualizar ahora? (S/N): "
if /i "%upd%" NEQ "S" goto :PANTALLA_CARGA

echo %CYAN%[1/2] Descargando version %V_REMOTA%...%RST%
curl -sL "%URL_SCRIPT%" -o "%~dp0%~n0_nuevo.bat"

:: Verificar si la descarga del nuevo script fue exitosa
if %errorlevel% NEQ 0 (
    echo %R_ERR%[ERROR] Error al descargar el nuevo archivo.%RST%
    pause
    goto :PANTALLA_CARGA
)

echo %CYAN%[2/2] Aplicando reemplazo y reiniciando...%RST%

(
    echo @echo off
    echo timeout /t 2 /nobreak ^>nul
    echo del /f /q "%~f0"
    echo move /y "%~dp0%~n0_nuevo.bat" "%~f0"
    echo start "" "%~f0"
    echo del "%%~f0"
) > "%temp%\updater_fca.bat"

start "" "%temp%\updater_fca.bat"
exit



:ES_ADMIN
color 0B

:PANTALLA_CARGA
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
    echo                        %CG%Version: !V_LOCAL!%RST%
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
echo    [6] SALIR
echo.
echo --------------------------------------------------------
set /p opcion="Escribe el numero y presiona Enter: "

if "%opcion%"=="1" goto :EN_DESARROLLO
if "%opcion%"=="2" goto :SUBMENU_PANTALLA
if "%opcion%"=="3" goto :SUBMENU_OPTIMIZADOR
if "%opcion%"=="4" goto :SUBMENU_REDES
if "%opcion%"=="5" goto :ACTIVACION
if "%opcion%"=="6" exit
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