
set path=%path%;%GCC_HOME_ARM%

call conda.bat activate metal_detector

start /wait /b openocd -f interface/stlink-v2.cfg -f target/stm32f1x.cfg -c "init" -c "reset halt"
