@echo off
:: ==========================================
:: Creado por: Eichhh
:: Versión: 4.0 (Corrección de Fondo y Leyenda)
:: ==========================================

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
echo    las politicas de seguridad.
echo.
echo    POR FAVOR: Clic derecho -> Ejecutar como administrador.
echo.
pause
exit

:ES_ADMIN
color 0B

:: ==========================================
:: 2. MENU PRINCIPAL
:: ==========================================
:MENU_PRINCIPAL
cls
echo ========================================================
echo        SISTEMA DE GESTION FCA - UAEMEX
echo        Versión: 4.0 (Stable)
echo ========================================================
echo.
echo    [1] MODO INSTITUCIONAL (FONDO + BLOQUEO)
echo        - Descarga y fuerza el fondo FCA.
echo        - Bloquea cambios.
echo.
echo    [2] RESTAURAR SISTEMA (DESBLOQUEO TOTAL)
echo        - Quita la leyenda "Administrado por tu organización".
echo        - Permite cambiar el fondo manualmente.
echo        - Borra archivos descargados.
echo.
echo    [3] SOLO BLOQUEAR (CANDADO AL FONDO ACTUAL)
echo        - No descarga nada.
echo        - Solo impide que cambien lo que ya está puesto.
echo.
echo    [4] SALIR
echo.
echo --------------------------------------------------------
set /p opcion="Selecciona una opcion: "

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
echo [1/7] Deteniendo interfaz visual...
taskkill /f /im explorer.exe >nul 2>&1

:: Limpieza previa para asegurar que el cambio entre
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f >nul 2>&1

echo [2/7] Preparando carpeta C:\Archivos_FCA_UAEMEX...
if not exist "C:\Archivos_FCA_UAEMEX" mkdir "C:\Archivos_FCA_UAEMEX" >nul 2>&1
icacls "C:\Archivos_FCA_UAEMEX" /grant Todos:F /T /Q >nul 2>&1

echo [3/7] Descargando recursos...
curl -L -s -o "C:\Archivos_FCA_UAEMEX\wallpaper_fca.png" "https://raw.githubusercontent.com/azarel22/FCA/25aad0a3eaf4d5be64142873f873ada8424662bd/wallpaper_fca.png"
curl -L -s -o "C:\Archivos_FCA_UAEMEX\lock_screen_wallpaper_fca.png" "https://raw.githubusercontent.com/azarel22/FCA/25aad0a3eaf4d5be64142873f873ada8424662bd/lock_screen_wallpaper_fca.png"

echo [4/7] Aplicando fondo al sistema...
:: TRUCO: Forzar registro antes de refrescar y antes de bloquear
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Archivos_FCA_UAEMEX\wallpaper_fca.png" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d "2" /f >nul 2>&1

:: Aplicar visualmente con PowerShell
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class WP { [DllImport(\"user32.dll\")] public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni); }'; [WP]::SystemParametersInfo(20, 0, 'C:\Archivos_FCA_UAEMEX\wallpaper_fca.png', 3)"

:: Forzar actualización de parámetros de usuario
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

echo [5/7] Esperando aplicacion de cambios...
timeout /t 2 /nobreak >nul

:: Ir a la rutina de bloqueo (compartida con opción 3)
goto :APLICAR_CANDADOS_REGISTRO

:: ==========================================
:: 4. OPCION 3: SOLO BLOQUEAR
:: ==========================================
:SOLO_CANDADO
cls
echo.
echo [1/3] Preparando bloqueo...
taskkill /f /im explorer.exe >nul 2>&1
echo [2/3] Aplicando seguridad...
goto :APLICAR_CANDADOS_REGISTRO

:: ==========================================
:: 5. RUTINA DE BLOQUEO (COMPARTIDA)
:: ==========================================
:APLICAR_CANDADOS_REGISTRO
echo [PROCESANDO] Aplicando candados de seguridad (HKLM y HKCU)...

:: --- 1. BLOQUEOS DE FONDO (WALLPAPER) ---
:: Nivel Usuario
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /t REG_DWORD /d 1 /f >nul 2>&1
:: Nivel Máquina (Este es el fuerte)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /t REG_DWORD /d 1 /f >nul 2>&1

:: --- 2. BLOQUEOS DE PANTALLA DE BLOQUEO (LOCK SCREEN) ---
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "LockScreenImage" /t REG_SZ /d "C:\Archivos_FCA_UAEMEX\lock_screen_wallpaper_fca.png" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoChangingLockScreen" /t REG_DWORD /d 1 /f >nul 2>&1

:: --- 3. OCULTAR OPCIONES DE FONDO ---
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoDispBackgroundPage" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoDispBackgroundPage" /t REG_DWORD /d 1 /f >nul 2>&1

echo.
echo Actualizando politicas...
gpupdate /force >nul 2>&1
start explorer.exe
timeout /t 3 /nobreak >nul
goto :FINAL_EXITOSO

:: ==========================================
:: 6. DESBLOQUEO TOTAL (QUITAR LEYENDA)
:: ==========================================
:DESBLOQUEAR
cls
echo.
echo [1/5] Deteniendo interfaz...
taskkill /f /im explorer.exe >nul 2>&1

echo [2/5] Eliminando POLITICAS DE RESTRICCION (HKLM)...
:: ESTO ES LO QUE QUITA LA LEYENDA ROJA "Tu organizacion administra..."

:: Borrar carpeta completa ActiveDesktop (Maquina)
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f >nul 2>&1

:: Borrar carpeta completa Personalization (Maquina)
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /f >nul 2>&1

:: Limpiar claves especificas en System sin borrar toda la carpeta (peligroso borrar todo System)
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v NoDispBackgroundPage /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v Wallpaper /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v WallpaperStyle /f >nul 2>&1

echo [3/5] Eliminando POLITICAS DE USUARIO (HKCU)...
:: Borrar carpeta completa ActiveDesktop (Usuario)
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f >nul 2>&1
:: Borrar carpeta completa Personalization (Usuario)
reg delete "HKCU\Software\Policies\Microsoft\Windows\Personalization" /f >nul 2>&1
:: Limpiar claves System usuario
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v NoDispBackgroundPage /f >nul 2>&1

echo [4/5] Limpiando archivos...
if exist "C:\Archivos_FCA_UAEMEX" (
    rmdir /s /q "C:\Archivos_FCA_UAEMEX" >nul 2>&1
)

echo [5/5] Restaurando configuracion visual...
:: Reactivar roaming de temas para que Windows tome el control de nuevo
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ThemeManager" /v "ThemeRoaming" /t REG_DWORD /d 1 /f >nul 2>&1

:: Refrescar cache de usuario
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
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
echo    [NOTA IMPORTANTE]
echo    Si al desbloquear sigue la leyenda roja, reinicia
echo    la PC completamente para limpiar el registro en RAM.
echo.
pause
exit