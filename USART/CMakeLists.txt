cmake_minimum_required(VERSION 3.16)
project(stm32_cmake_project LANGUAGES C ASM) 

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# 1. Định nghĩa cờ MCU (Thay đổi theo chip của bạn, ví dụ này là Cortex-M4)
set(MCU_FLAGS "-mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")

# 2. Cấu hình Cờ Biên Dịch chung cho STM32
set(CMAKE_C_FLAGS "${MCU_FLAGS} -Wall -Wextra -ffunction-sections -fdata-sections -O2")
set(CMAKE_EXE_LINKER_FLAGS "${MCU_FLAGS} -specs=nano.specs -T${CMAKE_SOURCE_DIR}/STM32F411VETX_FLASH.ld -Wl,--gc-sections -Wl,-Map=${CMAKE_SOURCE_DIR}/output/${PROJECT_NAME}.map")

# 3. Gom tất cả các file nguồn (.c và .s)
file(GLOB_RECURSE SOURCES
    "Src/*.c"
    "Startup/*.s" # File startup của chip
    "Drivers/STM32F4xx_HAL_Driver/Src/*.c"
)

# 4. Khai báo các thư mục chứa file Header (.h)
include_directories(Inc)

# 5. Các Macro Define phần cứng toàn cục (Giống như khi khai báo trong Keil C hoặc Makefile)
add_compile_definitions(USE_HAL_DRIVER STM32F407xx)

# 6. Tạo Target Biên dịch đầu ra (.elf)
add_executable(${PROJECT_NAME}.elf ${SOURCES})

# 7. Tự động xuất file nạp mạch .hex và .bin sau khi build xong (.elf)
# Sử dụng $<TARGET_FILE:...> để CMake tự động lấy chính xác đường dẫn của file .elf dù nó nằm ở đâu
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND arm-none-eabi-objcopy -O ihex $<TARGET_FILE:${PROJECT_NAME}.elf> $<TARGET_FILE_DIR:${PROJECT_NAME}.elf>/${PROJECT_NAME}.hex
    COMMAND arm-none-eabi-objcopy -O binary $<TARGET_FILE:${PROJECT_NAME}.elf> $<TARGET_FILE_DIR:${PROJECT_NAME}.elf>/${PROJECT_NAME}.bin
    COMMAND arm-none-eabi-size $<TARGET_FILE:${PROJECT_NAME}.elf>
    COMMENT "Generating Hex and Bin..."
)

# 8. Đẩy toàn bộ sản phẩm ra thư mục output ngoài gốc
set_target_properties(${PROJECT_NAME}.elf PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/../output"
)
