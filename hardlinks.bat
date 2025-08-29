@if "%~1"=="/inner" goto mk_inner
@cmd.exe /c ""%~f0" /inner "%cd%" %*" || goto mk_fail
@goto mk_end

:mk_inner
@echo off
if "%~3"=="" goto mk_args_0
if "%~4"=="" goto mk_args_1
if "%~5"=="" goto mk_args_2
if "%~6"=="" goto mk_args_3
if "%~7"=="" goto mk_args_4
goto mk_args_5_or_more
exit /b 1
goto mk_end

:mk_args_0
echo Call with two parameters, src and dst.
goto mk_end

:mk_args_1
echo Call with two parameters, src and dst. Error, 1 parameter provided.
exit /b 1
goto mk_end

:mk_args_2
if exist "%~f3\*" goto mk_args_2_dir
goto mk_args_2_file
:mk_args_2_dir
pushd "%~f3" || goto mk_fail
for %%i in (*) do call "%~f0" /inner %2 /cmd_file "%~3" "%~4" "%%i"
for /d %%i in (*) do call "%~f0" /inner %2 /cmd_dir "%~3" "%~4" "%%i"
popd || goto mk_fail
goto mk_end
:mk_args_2_file
pushd %2 || goto mk_fail
mklink /h "%~4" "%~3" > nul 2>&1
popd || goto mk_fail
goto mk_end

:mk_args_3
echo Call with two parameters, src and dst. Error, 3 parameters provided.
exit /b 1
goto mk_end

:mk_args_4
if "%~3"=="/cmd_file" goto mk_cmd_file
if "%~3"=="/cmd_dir" goto mk_cmd_dir
echo Bad sub-command.
exit /b 1
goto mk_end

:mk_args_5_or_more
echo Call with two parameters, src and dst. Error, too many parameters provided.
exit /b 1
goto mk_end

:mk_cmd_file
pushd "%~2" || goto mk_fail
call "%~f0" /inner %2 "%~4\%~6" "%~5\%~6"
popd || goto mk_fail
goto mk_end

:mk_cmd_dir
pushd "%~2" || goto mk_fail
mkdir "%~5\%~6" 2>nul
rem cmd.exe /c ""%~f0" /inner %2 "%~4\%~6" "%~5\%~6"" || goto mk_fail
call "%~f0" /inner %2 "%~4\%~6" "%~5\%~6" || goto mk_fail
popd || goto mk_fail
goto mk_end

:mk_fail
@exit /b %errorlevel%
@goto mk_end

:mk_end
