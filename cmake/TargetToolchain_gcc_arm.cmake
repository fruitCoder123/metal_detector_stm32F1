
# Works with cmake version 3.12.3

cmake_policy(SET CMP0011 NEW)
cmake_policy(SET CMP0005 NEW)

IF(NOT DEFINED ENV{GCC_HOME_ARM})
    MESSAGE(FATAL_ERROR "Mandatory environment variable GCC_HOME_ARM not defined")
else()
    # Convert environment var to local var in cmake format
    file(TO_CMAKE_PATH "$ENV{GCC_HOME_ARM}" GCC_HOME_ARM)
ENDIF()

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(GCC-PREFIX "arm-none-eabi")

find_program (CMAKE_C_COMPILER "bin/${GCC-PREFIX}-gcc.exe" HINTS ${GCC_HOME_ARM})
find_program (CMAKE_CXX_COMPILER "bin/${GCC-PREFIX}-g++.exe" HINTS ${GCC_HOME_ARM})
find_program (ELF_TOOL "bin/${GCC-PREFIX}-objcopy.exe" HINTS ${GCC_HOME_ARM})

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

SET(C_CXX_FLAGS_INIT
  "-fno-common"         # controls the placement of global variables defined without an initializer
  "-ffreestanding"      # generate code assuming no operating system
  "-ffunction-sections" # Place each function item into its own section in the output file
  "-fdata-sections"     # Place each data item into its own section in the output file
  "-Wall"               # enables all the warnings about constructions that some users consider questionable
  "-mcpu=cortex-m3"     # Specify the name of the target processor
  "-mthumb"             # Select generating code that executes in Thumb states
  "-fno-exceptions"
  "-Wl,-Map=mapfile.map"
#  "-nostdlib"
)
string( REPLACE ";" " " C_CXX_FLAGS_INIT "${C_CXX_FLAGS_INIT}" )

SET(C_FLAGS_DEBUG
  "--debug"
  "-DDEBUG"
  "-O0"
  "-g"
)
string( REPLACE ";" " " C_FLAGS_DEBUG "${C_FLAGS_DEBUG}" )

SET(CXX_FLAGS_DEBUG
  "--debug"
  "-DDEBUG"
  "-O0"
  "-g"
  "-std=c++11"
)
string( REPLACE ";" " " CXX_FLAGS_DEBUG "${CXX_FLAGS_DEBUG}" )

SET(LINK_FLAGS
  "-specs=nosys.specs"
#  "-specs=nano.specs"
  "-mfloat-abi=softfp"
)
string( REPLACE ";" " " LINK_FLAGS "${LINK_FLAGS}" )

SET(CMAKE_ASM_FLAGS_INIT "-g")
SET(CMAKE_C_FLAGS_INIT            ${C_CXX_FLAGS_INIT})
SET(CMAKE_CXX_FLAGS_INIT          ${C_CXX_FLAGS_INIT})

SET(CMAKE_C_FLAGS_DEBUG_INIT      ${C_FLAGS_DEBUG})
SET(CMAKE_CXX_FLAGS_DEBUG_INIT    ${CXX_FLAGS_DEBUG})

SET(CMAKE_C_FLAGS_RELEASE_INIT    "-O3 -s" CACHE INTERNAL "c compiler flags release")
SET(CMAKE_CXX_FLAGS_RELEASE_INIT  "-O3 -s -std=c++11" CACHE INTERNAL "cxx compiler flags release")

SET(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT "--debug -DDEBUG -D NDEBUG")
SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT "--debug -DDEBUG -D NDEBUG")

SET(CMAKE_C_FLAGS_MINSIZEREL_INIT "--lock_regs 0 -Ohz -D NDEBUG")
SET(CMAKE_CXX_FLAGS_MINSIZEREL_INIT "--lock_regs 0 -Ohz  -D NDEBUG")

SET(CMAKE_EXE_LINKER_FLAGS    ${LINK_FLAGS})

SET(ELF_TOOL_ARGUMENTS -S -O srec CACHE STRING "Prefix for the ELF tool")

