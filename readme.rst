Introduction
============

This is a project utilising the black pill board holding a STM32F103C8T6 controller with 64K. The board shall be connected via an ST-Link V2, no external power required.
The build environment uses conda as package management for certain developent tools and is currently targeted for Windows OS.
It uses cmake and ninja to create the build environment and to build it.

GCC for ARM and ST Cube programmer are expected to be installed on your system. The paths where these are installed are passed via environment variables: *GCC_HOME_ARM* and *STM32CUBEPROG_PATH*
Examples for these:

+------------------------+--------------------------------------------------------------------------------+
| Environment variable   | Value                                                                          |
+========================+================================================================================+
| GCC_HOME_ARM           | C:\Programs\gcc-arm-none-eabi-10.3-2021.10-win32\gcc-arm-none-eabi-10.3-2021.1 |
+------------------------+--------------------------------------------------------------------------------+
| STM32CUBEPROG_PATH     | C:\Program Files (x86)\ST\STM32CubeProgrammer\bin                              |
+------------------------+--------------------------------------------------------------------------------+


Prepare development environment
-------------------------------

Run conda and have it install all required tools:

.. code:: bash

    $ start_environment.bat

Once the conda environment is created (first time you run it) you can start your development console using:

.. code:: bash

    $ start quick.bat

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

    $ start_openocd.bat

Then you start GDB using this batch file:

.. code:: bash

    $ start_debugger.bat

