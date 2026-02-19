@echo off
:: ==========================================
:: Creado por: Eichhh
:: Versión: 3.0 (Con Bloqueo Independiente)
:: ==========================================

:: Configuración de caracteres para el arte ASCII
chcp 65001 >nul
title Herramienta de Gestion Institucional FCA - UAEMEX

:: ==========================================
:: 1. VERIFICACION DE ADMINISTRADOR
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
echo    las politicas de seguridad (HKLM).
echo.
echo    POR FAVOR:
echo    1. Cierra esta ventana.
echo    2. Haz clic derecho sobre el archivo.
echo    3. Selecciona "Ejecutar como administrador".
echo.
pause
exit

:ES_ADMIN
:: Color Aqua 
color 0B

:: ==========================================
:: 2. MENU PRINCIPAL
:: ==========================================
:MENU_PRINCIPAL
cls
echo ========================================================
echo        SISTEMA DE GESTION FCA - UAEMEX
echo        Creado por: Eichhh  ^|  Version: 3.0
echo ========================================================
echo.
echo    Selecciona una opcion:
echo.
echo    [1] MODO INSTITUCIONAL COMPLETO
echo        - Descarga y aplica fondos oficiales FCA.
echo        - BLOQUEA cambios (Usuario y Sistema).
echo.
echo    [2] RESTAURAR SISTEMA (DESBLOQUEO)
echo        - Elimina todas las restricciones.
echo        - Borra archivos descargados.
echo        - Libera a todos los usuarios.
echo.
echo    [3] SOLO BLOQUEAR CAMBIOS (FONDO ACTUAL)
echo        - Mantiene la imagen que tienes ahora.
echo        - Impide cambiar el fondo manualmente.
echo        - Aplica candados en HKLM y HKCU.
echo.
echo    [4] SALIR
echo.
echo --------------------------------------------------------
set /p opcion="Escribe el numero y presiona Enter: "

if "%opcion%"=="1" goto :BLOQUEAR_FULL
if "%opcion%"=="2" goto :DESBLOQUEAR
if "%opcion%"=="3" goto :SOLO_CANDADO
if "%opcion%"=="4" exit
goto :MENU_PRINCIPAL

:: ==========================================
:: 3. OPCION 1: MODO INSTITUCIONAL
:: ==========================================
:BLOQUEAR_FULL
cls
echo.
echo [1/6] Deteniendo interfaz visual...
taskkill /f /im explorer.exe >nul 2>&1

:: Limpieza preventiva
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f >nul 2>&1

echo [2/6] Preparando carpeta C:\Archivos_FCA_UAEMEX...
if not exist "C:\Archivos_FCA_UAEMEX" mkdir "C:\Archivos_FCA_UAEMEX" >nul 2>&1
icacls "C:\Archivos_FCA_UAEMEX" /grant Todos:F /T /Q >nul 2>&1

echo [3/6] Descargando recursos institucionales...
curl -L -s -o "C:\Archivos_FCA_UAEMEX\wallpaper_fca.png" "https://raw.githubusercontent.com/azarel22/FCA/25aad0a3eaf4d5be64142873f873ada8424662bd/wallpaper_fca.png"
curl -L -s -o "C:\Archivos_FCA_UAEMEX\lock_screen_wallpaper_fca.png" "https://raw.githubusercontent.com/azarel22/FCA/25aad0a3eaf4d5be64142873f873ada8424662bd/lock_screen_wallpaper_fca.png"

echo [4/6] Aplicando identidad visual...
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class WP { [DllImport(\"user32.dll\")] public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni); }'; [WP]::SystemParametersInfo(20, 0, 'C:\Archivos_FCA_UAEMEX\wallpaper_fca.png', 3)"

echo [5/6] Aplicando candados y forzando rutas...
:: Forzar la ruta del wallpaper en el registro
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "Wallpaper" /t REG_SZ /d "C:\Archivos_FCA_UAEMEX\wallpaper_fca.png" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "WallpaperStyle" /t REG_SZ /d "2" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "LockScreenImage" /t REG_SZ /d "C:\Archivos_FCA_UAEMEX\lock_screen_wallpaper_fca.png" /f >nul 2>&1

:: Vamos a la rutina de bloqueo compartido
goto :APLICAR_CANDADOS_REGISTRO

:: ==========================================
:: 4. OPCION 3: SOLO BLOQUEAR (SIN DESCARGAS)
:: ==========================================
:SOLO_CANDADO
cls
echo.
echo [1/3] Preparando sistema para bloqueo...
taskkill /f /im explorer.exe >nul 2>&1

echo [2/3] Aplicando candados de seguridad al fondo actual...
:: Aquí saltamos directo a la aplicación de registros sin cambiar la imagen
goto :APLICAR_CANDADOS_REGISTRO

:: ==========================================
:: 5. RUTINA DE BLOQUEO (COMPARTIDA)
:: ==========================================
:APLICAR_CANDADOS_REGISTRO
:: Esta sección aplica el bloque que pediste integrar de forma robusta

:: --- A. BLOQUEO EN USUARIO ACTUAL (HKCU) ---
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoDispBackgroundPage" /t REG_DWORD /d 1 /f >nul 2>&1

:: --- B. BLOQUEO EN MAQUINA LOCAL (HKLM - Afecta a todos) ---
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /t REG_DWORD /d 1 /f >nul 2>&1

:: Bloqueo de Personalización (Ruta corregida para asegurar funcionamiento en Win10/11)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoChangingLockScreen" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoChangingWallpaper" /t REG_DWORD /d 1 /f >nul 2>&1

:: Ruta adicional de compatibilidad (según tu petición)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoDispBackgroundPage" /t REG_DWORD /d 1 /f >nul 2>&1

echo.
echo Actualizando politicas de grupo...
gpupdate /force >nul 2>&1

echo Reiniciando interfaz...
start explorer.exe
timeout /t 3 /nobreak >nul
goto :FINAL_EXITOSO

:: ==========================================
:: 6. PROCESO DE DESBLOQUEO (RESTAURACION)
:: ==========================================
:DESBLOQUEAR
cls
echo.
echo [1/5] Deteniendo interfaz...
taskkill /f /im explorer.exe >nul 2>&1

echo [2/5] Eliminando Politicas Globales (HKLM)...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoChangingWallPaper /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v NoDispBackgroundPage /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v Wallpaper /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v WallpaperStyle /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" /f >nul 2>&1

echo [3/5] Eliminando Politicas de Usuario (HKCU)...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v NoDispBackgroundPage /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v Wallpaper /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v WallpaperStyle /f >nul 2>&1
reg delete "HKCU\Software\Policies\Microsoft\Windows\Personalization" /f >nul 2>&1

echo [4/5] Limpiando archivos temporales...
if exist "C:\Archivos_FCA_UAEMEX" (
    rmdir /s /q "C:\Archivos_FCA_UAEMEX" >nul 2>&1
)
:: Reactivar sincronización de temas
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ThemeManager" /v "ThemeRoaming" /t REG_DWORD /d 1 /f >nul 2>&1

echo [5/5] Reiniciando sistema...
gpupdate /force >nul 2>&1
start explorer.exe
timeout /t 3 /nobreak >nul
goto :FINAL_EXITOSO

:: ==========================================
:: 7. PANTALLA FINAL
:: ==========================================
:FINAL_EXITOSO
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
echo    [NOTA] Si el fondo no cambia inmediatamente o los
echo    candados persisten, reinicia la PC.
echo.
pause
exit