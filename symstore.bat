symstore add /r /f c:\dev\symbols\ /s c:\dev\mnt\mkdisk\dev\symbols\ /t product
symstore add /r /f c:\dev\symbols\ /s c:\dev\mnt\mkdisk\dev\symbols_cab\ /t product /compress cab
symstore add /r /f c:\dev\symbols\ /s c:\dev\mnt\mkdisk\dev\symbols_zip\ /t product /compress zip
"c:\Program Files (x86)\Windows Kits\8.1\Debuggers\x64\symstore.exe" add /r /f . /s c:\dev\mnt\mkdisk\dev\dev\symbols\ /t product
