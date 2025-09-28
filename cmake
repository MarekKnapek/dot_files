cmake -G "Visual Studio 17 2022" -A Win32
cmake -G "Visual Studio 17 2022" -A x64
cmake -DCMAKE_TOOLCHAIN_FILE=c:\dev\mnt\mkdisk\dev\repos\vcpkg\scripts\buildsystems\vcpkg.cmake -G "Visual Studio 17 2022" -A Win32 -B x86 -S ..


cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS_DEBUG="-g -O0" -DCMAKE_CXX_FLAGS_DEBUG="-g -O0" ..
