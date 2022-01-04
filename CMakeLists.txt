
cmake_minimum_required(VERSION 3.0)

project(metal_detector_${CMAKE_BUILD_TYPE} C)

add_definitions(-DSTM32F103)

include_directories(software/headers)

# set output folder to put the build output
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../../../bin/${CMAKE_BUILD_TYPE})


set (headers
)

set (sources
    software/sources/main.c
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

add_executable(${PROJECT_NAME} ${sources} ${headers})
set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME ${PROJECT_NAME}.hex)

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

