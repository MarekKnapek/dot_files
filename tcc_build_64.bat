echo on
git clone https://repo.or.cz/tinycc.git || goto fail

cd tinycc || goto fail
cd win32 || goto fail
call build-tcc.bat -c cl -t 64 -i ..\..\tcc1 -b ..\..\tcc1 || goto fail
cd .. || goto fail
git clean -dfx || goto fail
git reset --hard || goto fail
cd .. || goto fail

set path=%cd%\tcc1;%path%

cd tinycc || goto fail
cd win32 || goto fail
call build-tcc.bat -c tcc -t 64 -i ..\..\tcc2 -b ..\..\tcc2 || goto fail
cd .. || goto fail
git clean -dfx || goto fail
git reset --hard || goto fail
cd .. || goto fail

set path=%cd%\tcc2;%path%

cd tinycc || goto fail
cd win32 || goto fail
call build-tcc.bat -c tcc -t 64 -i ..\..\tcc3 -b ..\..\tcc3 || goto fail
cd .. || goto fail
git clean -dfx || goto fail
git reset --hard || goto fail
cd .. || goto fail

set path=%cd%\tcc3;%path%

cd tinycc || goto fail
cd win32 || goto fail
call build-tcc.bat -c tcc -t 64 -i ..\..\tcc4 -b ..\..\tcc4 || goto fail
cd .. || goto fail
git clean -dfx || goto fail
git reset --hard || goto fail
cd .. || goto fail

goto end
:fail
exit /b %errorlevel%
:end
