::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBNQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFBVAXg2GAES0A5EO4f7+086CsUYJW/IDbobf37vDI+0X1kbre4Ui2n8UndMJbA==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
title video-cmd console

rem The main app and the console are bridged together by these files: ".frame", ".framemax", ".paus", etc. They will be described below.

:read
rem Detects the number of frames the video has, by reading the data from the main app.
< .framemax (
set /p framemax=
)
goto console

:console
cls
echo This is video-cmd console. Just like other media players, this window
echo controls the video using various commands.
echo.
echo Type -h for help.
echo.
goto comm

:comm
set /p comm=">>"
rem This is the list of the commands.
if %comm% == paus goto pause
if %comm% == unpaus goto unpause
if %comm% == captur goto capture_mode
if %comm% == restrt goto restart
if %comm% == jump goto jump
if %comm% == stop goto stop
if %comm% == -h goto help
if %comm% == -exit goto exit
if not %comm% == paus goto invalid
if not %comm% == unpaus goto invalid
if not %comm% == captur goto invalid
if not %comm% == restrt goto invalid
if not %comm% == jump goto invalid
if not %comm% == stop goto invalid
if not %comm% == -h goto invalid
if not %comm% == -exit goto invalid
if not defined %comm% goto invalid
goto comm

:invalid
rem Directs to this scene when the user makes mistakes.
echo.
echo Invalid command or value
echo.
goto comm

:pause
rem Sends the pause signal to the main app.
echo. > .paus
echo.
echo Video paused.
echo.
goto comm

:unpause
rem Returns the pause signal so the main app can continue playing.
del .paus
echo.
echo Video unapused.
echo.
goto comm

:capture_mode
rem Allows users to save a frame of the video.
rem Either choose a frame or the one that is paused.
echo.
echo How do you want to capture?
echo 1. Pick a ramdom frame
echo 2. Use the frame that in pause
set /p capt=
if %capt% == 1 goto capture_random
if %capt% == 2 goto paus_verif_capture
if not %capt% == 1 goto invalid
if not %capt% == 2 goto invalid
if not defined %capt% goto invalid
goto capture_mode

:paus_verif_capture
if exist .paus goto capture_paus
if not exist .paus goto pausfirst_capture

:pausfirst_capture
echo.
echo In order to capture the frame in this mode, 
echo you need to pause the video first.
echo.
goto comm

:capture_paus
< .paus_frame (
set /p frame=
)
goto save_capture_paus

:save_capture_paus
if not exist captured mkdir captured
copy frame\frame_%frame%.bmp captured\captured_%frame%_%random%.png
echo.
echo Frame %frame% captured. Saves are stored at directory 'captured'.
echo.
goto comm

:capture_random
echo.
echo Which frame do you want to capture?
echo Say, we have %framemax% frames in total.
set /p frame_capt=
if %frame_capt% gtr %framemax% goto invalid
if %frame_capt% lss 1 goto invalid
goto save_capture_random

:save_capture_random
if not exist captured mkdir captured
copy frame\frame_%frame%.bmp captured\captured_%frame%_%random%.png
echo.
echo Frame %frame% captured. Saves are stored at directory 'captured'.
echo.
goto comm

:jump
rem Jumps to a specific frame chosen by the user.
rem Only takes effect when the video is running or unpaused.
echo.
echo Which frame do you want to jump to?
echo Say, we have %framemax% frames in total.
set /p frame_jump=
if %frame_jump% gtr %framemax% goto invalid
if %frame_jump% lss 1 goto invalid
goto jumptoframe

:jumptoframe
echo %frame_jump%>.jump
echo.
echo Jump request to the frame %frame_jump% is sent.
echo If the video is paused, unpause it to take effect.
echo.
goto comm

:restart
echo. > .restrt
echo.
echo Restart request is sent to the main.
echo If the video is paused, unpause it to take effect.
echo.
goto comm

:stop
echo. > .stop
echo.
echo Stop request sent.
echo If the video is paused, unpause it to take effect.
echo.
goto comm

:exit
echo. > .ext
echo.
echo Exit request sent. The console will now shutdown.
echo If the video is paused, close it.
pause >nul
exit

:help
echo.
echo Usage:
echo paus   - Pauses the vdieo
echo unpaus - Unpauses the video
echo captur - Captures a frame during a pause or a random frame
echo jump   - 'Moonjump's to a frame chosen by the user
echo restrt - Restarts the video... or the whole app
echo stop   - Stops the video. This forces the app to end the play
echo -exit  - Quit the program
echo.
goto comm
