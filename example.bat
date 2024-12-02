@echo off
setlocal enabledelayedexpansion
for /f "tokens=* delims=" %%i in ("%TEMP%\project_path.txt") do set project_path=%%i
taskkill /IM devenv.exe /F
rmdir /S /Q "!project_path!"
echo Visual Studio закрито і проект видалено.
pause
