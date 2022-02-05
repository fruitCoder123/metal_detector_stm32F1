@echo off

pushd %cd%

del /q/s bin
del /q/s build

call :create_dir_if_not_exist_and_cd_into_it build
call :create_dir_if_not_exist_and_cd_into_it target
call :create_dir_if_not_exist_and_cd_into_it release

@echo on

cmake -G"CodeBlocks - Ninja" -DCMAKE_TOOLCHAIN_FILE=../../../cmake/TargetToolchain_gcc_arm.cmake -DCMAKE_BUILD_TYPE=Release ../../..
ninja all -v

popd
exit /b 0

:create_dir_if_not_exist_and_cd_into_it
set folder=%~1
if not exist %folder% mkdir %folder%
cd %folder%
