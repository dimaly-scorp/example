@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Перевірка існування файлу з шляхом до проекту
if not exist "%TEMP%\project_path.txt" (
    echo Помилка: файл project_path.txt не знайдено.
    pause
    exit /b
)

:: Зчитування шляху до проекту
for /f "tokens=* delims=" %%i in ("%TEMP%\project_path.txt") do set project_path=%%i

:: Перевірка, чи шлях не порожній
if "!project_path!"=="" (
    echo Помилка: шлях до проекту порожній.
    pause
    exit /b
)

:: Закриття Visual Studio
taskkill /IM devenv.exe /F >nul 2>&1
echo Visual Studio закрито.

:: Закриття процесу example_for_concept_dll.exe
taskkill /IM example_for_concept_dll.exe /F >nul 2>&1
if errorlevel 1 (
    echo Процес example_for_concept_dll.exe не знайдено або вже закрито.
) else (
    echo Процес example_for_concept_dll.exe успішно завершено.
)

:: Затримка перед видаленням (5 секунд)
echo Очікування перед видаленням проекту...
timeout /t 5 >nul

:: Зняття атрибутів з файлів, якщо вони є "тільки для читання"
if exist "!project_path!" (
    attrib -r -h -s "!project_path!\*" /s /d >nul 2>&1
)

:: Видалення каталогу проекту
if exist "!project_path!" (
    rmdir /S /Q "!project_path!" >nul 2>&1
    if errorlevel 1 (
        echo Помилка: не вдалося видалити проект. Файли або каталоги заблоковані.
    ) else (
        echo Проект успішно видалено.
    )
) else (
    echo Помилка: каталог проекту не знайдено.
)

pause
