@if "%~1"=="/inner" goto mk_inner
@cmd.exe /c ""%~f0" /inner %*"
@set mk_err=%errorlevel%
@if %mk_err%==0 goto mk_overal_gud
@goto mk_overal_bad
:mk_overal_gud
@echo Gud.
@goto mk_overal_end
:mk_overal_bad
@echo Bad.
@goto mk_overal_end
:mk_overal_end
@pause
@exit /b %mk_err%

:mk_inner
@echo off
if "%~2"=="" goto mk_args_0
if "%~3"=="" goto mk_args_1
if "%~4"=="" goto mk_args_2
goto mk_args_3
exit /b 1

:mk_args_0
echo Provide 2 args, 0 provided.
exit /b 1

:mk_args_1
echo Provide 2 args, 1 provided.
exit /b 1

:mk_args_3
echo Provide 2 args, 3 or more provided.
exit /b 1

:mk_args_2
if not exist "%~f2" goto mk_not_found_2
if exist "%~f2\*" goto mk_args_2_dir
goto mk_args_2_file

:mk_args_2_dir
if exist "%~f3\*" goto mk_target_dir_do_exist
goto mk_target_dir_no_exist
:mk_target_dir_do_exist
goto mk_args_2_continue
:mk_target_dir_no_exist
mkdir "%~f3" || goto mk_fail
goto mk_args_2_continue
:mk_args_2_continue
pushd "%~f2" || goto mk_fail
for %%i in (*) do call "%~f0" /inner "%%i" "%~f3\%%i"
for /d %%i in (*) do call "%~f0" /inner "%%i" "%~f3\%%i"
popd || goto mk_fail
goto mk_end

:mk_args_2_file
mklink /h "%~3" "%~2" > nul 2>&1
goto mk_end

:mk_not_found_2
echo File %~f2 does not exist.
goto mk_fail

:mk_fail
exit /b 1

:mk_end
