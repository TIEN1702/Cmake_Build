@echo off
SETLOCAL

:: Route to the correct block based on the passed argument
if /I "%~1"=="clean" goto do_clean
if /I "%~1"=="build" goto do_build
goto usage

:usage
echo Usage: buildsystem.bat [clean ^| build]
exit /b 1

:do_clean
echo Cleaning...
:: Remove the entire temporary CMake build cache folder
if exist ..\build rmdir /s /q ..\build

:: Clear everything inside the output directory without deleting the directory itself
if exist ..\output (
    del /q /f /s ..\output\*
    for /d %%p in (..\output\*) do rmdir /s /q "%%p"
)
echo Cleaned successfully.
exit /b 0

:do_build
echo Building for STM32...
:: Create artifacts directories if they do not exist
if not exist ..\build mkdir ..\build
if not exist ..\output mkdir ..\output

cd ..\build
:: Configure the project using the cross-compilation toolchain file and MSYS2 MinGW Make backend
cmake -G "MinGW Makefiles" -DCMAKE_TOOLCHAIN_FILE=../BuildSystem/arm-none-eabi.cmake -DCMAKE_MAKE_PROGRAM=mingw32-make ..
if %ERRORLEVEL% NEQ 0 (
    echo CMake configuration failed!
    cd ..\BuildSystem
    exit /b %ERRORLEVEL%
)

:: Compile and link the target binary source files
cmake --build .
if %ERRORLEVEL% NEQ 0 (
    echo Compilation failed!
    cd ..\BuildSystem
    exit /b %ERRORLEVEL%
)

echo Build complete! Check 'output' folder for .elf, .bin, and .hex files.
cd ..\BuildSystem
exit /b 0
