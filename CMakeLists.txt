cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

file(STRINGS "VERSION" VERSION_NUMBER)
execute_process(
    COMMAND git rev-parse --short HEAD
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_REVISION
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

project(Pony VERSION ${VERSION_NUMBER} LANGUAGES C CXX)

set(CMAKE_VERBOSE_MAKEFILE ON)

find_package(LLVM REQUIRED CONFIG HINTS "build/libs/${CMAKE_BUILD_TYPE}/lib/cmake/llvm" NO_DEFAULT_PATH)
find_package(GTest REQUIRED CONFIG HINTS "build/libs/${CMAKE_BUILD_TYPE}/lib/cmake/GTest" NO_DEFAULT_PATH)

if (CMAKE_BUILD_TYPE STREQUAL "Release")
    set(PONY_LLVM_BUILD_MODE "1")
elseif(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
    set(PONY_LLVM_BUILD_MODE "2")
elseif(CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
    set(PONY_LLVM_BUILD_MODE "3")
elseif(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(PONY_LLVM_BUILD_MODE "4")
else()
    set(PONY_LLVM_BUILD_MODE "?")
endif()

if (MSVC)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd4142 /wd4996")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4142 /wd4996")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /MT")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /MTd")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd")
endif (MSVC)

add_subdirectory(src/libponyc)
add_subdirectory(src/libponyrt)
# add_subdirectory(src/ponyc)

# add_subdirectory(test/libponyc)
add_subdirectory(test/libponyrt)

# add_subdirectory(benchmark/libponyc)
# add_subdirectory(benchmark/libponyrt)
