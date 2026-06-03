# Chỉ định hệ điều hành mục tiêu là Generic (Embedded)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Ép buộc tìm kiếm trình biên dịch ARM GNU Toolchain [1]
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)

# Thiết lập chế độ tìm kiếm phần cứng mục tiêu (không tìm trên host Windows)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Ép CMake bỏ qua việc biên dịch thử chương trình test dạng thực thi (executable)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
