REM set CONDA_PATH=c:\conda\scripts
REM set ENVS_PATH=..\..\conda

set project_name=metal_detector

REM call %ENVS_PATH%\fix_connection_problem.bat

call conda env update --file %project_name%.yml --prune

start /wait /b conda.bat activate %project_name%
