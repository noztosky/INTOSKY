@echo off
chcp 65001 > nul

:: 이동/복사 설정 (1=이동, 0=복사)
set ISMOVING=0

set "WSL_SOURCE=\\wsl.localhost\Ubuntu-20.04\home\nodes\release\"
set "ARDUPILOT_DIR=%~dp0ardupilot (4.5.x)"

if not exist "%ARDUPILOT_DIR%" mkdir "%ARDUPILOT_DIR%"

if not exist "%WSL_SOURCE%" (
    echo [오류] WSL 경로 접근 불가: %WSL_SOURCE%
    pause
    exit /b 1
)

if %ISMOVING%==1 (
    echo ArduPilot ZIP 파일 이동 중...
    move "%WSL_SOURCE%*.zip" "%ARDUPILOT_DIR%\" >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo [완료] ArduPilot 이동 성공
    ) else (
        echo [오류] ArduPilot 이동 실패
    )
) else (
    echo ArduPilot ZIP 파일 복사 중...
    copy "%WSL_SOURCE%*.zip" "%ARDUPILOT_DIR%\" /Y
    if %ERRORLEVEL% EQU 0 (
        echo [완료] ArduPilot 복사 성공
    ) else (
        echo [오류] ArduPilot 복사 실패
    )
)

echo.
echo VandiPlay v3 APK 복사 중...

set "VANDIPLAY_V3_DIR=%~dp0vandiplay (v3)"
set "APK_SOURCE=d:\intosky\Android\VandiPlay-noztosky\mygcs\build\outputs\apk\release\*.apk"
if not exist "%VANDIPLAY_V2_DIR%" mkdir "%VANDIPLAY_V2_DIR%"

if not exist "%APK_SOURCE%" (
    echo [오류] APK 파일을 찾을 수 없습니다
    goto end
)

if %ISMOVING%==1 (
    move "%APK_SOURCE%" "%VANDIPLAY_V3_DIR%\" >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo [완료] VandiPlay v3 이동 성공
    ) else (
        echo [오류] VandiPlay v3 이동 실패
    )
) else (
    copy "%APK_SOURCE%" "%VANDIPLAY_V3_DIR%\" /Y
    if %ERRORLEVEL% EQU 0 (
        echo [완료] VandiPlay v3 복사 성공
    ) else (
        echo [오류] VandiPlay v3 복사 실패
    )
)

:end
pause 