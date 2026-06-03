cmake_minimum_required(VERSION 3.16)
project(stm32_cmake_project LANGUAGES C ASM) 

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# 1. Define MCU hardware flags (Target Architecture: Cortex-M4)
set(MCU_FLAGS "-mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")

# 2. Configure global Compiler and Linker flags for STM32
set(CMAKE_C_FLAGS "${MCU_FLAGS} -Wall -Wextra -ffunction-sections -fdata-sections -O2")
set(CMAKE_EXE_LINKER_FLAGS "${MCU_FLAGS} -specs=nano.specs -T${CMAKE_SOURCE_DIR}/STM32F411VETX_FLASH.ld -Wl,--gc-sections -Wl,-Map=${CMAKE_SOURCE_DIR}/output/${PROJECT_NAME}.map")

# 3. Recursively gather all source files (.c and .s)
file(GLOB_RECURSE SOURCES
    "Src/*.c"
    "Startup/*.s" # MCU startup files
    "Drivers/STM32F4xx_HAL_Driver/Src/*.c"
)

# 4. Declare directory paths containing header files (.h)
include_directories(Inc)

# 5. Define global hardware preprocessor macros (Equivalent to Keil C or Makefile symbols)
add_compile_definitions(USE_HAL_DRIVER STM32F407xx)

# 6. Create the main target executable compilation (.elf)
add_executable(${PROJECT_NAME}.elf ${SOURCES})

# 7. Post-build commands to automatically generate target binary files (.hex and .bin)
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND arm-none-eabi-objcopy -O ihex $<TARGET_FILE:${PROJECT_NAME}.elf> $<TARGET_FILE_DIR:${PROJECT_NAME}.elf>/${PROJECT_NAME}.hex
    COMMAND arm-none-eabi-objcopy -O binary $<TARGET_FILE:${PROJECT_NAME}.elf> $<TARGET_FILE_DIR:${PROJECT_NAME}.elf>/${PROJECT_NAME}.bin
    # Display the memory footprint inside the exact target directory using filename only
    COMMAND arm-none-eabi-size $<TARGET_FILE_NAME:${PROJECT_NAME}.elf>
    WORKING_DIRECTORY $<TARGET_FILE_DIR:${PROJECT_NAME}.elf>
    COMMENT "Generating output files..."
)

# 8. Redirect all compilation output binaries to the root 'output' folder
set_target_properties(${PROJECT_NAME}.elf PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/../output"
)
