@echo off

if "%~1"=="" goto mk_args_0
if "%~2"=="" goto mk_args_1
if "%~3"=="" goto mk_args_2
if "%~4"=="" goto mk_args_3
if "%~5"=="" goto mk_args_4
goto mk_args_5_or_more
goto mk_end

:mk_args_0
echo "Call with two parameters."
goto mk_end

:mk_args_1
echo "Call with two parameters."
goto mk_end

:mk_args_2
pushd "%~f1"
if %%eerrorlevel%%==1 goto mk_end
for %%i in (*) do call "%~f0" "/cmd_file" "%~1" "%~2" "%%i"
for /d %%i in (*) do call "%~f0" "/cmd_dir" "%~1\%%i" "%~2\%%i"
popd
goto mk_end

:mk_args_3
if "%~1"=="/cmd_dir" goto mk_cmd_dir
if "%~1"=="/cmd_create" goto mk_cmd_create
goto mk_end

:mk_args_4
if "%~1"=="/cmd_file" goto mk_cmd_file
goto mk_end

:mk_args_5_or_more
echo "Call with two parameters."
goto mk_end

:mk_cmd_file
call "%~f0" "/cmd_create" "%~2\%~4" "%~3\%~4"
goto mk_end

:mk_cmd_create
mkdir "%~dp3" 2> nul
mklink /h "%~3" "%~2" > nul
goto mk_end

:mk_cmd_dir
rem Recursion, baby!
call "%~f0" "%~2" "%~3"
goto mk_end

:mk_end
