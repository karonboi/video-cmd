@echo off
set framemax=0

:del_ifexist
del frame\*.bmp
if exist .paus del .paus
if exist .jump del .jump
if exist .paus_frame del .paus_frame
if exist .restrt del .restrt
if exist .stop del .stop
if exist .ext del .ext
goto set

:set
if not exist frame mkdir frame
set frame=1
goto extract

:extract
title video-cmd [Extracting the frames using unzip...]
unzip frame.zip
goto copy

:copy
set /a framemax=%framemax%+1
copy frame_%framemax%.bmp frame\frame_%framemax%.bmp
title video-cmd [%framemax% frame(s) moved...]
if exist frame_%framemax%.bmp goto copy
if not exist frame_%framemax%.bmp goto clean
goto copy

:clean
del *.bmp
goto framemax_record

:framemax_record
set /a framemax=%framemax%-1
echo %framemax%>.framemax
goto prepare

:prepare
cls
title video-cmd [Counting finished. Waiting to start the video.]
echo So, we have %framemax% frames in total.
echo.
echo Please make sure that the video's FPS rate
echo is set to 30, else the timimg will be incorrect.
echo.
echo [press any key to start]
start console.exe
pause >nul
goto loop

:loop
cls
title video-cmd [%frame%/%framemax% frames played]
frame\insertbmp /p:"frame_%frame%.bmp" /x:0 /y:0 /z:80
timeoutms 1
if exist .paus goto frame_capture
if not exist .paus goto restrt_verif
goto loop

:restrt_verif
if exist .restrt goto restart
if not exist .restrt goto jump_verif
goto loop

:jump_verif
if exist .jump goto jump
if not exist .jump goto stop_verif
goto loop

:stop_verif
if exist .stop goto stop
if not exist .stop goto exit_verif
goto loop

:exit_verif
if exist .ext goto exit
if not exist .ext goto gtr_verif
goto loop

:gtr_verif
set /a frame=%frame%+1
if %frame% gtr %framemax% goto endloop
goto loop

:frame_capture
echo %frame%>.paus_frame
goto pause

:pause
cls
title video-cmd [Paused at frame %frame%]
frame\insertbmp /p:"frame_%frame%.bmp" /x:0 /y:0 /z:80
if exist .paus goto pause
if not exist .paus goto unpause
goto jump_veirf_paus

:jump_veirf_paus
if exist .jump goto jump_paus
if not exist .jump goto stop_verif_paus
goto jump_verif_paus

:stop_verif_paus
if exist .stop goto stop
if not exist .stop goto exit_verif_paus
goto pause

:exit_verif_paus
if exist .ext goto exit
if not exist .ext goto restrt_veirf_paus
goto pause

:restrt_veirf_paus
if exist .restrt goto restart
if not exist .restrt goto pause
goto pause

:unpause
del .paus_frame
goto gtr_verif

:endloop
title video-cmd [The video is ended]
taskkill /f /im console.exe
pause
goto count_framemax

:jump
< .jump (
set /p frame_jump=
)
goto del_jump

:del_jump
del .jump
set /a frame=%frame_jump%
goto captured

:captured
title video-cmd [Jumped to the frame %frame%]
timeoutms 1000
goto loop

:jump_paus
< .jump (
set /p frame_jump_paus=
)
goto del_jump_paus

:del_jump_paus
del .jump
set /a frame=%frame_jump_paus%
goto captured_paus

:captured_paus
title video-cmd [Jumped to the frame %frame%]
timeoutms 1000
goto pause

:restart
del .restrt
goto count_framemax

:stop
del .stop
title video-cmd [Stopped at the frame %frame%]
goto endloop_forced

:endloop_forced
title video-cmd [The video was stopped at frame %frame%]
taskkill /f /im console.exe
pause
goto count_framemax

:exit
del .ext
exit