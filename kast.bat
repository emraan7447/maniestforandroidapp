@echo off
SETLOCAL

:: =============================
:: SETTINGS
:: =============================
SET SAFE_ROOT=C:\Android
SET TWA_PROJECT=%SAFE_ROOT%\TWAProject
SET ANDROID_SDK=%SAFE_ROOT%\android_sdk
SET MANIFEST_JSON=https://emraan7447.github.io/maniestforandroidapp/manifest.json
SET APP_NAME=Kasturi Foods
SET PACKAGE_ID=com.kasturi.foods
SET KEYSTORE_NAME=android.keystore
SET KEY_ALIAS=kasturi_key
SET KEY_PASSWORD=kasturi123
SET STORE_PASSWORD=kasturi123

:: =============================
:: CREATE SAFE FOLDERS
:: =============================
echo Creating project and SDK folders...
mkdir "%TWA_PROJECT%"
mkdir "%ANDROID_SDK%"

:: =============================
:: INSTALL NODE.JS IF MISSING
:: =============================
where node >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Node.js not found. Please install Node.js manually from https://nodejs.org
    pause
    exit /b
)

:: =============================
:: INSTALL JAVA JDK 17 IF MISSING
:: =============================
java -version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Java JDK 17 not found. Please install from https://adoptium.net
    pause
    exit /b
)

:: =============================
:: INSTALL BUBBLEWRAP CLI IF MISSING
:: =============================
where bubblewrap >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Installing Bubblewrap CLI...
    npm install -g @bubblewrap/cli
)

:: =============================
:: SET ENVIRONMENT VARIABLES
:: =============================
echo Setting environment variables...
set BUBBLEWRAP_ANDROID_SDK=%ANDROID_SDK%
set ANDROID_HOME=%ANDROID_SDK%
set PATH=%BUBBLEWRAP_ANDROID_SDK%\tools\bin;%PATH%

:: =============================
:: INITIALIZE TWA PROJECT
:: =============================
echo Initializing Trusted Web Activity...
cd /d "%TWA_PROJECT%"

bubblewrap init ^
 --manifest "%MANIFEST_JSON%" ^
 --skipJDKCheck ^
 --sdk-path "%ANDROID_SDK%" ^
 --package-id "%PACKAGE_ID%" ^
 --app-name "%APP_NAME%" ^
 --path "%TWA_PROJECT%" ^
 --keystore "%TWA_PROJECT%\%KEYSTORE_NAME%" ^
 --key-alias "%KEY_ALIAS%" ^
 --key-password "%KEY_PASSWORD%" ^
 --store-password "%STORE_PASSWORD%"

:: =============================
:: BUILD APK
:: =============================
echo Building APK...
bubblewrap build

echo.
echo ===========================
echo DONE! APK GENERATED IN %TWA_PROJECT%\output\
echo ===========================
pause
ENDLOCAL
