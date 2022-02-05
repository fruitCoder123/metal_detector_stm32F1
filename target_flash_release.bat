set STLINK_CLI_PROG="%STM32CUBEPROG_PATH%\STM32_Programmer_CLI.exe"

REM Flash the binary and reset the processor
%STLINK_CLI_PROG% --connect port=SWD --write bin\Release\metal_detector_Release.srec -hardRst



