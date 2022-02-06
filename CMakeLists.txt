
cmake_minimum_required(VERSION 3.0)

project(metal_detector_${CMAKE_BUILD_TYPE} C ASM)

include_directories(software/headers)

# set output folder to put the build output
set(EXE_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE})

include_directories(stmcubemx/inc)
include_directories(stmcubemx/Drivers/CMSIS/Device/ST/STM32F1xx/Include)
include_directories(stmcubemx/Drivers/CMSIS/Include)
include_directories(stmcubemx/Drivers/STM32F1xx_HAL_Driver/Inc)
include_directories(stmcubemx/Middlewares/ST/STM32_USB_Device_Library/Core/Inc)
include_directories(stmcubemx/Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc)

set (headers
    stmcubemx/inc/main.h
    stmcubemx/inc/stm32f1xx_hal_conf.h
    stmcubemx/inc/stm32f1xx_it.h

    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Inc/stm32f1xx_hal.h
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Inc/stm32f1xx_hal_rcc.h
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Inc/stm32f1xx_hal_rcc_ex.h
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Inc/stm32f1xx_hal_gpio.h
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Inc/stm32f1xx_hal_cortex.h
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Inc/stm32f1xx_hal_pcd.h
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Inc/stm32f1xx_hal_pcd_ex.h
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Inc/stm32f1xx_ll_usb.h

    stmcubemx/inc/usb_device.h
    stmcubemx/inc/usbd_cdc_if.h
    stmcubemx/inc/usbd_conf.h
    stmcubemx/inc/usbd_desc.h

    stmcubemx/Middlewares/ST/STM32_USB_Device_Library/Core/Inc/usbd_core.h
    stmcubemx/Middlewares/ST/STM32_USB_Device_Library/Core/Inc/usbd_ctlreq.h
    stmcubemx/Middlewares/ST/STM32_USB_Device_Library/Core/Inc/usbd_ioreq.h
    stmcubemx/Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc/usbd_cdc.h
)

set (sources
    software/sources/main.c

    stmcubemx/src/stm32f1xx_hal_msp.c
    stmcubemx/src/stm32f1xx_it.c
    stmcubemx/src/system_stm32f1xx.c
    stmcubemx/startup_stm32f103xb.s

    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal.c
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc.c
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc_ex.c
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio.c
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_cortex.c
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pcd.c
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pcd_ex.c
    stmcubemx/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_usb.c

    stmcubemx/src/usb_device.c
    stmcubemx/src/usbd_cdc_if.c
    stmcubemx/src/usbd_conf.c
    stmcubemx/src/usbd_desc.c

    stmcubemx/Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_core.c
    stmcubemx/Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ctlreq.c
    stmcubemx/Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ioreq.c
    stmcubemx/Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Src/usbd_cdc.c
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

set(ELF_FILE ${PROJECT_NAME}.elf)
set(SREC_FILE ${PROJECT_NAME}.srec)

# Generate S-record file from the GCC build artefact that appears to be ELF format.
# We need an S-record file which can be flashed in the target.
add_custom_command(
    TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${ELF_TOOL} ${ELF_TOOL_ARGUMENTS} ${PROJECT_BINARY_DIR}/${ELF_FILE} ${PROJECT_BINARY_DIR}/${SREC_FILE}
    COMMENT "Conversion from ELF format to Srecord format"
)

# Copy the build result to the bin folder for loading convinience
add_custom_command(
    TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_BINARY_DIR}/${SREC_FILE} ${EXE_OUTPUT_DIRECTORY}/${SREC_FILE}
    COMMENT "Copy build result (S-record file) to bin folder"
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

