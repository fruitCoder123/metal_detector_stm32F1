
set project_name=metal_detector

set path=%path%;%GCC_HOME_ARM%

call conda env update --file %project_name%.yml --prune

start /wait /b conda.bat activate %project_name%
