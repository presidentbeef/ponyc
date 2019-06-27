cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

file(STRINGS "VERSION" VERSION_NUMBER)
execute_process(
    COMMAND git rev-parse --short HEAD
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_REVISION
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

project(Pony VERSION ${VERSION_NUMBER} LANGUAGES C CXX)

add_subdirectory(src/libponyc)
# add_subdirectory(src/libponyrt)
# add_subdirectory(src/ponyc)

# add_subdirectory(test/libponyc)
# add_subdirectory(test/libponyrt)

# add_subdirectory(benchmark/libponyc)
# add_subdirectory(benchmark/libponyrt)
