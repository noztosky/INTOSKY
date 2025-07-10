@echo off
chcp 65001 > nul

goto :main

:: WSL 연결 확인 함수
:check_wsl
echo WSL 연결 상태 확인 중...
dir "\\wsl.localhost\Ubuntu-20.04\" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [경고] WSL Ubuntu-20.04에 접근할 수 없습니다.
    echo WSL이 실행 중인지 확인하세요.
    set WSL_AVAILABLE=0
) else (
    echo [정보] WSL 연결 확인됨
    set WSL_AVAILABLE=1
)
goto :eof

:: 파일 복사 함수
:copy_files
set "SOURCE=%~1"
set "DEST_DIR=%~2"  
set "FILE_TYPE=%~3"

if not exist "%DEST_DIR%" mkdir "%DEST_DIR%"

:: 소스 경로가 WSL인 경우 WSL 가용성 확인
echo %SOURCE% | findstr "\\wsl.localhost" >nul
if %ERRORLEVEL% EQU 0 (
    if %WSL_AVAILABLE% EQU 0 (
        echo [건너뜀] %FILE_TYPE% - WSL 사용 불가
        goto :eof
    )
)

:: 파일 존재 확인 (더 안전한 방법)
dir "%SOURCE%" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [경고] %FILE_TYPE% 파일을 찾을 수 없습니다
    echo         경로: %SOURCE%
) else (
    echo %FILE_TYPE% 복사 중...
    copy "%SOURCE%" "%DEST_DIR%\" /Y >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo [완료] %FILE_TYPE% 복사 성공
    ) else (
        echo [오류] %FILE_TYPE% 복사 실패
    )
)
goto :eof

:: 메인 실행부
:main
echo VandiPlay 배포 스크립트 v2.0
echo ==============================

:: WSL 상태 확인
call :check_wsl
echo.

:: 경로 설정
set "WSL_SOURCE=\\wsl.localhost\Ubuntu-20.04\home\nodes\release\*.zip"
set "ARDUPILOT_DIR=%~dp0ardupilot (4.5.x)"
set "VANDIPLAY_V2_SOURCE=D:\intosky\Android\VandiPlay-master\mygcs\release\*.apk"
set "VANDIPLAY_V2_DIR=%~dp0vandiplay (v2)"
set "VANDIPLAY_V3_SOURCE=D:\intosky\Android\VandiPlay-noztosky\mygcs\release\*.apk"
set "VANDIPLAY_V3_DIR=%~dp0vandiplay (v3)"

:: 파일 복사 실행
call :copy_files "%WSL_SOURCE%" "%ARDUPILOT_DIR%" "ArduPilot ZIP"
echo.
call :copy_files "%VANDIPLAY_V2_SOURCE%" "%VANDIPLAY_V2_DIR%" "VandiPlay v2 APK"
echo.
call :copy_files "%VANDIPLAY_V3_SOURCE%" "%VANDIPLAY_V3_DIR%" "VandiPlay v3 APK"

echo.
echo ==============================
echo [완료] 배포 작업이 완료되었습니다.
echo.
echo 결과 확인:
if exist "%ARDUPILOT_DIR%\*.zip" (echo ✓ ArduPilot ZIP 파일 있음) else (echo ✗ ArduPilot ZIP 파일 없음)
if exist "%VANDIPLAY_V2_DIR%\*.apk" (echo ✓ VandiPlay v2 APK 있음) else (echo ✗ VandiPlay v2 APK 없음)
if exist "%VANDIPLAY_V3_DIR%\*.apk" (echo ✓ VandiPlay v3 APK 있음) else (echo ✗ VandiPlay v3 APK 없음)
echo.
pause 