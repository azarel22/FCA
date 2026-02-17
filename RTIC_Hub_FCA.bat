@echo off
:: ==========================================
:: Creado por: Eichhh
:: Versión: 6.0 (ProgramData + LockScreen Fix + Persistence)
:: ==========================================

chcp 65001 >nul

:: --- DEFINICIÓN DE COLORES ---
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"
set "CW=%ESC%[38;2;255;255;255m"
set "CYAN=%ESC%[96m"
set "GREEN=%ESC%[92m"
set "YELLOW=%ESC%[93m"
set "RED=%ESC%[91m"
set "RST=%ESC%[0m"

title RTIC_HUB_FCA_INSTITUCIONAL

:: ==========================================
:: 1. VERIFICACION DE ADMINISTRADOR
:: ==========================================
net session >nul 2>&1
if %errorLevel% NEQ 0 goto :NO_ADMIN

:: ==========================================
:: 2. DEFINICION DE RUTAS
:: ==========================================
:: Usamos ProgramData para evitar alertas de antivirus
set "RUTA_FCA=%ProgramData%\Archivos_FCA_UAEMEX"
:: Rutas internas de Windows para forzar el fondo
set "WALLPAPER_USER=%AppData%\Microsoft\Windows\Themes\TranscodedWallpaper"
set "CACHED_FILES=%AppData%\Microsoft\Windows\Themes\CachedFiles"

:: ==========================================
:: MENU
:: ==========================================
:SUBMENU_PANTALLA
cls
echo.
echo %CW%========================================================
echo      GESTION DE PANTALLA (MODO INSTITUCIONAL)
echo ========================================================%RST%
echo.
echo    [1] APLICAR TODO (Fondo + Bloqueo + Persistencia)
echo        - Ruta: %ProgramData%
echo.
echo    [2] DESBLOQUEAR SISTEMA
echo        - Permite cambios manuales.
echo.
echo    [3] SALIR
echo.
set /p subop="Selecciona opcion: "

if "%subop%"=="1" goto :PANTALLA_INSTITUCIONAL
if "%subop%"=="2" goto :PANTALLA_RESTAURAR
if "%subop%"=="3" exit
goto :SUBMENU_PANTALLA

:: ==========================================
:: LOGICA PRINCIPAL
:: ==========================================
:PANTALLA_INSTITUCIONAL
cls
echo.
echo %YELLOW%[1/7] Limpiando politicas antiguas...%RST%
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoChangingLockScreen" /f >nul 2>&1
gpupdate /force >nul 2>&1

echo %CYAN%[2/7] Creando carpeta segura y ajustando permisos...%RST%
if not exist "%RUTA_FCA%" mkdir "%RUTA_FCA%" >nul 2>&1

:: TRUCO MAESTRO: Damos permisos al SID Universal "S-1-1-0" (Todos) y a SYSTEM
:: Esto arregla que la pantalla de bloqueo no cargue la imagen desde ProgramData
icacls "%RUTA_FCA%" /grant *S-1-1-0:(OI)(CI)F /T /Q >nul 2>&1
icacls "%RUTA_FCA%" /grant SYSTEM:(OI)(CI)F /T /Q >nul 2>&1

echo %CYAN%[3/7] Descargando recursos...%RST%
:: Verificacion rapida de internet
ping -n 1 -w 2000 8.8.8.8 >nul
if %errorlevel% NEQ 0 goto :SIN_INTERNET

curl -L -s -o "%RUTA_FCA%\wallpaper_fca.png" "https://raw.githubusercontent.com/azarel22/FCA/25aad0a3eaf4d5be64142873f873ada8424662bd/wallpaper_fca.png"
curl -L -s -o "%RUTA_FCA%\lock_screen_wallpaper_fca.png" "https://raw.githubusercontent.com/azarel22/FCA/25aad0a3eaf4d5be64142873f873ada8424662bd/lock_screen_wallpaper_fca.png"

if not exist "%RUTA_FCA%\wallpaper_fca.png" goto :ERROR_ARCHIVOS

echo %CYAN%[4/7] Inyectando Cache (Anti-Reinicio)...%RST%
:: Borramos la caché corrupta o vieja
attrib -r -s -h "%WALLPAPER_USER%" >nul 2>&1
del /F /Q "%WALLPAPER_USER%" >nul 2>&1
del /F /Q "%CACHED_FILES%\*.*" >nul 2>&1
:: Copiamos la imagen de ProgramData a la carpeta de usuario como archivo de sistema
copy /Y "%RUTA_FCA%\wallpaper_fca.png" "%WALLPAPER_USER%" >nul 2>&1

echo %CYAN%[5/7] Configurando Registro...%RST%
:: Fondo de Escritorio
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%RUTA_FCA%\wallpaper_fca.png" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d "10" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v TileWallpaper /t REG_SZ /d "0" /f >nul 2>&1

:: Pantalla de Bloqueo (Lock Screen) apuntando a ProgramData
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "LockScreenImage" /t REG_SZ /d "%RUTA_FCA%\lock_screen_wallpaper_fca.png" /f >nul 2>&1

echo %CYAN%[6/7] Refrescando sistema...%RST%
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class WP { [DllImport(\"user32.dll\")] public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni); }'; [WP]::SystemParametersInfo(20, 0, '%RUTA_FCA%\wallpaper_fca.png', 3)"

echo %YELLOW%      Guardando configuracion... (Espera)%RST%
:: Reiniciamos explorer para fijar los cambios antes de bloquear
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
:: Esperamos 4 segundos obligatorios
timeout /t 4 /nobreak >nul

echo %CYAN%[7/7] Aplicando Candados...%RST%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoChangingLockScreen" /t REG_DWORD /d 1 /f >nul 2>&1
gpupdate /force >nul 2>&1

goto :EXITO_RETORNO

:PANTALLA_RESTAURAR
cls
echo.
echo [INFO] Eliminando restricciones...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v NoDispBackgroundPage /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f >nul 2>&1
reg delete "HKCU\Software\Policies\Microsoft\Windows\Personalization" /f >nul 2>&1

echo [INFO] Restaurando interfaz...
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
gpupdate /force >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
goto :EXITO_RETORNO

:NO_ADMIN
echo.
echo %RED%[ERROR] Ejecutar como Administrador.%RST%
pause
exit

:SIN_INTERNET
echo.
echo %RED%[ERROR] Sin conexion a Internet para descargar fondos.%RST%
pause
goto :SUBMENU_PANTALLA

:ERROR_ARCHIVOS
echo.
echo %RED%[ERROR] Fallo la descarga de archivos.%RST%
pause
goto :SUBMENU_PANTALLA

:EXITO_RETORNO
cls
echo.
echo %GREEN%========================================================
echo           OPERACION COMPLETADA CON EXITO
echo ========================================================%RST%
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
goto :SUBMENU_PANTALLA