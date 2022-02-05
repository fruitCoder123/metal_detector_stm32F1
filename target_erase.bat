set STLINK_CLI_PROG="%STM32CUBEPROG_PATH%\STM32_Programmer_CLI.exe"

REM Erase the memory of the processor
%STLINK_CLI_PROG% --connect port=SWD --erase all



