cmake_minimum_required(VERSION 3.16)
project(stm32_cmake_project LANGUAGES C ASM) # Hỗ trợ cả C và mã Assembly (.s)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# 1. Định nghĩa cờ MCU (Thay đổi theo chip của bạn, ví dụ này là Cortex-M4)
set(MCU_FLAGS "-mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")

# 2. Cấu hình Cờ Biên Dịch chung cho STM32
set(CMAKE_C_FLAGS "${MCU_FLAGS} -Wall -Wextra -ffunction-sections -fdata-sections -O2")
set(CMAKE_EXE_LINKER_FLAGS "${MCU_FLAGS} -specs=nano.specs -T\${CMAKE_SOURCE_DIR}/STM32F407VGTX_FLASH.ld -Wl,--gc-sections -Wl,-Map=\${CMAKE_BINARY_DIR}/output.map")

# 3. Gom tất cả các file nguồn (.c và .s)
file(GLOB_RECURSE SOURCES
    "Core/Src/*.c"
    "Core/Startup/*.s" # File startup của chip
    "Drivers/STM32F4xx_HAL_Driver/Src/*.c"
)

# 4. Khai báo các thư mục chứa file Header (.h)
include_directories(
    Core/Inc
    Drivers/STM32F4xx_HAL_Driver/Inc
    Drivers/STM32F4xx_HAL_Driver/Inc/Legacy
    Drivers/CMSIS/Device/ST/STM32F4xx/Include
    Drivers/CMSIS/Include
)

# 5. Các Macro Define phần cứng toàn cục (Giống như khi khai báo trong Keil C hoặc Makefile)
add_compile_definitions(USE_HAL_DRIVER STM32F407xx)

# 6. Tạo Target Biên dịch đầu ra (.elf)
add_executable(${PROJECT_NAME}.elf ${SOURCES})

# 7. Tự động xuất file .hex và .bin sau khi build xong (.elf) để nạp mạch
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND arm-none-eabi-objcopy -O ihex ${PROJECT_NAME}.elf ${PROJECT_NAME}.hex
    COMMAND arm-none-eabi-objcopy -O binary ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin
    COMMAND arm-none-eabi-size ${PROJECT_NAME}.elf
    COMMENT "Generating .hex and .bin files..."
)

# 8. Đẩy toàn bộ sản phẩm ra thư mục output ngoài gốc
set_target_properties(${PROJECT_NAME}.elf PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/../output"
)
