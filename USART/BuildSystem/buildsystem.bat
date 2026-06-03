@echo off
SETLOCAL

if /I "%~1"=="clean" goto do_clean
if /I "%~1"=="build" goto do_build
goto usage

:usage
echo Usage: buildsystem.bat [clean ^| build]
exit /b 1

:do_clean
echo Cleaning...
if exist ..\build rmdir /s /q ..\build
if exist ..\output (
    del /q /f /s ..\output\*
    for /d %%p in (..\output\*) do rmdir /s /q "%%p"
)
echo Cleaned successfully.
exit /b 0

:do_build
echo Building for STM32...
if not exist ..\build mkdir ..\build
if not exist ..\output mkdir ..\output

cd ..\build
:: SỬA LỖI QUAN TRỌNG: Thêm file Toolchain để chỉ định trình biên dịch ARM [1]
cmake -G "MinGW Makefiles" -DCMAKE_TOOLCHAIN_FILE=../BuildSystem/arm-none-eabi.cmake -DCMAKE_MAKE_PROGRAM=mingw32-make ..
if %ERRORLEVEL% NEQ 0 (
    echo CMake configuration failed!
    cd ..\BuildSystem
    exit /b %ERRORLEVEL%
)

cmake --build .
if %ERRORLEVEL% NEQ 0 (
    echo Compilation failed!
    cd ..\BuildSystem
    exit /b %ERRORLEVEL%
)

echo Build complete! Check 'output' folder for .elf, .bin, and .hex files.
cd ..\BuildSystem
exit /b 0
