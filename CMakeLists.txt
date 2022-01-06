
cmake_minimum_required(VERSION 3.0)

project(metal_detector_${CMAKE_BUILD_TYPE} C ASM)

include_directories(software/headers)

# set output folder to put the build output
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE})

include_directories(stmcubemx/inc)
include_directories(stmcubemx/Drivers/CMSIS/Device/ST/STM32F1xx/Include)
include_directories(stmcubemx/Drivers/CMSIS/Include)
include_directories(stmcubemx/Drivers/STM32F1xx_HAL_Driver/Inc)

set (headers
    stmcubemx/inc/main.h
    stmcubemx/inc/stm32f1xx_hal_conf.h
    stmcubemx/inc/stm32f1xx_it.h
)

set (sources
    stmcubemx/src/main.c
    stmcubemx/src/stm32f1xx_hal_msp.c
    stmcubemx/src/stm32f1xx_it.c
    stmcubemx/src/system_stm32f1xx.c
    stmcubemx/startup_stm32f103xb.s
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal.c
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc.c
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio.c
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_cortex.c
)

if(CMAKE_BUILD_TYPE MATCHES "Debug")
    Message(STATUS "Building for: DEBUG")
    add_compile_definitions(ASSERT_HANDLING_ACTIVE)
    add_compile_definitions(IRQ_TRACKING_ENABLED)
    add_compile_definitions(USE_FULL_ASSERT)
    add_compile_definitions(DEBUG)
elseif(CMAKE_BUILD_TYPE MATCHES "Release")
    Message(STATUS "Building for: RELEASE")
elseif(CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
    Message(STATUS "Building for: MINSIZEREL")
elseif(CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
    Message(STATUS "Building for: RELWITHDEBINFO")
    add_compile_definitions(ASSERT_HANDLING_ACTIVE)
    add_compile_definitions(IRQ_TRACKING_ENABLED)
    add_compile_definitions(USE_FULL_ASSERT)
    add_compile_definitions(DEBUG)
else()
    Message(FATAL_ERROR "Building for: UNKNOWN - specify build type correctly!")
endif()

add_compile_definitions(USE_HAL_DRIVER)
add_compile_definitions(STM32F103xB)

set(LINKER_FILE ${CMAKE_SOURCE_DIR}/stmcubemx/STM32F103C8Tx_FLASH.ld)

add_executable(${PROJECT_NAME} ${sources} ${headers})
set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME ${PROJECT_NAME}.elf)
set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "-T \"${LINKER_FILE}\"")

set(ELF_FILE ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${PROJECT_NAME}.elf)
set(SREC_FILE ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${PROJECT_NAME}.srec)

# Generate S-record file from the GCC build artefact that appears to be ELF format.
# We need an S-record file which can be flashed in the target.
add_custom_command(
    TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${ELF_TOOL} ${ELF_TOOL_ARGUMENTS} ${ELF_FILE} ${SREC_FILE}
    COMMENT "Conversion from ELF format to Srecord format"
)

# Create ctags file
find_program(CTAGS_PATH ctags)
if(CTAGS_PATH)
    # Add "tags" target and make my_project depending on this target.
	set_source_files_properties(tags PROPERTIES GENERATED true)
	add_custom_target(tags
			COMMAND ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .
			WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
	add_dependencies(${PROJECT_NAME} tags)
endif(CTAGS_PATH)

