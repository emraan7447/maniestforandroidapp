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
:: CREATE FOLDERS
:: =============================
echo Creating project and SDK folders...
mkdir "%TWA_PROJECT%" >nul 2>&1
mkdir "%ANDROID_SDK%" >nul 2>&1

:: =============================
:: CHECK NODE.JS
:: =============================
where node >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Node.js not found. Please install from https://nodejs.org
    pause
    exit /b
)

:: =============================
:: CHECK JAVA
:: =============================
java -version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Java JDK 17 not found. Please install from https://adoptium.net
    pause
    exit /b
)

:: =============================
:: INSTALL BUBBLEWRAP CLI
:: =============================
where bubblewrap >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Installing Bubblewrap CLI...
    npm install -g @bubblewrap/cli
)

:: =============================
:: SET ENV VARIABLES
:: =============================
set BUBBLEWRAP_ANDROID_SDK=%ANDROID_SDK%
set ANDROID_HOME=%ANDROID_SDK%
set PATH=%BUBBLEWRAP_ANDROID_SDK%\tools\bin;%PATH%

:: =============================
:: ACCEPT ANDROID SDK LICENSES (non-interactive)
:: =============================
echo Accepting Android SDK licenses...
echo y| "%ANDROID_SDK%\tools\bin\sdkmanager.bat" --licenses >nul 2>&1

:: =============================
:: INITIALIZE TWA PROJECT (non-interactive)
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
 --store-password "%STORE_PASSWORD%" ^
 --quiet

:: =============================
:: BUILD APK
:: =============================
echo Building APK...
bubblewrap build --quiet

echo.
echo ===================================
echo APK BUILD COMPLETE!
echo Your APK is located at: %TWA_PROJECT%\output\app-release.apk
echo ===================================
pause
ENDLOCAL
