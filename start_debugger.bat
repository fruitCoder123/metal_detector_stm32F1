
set path=%path%;%GCC_HOME_ARM%\bin

set GDB=arm-none-eabi-gdb.exe

call conda.bat activate metal_detector

start /wait /b %GDB% metal_detector_Debug.elf --cd=build\target\debug --command=..\..\..\gdb\gdb_start_script.txt

pause

