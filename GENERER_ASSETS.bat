@echo off
cd /d "%~dp0"
python tools\generate_assets.py %*
pause
