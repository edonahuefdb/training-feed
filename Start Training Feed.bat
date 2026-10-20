@echo off
title Training Feed (keep this window open while you watch)
cd /d "%~dp0"
echo.
echo   Training Feed is running at http://127.0.0.1:8765/
echo   Keep this window open while you use the feed. Close it to stop.
echo.
start "" cmd /c "timeout /t 2 >nul & start "" http://127.0.0.1:8765/"
python -m http.server 8765 --bind 127.0.0.1 >nul 2>&1
if errorlevel 1 (
  echo   Could not start the local web server on port 8765.
  echo   If the feed is already running in another window, just use that one.
  echo   Otherwise make sure Python is installed: https://www.python.org/downloads/
  echo.
  pause
)
