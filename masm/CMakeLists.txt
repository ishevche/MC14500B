cmake_minimum_required(VERSION 3.16)
project(MASM)

set(CMAKE_CXX_STANDARD 17)

include(FetchContent)
FetchContent_Declare(
        argparse
        GIT_REPOSITORY https://github.com/p-ranav/argparse.git
)
FetchContent_MakeAvailable(argparse)

add_executable(MASM masm.cpp logger.cpp logger.h assembler.cpp assembler.h)
target_link_libraries(MASM argparse)