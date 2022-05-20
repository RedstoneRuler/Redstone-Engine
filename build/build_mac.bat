@echo off
color 0a
cd ..
echo BUILDING GAME
lime build mac -release
echo.
echo done.
pause
pwd
explorer export\release\neko\bin