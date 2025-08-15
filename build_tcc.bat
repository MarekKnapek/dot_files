@if "%1"=="inner" goto mk_inner
@cmd.exe /c "%~f0" inner %* || goto mk_fail
@goto mk_end

:mk_inner
@echo off
if "%2"=="" goto mk_all
if "%2"=="clone" goto mk_clone
if "%2"=="pull" goto mk_pull
if "%2"=="build_64_cl_tcc1" goto mk_build_64_cl_tcc1
if "%2"=="build_64_tcc1_tcc2" goto mk_build_64_tcc1_tcc2
if "%2"=="build_64_tcc2_tcc3" goto mk_build_64_tcc2_tcc3
if "%2"=="build_64_tcc3_tcc4" goto mk_build_64_tcc3_tcc4
if "%2"=="build_32_cl_tcc1" goto mk_build_32_cl_tcc1
if "%2"=="build_32_tcc1_tcc2" goto mk_build_32_tcc1_tcc2
if "%2"=="build_32_tcc2_tcc3" goto mk_build_32_tcc2_tcc3
if "%2"=="build_32_tcc3_tcc4" goto mk_build_32_tcc3_tcc4
exit /b 1
goto mk_end

:mk_all
cmd.exe /c "%~f0 clone" || goto mk_fail
cmd.exe /c "%~f0 pull" || goto mk_fail
cmd.exe /c "%~f0 build_64_cl_tcc1" || goto mk_fail
cmd.exe /c "%~f0 build_64_tcc1_tcc2" || goto mk_fail
cmd.exe /c "%~f0 build_64_tcc2_tcc3" || goto mk_fail
cmd.exe /c "%~f0 build_64_tcc3_tcc4" || goto mk_fail
cmd.exe /c "%~f0 build_32_cl_tcc1" || goto mk_fail
cmd.exe /c "%~f0 build_32_tcc1_tcc2" || goto mk_fail
cmd.exe /c "%~f0 build_32_tcc2_tcc3" || goto mk_fail
cmd.exe /c "%~f0 build_32_tcc3_tcc4" || goto mk_fail
goto mk_end

:mk_clone
if exist tinycc goto mk_git_dir_y
goto mk_git_dir_n
:mk_git_dir_n
git clone https://repo.or.cz/tinycc.git || goto mk_fail
goto mk_git_dir_y
:mk_git_dir_y
goto mk_end

:mk_pull
cd tinycc || goto mk_fail
git clean -dfx > nul || goto mk_fail
git reset --hard -- > nul || goto mk_fail
git fetch --all --force --prune > nul || goto mk_fail
git pull > nul || goto mk_fail
cd .. || goto mk_fail
goto mk_end










:mk_build_64_cl_tcc1
if exist "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" goto mk_msvs_enterprise
if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" goto mk_msvs_community
exit /b 1
:mk_msvs_enterprise
call "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" amd64 > nul || goto mk_fail
goto mk_msvs_next
:mk_msvs_community
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64 > nul || goto mk_fail
goto mk_msvs_next
:mk_msvs_next
cd tinycc || goto mk_fail
cd win32 || goto fail
call build-tcc.bat -c cl -t 64 -i ..\..\tcc_64_cl_tcc1 -b ..\..\tcc_64_cl_tcc1 > nul || goto mk_fail
@echo off
cd .. || goto mk_fail
cd .. || goto mk_fail
goto mk_end

:mk_build_64_tcc1_tcc2
set path="%~dp0tcc_64_cl_tcc1";%path%
cd tinycc || goto mk_fail
cd win32 || goto fail
call build-tcc.bat -c tcc -t 64 -i ..\..\tcc_64_tcc1_tcc2 -b ..\..\tcc_64_tcc1_tcc2 > nul || goto mk_fail
@echo off
cd .. || goto mk_fail
cd .. || goto mk_fail
goto mk_end

:mk_build_64_tcc2_tcc3
set path="%~dp0tcc_64_tcc1_tcc2";%path%
cd tinycc || goto mk_fail
cd win32 || goto fail
call build-tcc.bat -c tcc -t 64 -i ..\..\tcc_64_tcc2_tcc3 -b ..\..\tcc_64_tcc2_tcc3 > nul || goto mk_fail
@echo off
cd .. || goto mk_fail
cd .. || goto mk_fail
goto mk_end

:mk_build_64_tcc3_tcc4
set path="%~dp0tcc_64_tcc2_tcc3";%path%
cd tinycc || goto mk_fail
cd win32 || goto fail
call build-tcc.bat -c tcc -t 64 -i ..\..\tcc_64_tcc3_tcc4 -b ..\..\tcc_64_tcc3_tcc4 > nul || goto mk_fail
@echo off
cd .. || goto mk_fail
cd .. || goto mk_fail
goto mk_end










:mk_build_32_cl_tcc1
if exist "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" goto mk_msvs_enterprise
if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" goto mk_msvs_community
exit /b 1
:mk_msvs_enterprise
call "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" amd64_x86 > nul || goto mk_fail
goto mk_msvs_next
:mk_msvs_community
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64_x86 > nul || goto mk_fail
goto mk_msvs_next
:mk_msvs_next
cd tinycc || goto mk_fail
cd win32 || goto fail
call build-tcc.bat -c cl -t 32 -i ..\..\tcc_32_cl_tcc1 -b ..\..\tcc_32_cl_tcc1 > nul || goto mk_fail
@echo off
cd .. || goto mk_fail
cd .. || goto mk_fail
goto mk_end

:mk_build_32_tcc1_tcc2
set path="%~dp0tcc_32_cl_tcc1";%path%
cd tinycc || goto mk_fail
cd win32 || goto fail
call build-tcc.bat -c tcc -t 32 -i ..\..\tcc_32_tcc1_tcc2 -b ..\..\tcc_32_tcc1_tcc2 > nul || goto mk_fail
@echo off
cd .. || goto mk_fail
cd .. || goto mk_fail
goto mk_end

:mk_build_32_tcc2_tcc3
set path="%~dp0tcc_32_tcc1_tcc2";%path%
cd tinycc || goto mk_fail
cd win32 || goto fail
call build-tcc.bat -c tcc -t 32 -i ..\..\tcc_32_tcc2_tcc3 -b ..\..\tcc_32_tcc2_tcc3 > nul || goto mk_fail
@echo off
cd .. || goto mk_fail
cd .. || goto mk_fail
goto mk_end

:mk_build_32_tcc3_tcc4
set path="%~dp0tcc_32_tcc2_tcc3";%path%
cd tinycc || goto mk_fail
cd win32 || goto fail
call build-tcc.bat -c tcc -t 32 -i ..\..\tcc_32_tcc3_tcc4 -b ..\..\tcc_32_tcc3_tcc4 > nul || goto mk_fail
@echo off
cd .. || goto mk_fail
cd .. || goto mk_fail
goto mk_end










:mk_fail
@exit /b %errorlevel%
@goto mk_end

:mk_end
