Introduction
============

This is a project utilising the black pill board holding a **STM32F103C8T6** controller with 64K. The board shall be connected via an ST-Link V2, no external power required.
The build environment uses conda as package management for certain developent tools and is currently targeted for Windows OS.
It uses cmake and ninja to create the build environment and to build it.

The following programs are expected to be installed on your system: (links where to find these packages are provided in the folder 'links')

- Conda
- GCC for ARM
- STM32CubeMX
- STM32CubeProgrammer

The paths where the compiler and the target programmer are installed are passed via environment variables: *GCC_HOME_ARM* and *STM32CUBEPROG_PATH*
Examples for these:

+------------------------+-----------------------------------------------------------------------------------+
| Environment variable   | Value                                                                             |
+========================+===================================================================================+
| GCC_HOME_ARM           | C:\\Programs\\gcc-arm-none-eabi-10.3-2021.10-win32\\gcc-arm-none-eabi-10.3-2021.1 |
+------------------------+-----------------------------------------------------------------------------------+
| STM32CUBEPROG_PATH     | C:\\Program Files (x86)\\ST\\STM32CubeProgrammer\\bin                             |
+------------------------+-----------------------------------------------------------------------------------+


Hardware configuration
----------------------

Hardware configuration is done using STM32CubeMX. The configuration file is in the folder *stmcubemx*.
Open this file in STM32CubeMX and generate the code using the 'generate code' button. The generated code and the ST HAL routines are not part of this repository as they can be generated easily and are not subject to change in the scope of this project.


Prepare development environment
-------------------------------

Run conda and have it install all required tools:

.. code:: bash

    > start_environment.bat

Once the conda environment is created (first time you run it) you can start your development console using:

.. code:: bash

    > start quick.bat

This is a much quicker way but requires the conda environment to exist.


Create the build environment
----------------------------
Run one of these batch files:

1. build_target_debug.bat

2. build_target_release.bat


Debugging
---------

Debugging is done using good old gdb and openOCD. Make sure you've build the debug build first.
Then you launch openOCD and leave the window that appears open:

.. code:: bash

    > start_openocd.bat

Then you start GDB using this batch file:

.. code:: bash

    > start_debugger.bat

Serial debug output
-------------------

The project uses serial output over USB (using the micro USB port on the board) to output debug info.
For this to work you need to install a STM32 Virtual COM port driver, find the reference in the links.txt file.

