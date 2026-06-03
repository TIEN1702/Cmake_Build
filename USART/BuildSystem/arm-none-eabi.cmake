# Target operating system configuration for bare-metal embedded environment
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Force the usage of the ARM GNU Toolchain compilers
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)

# Configure search paths to look within the target toolchain, not the Windows host
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Force CMake to skip compiling a full executable test program by checking static libraries instead
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
