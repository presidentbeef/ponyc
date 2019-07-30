cmake_minimum_required(VERSION 3.1 FATAL_ERROR)

file(STRINGS "../VERSION" VERSION_NUMBER)

project(ponyclibs VERSION ${VERSION_NUMBER} LANGUAGES C CXX)

include(ExternalProject)

if(NOT DEFINED PONYC_LIBS_BUILD_TYPE)
    set(PONYC_LIBS_BUILD_TYPE Release)
endif()

ExternalProject_Add(gbenchmark
    URL https://github.com/google/benchmark/archive/v1.5.0.tar.gz
    CMAKE_ARGS -DCMAKE_BUILD_TYPE=${PONYC_LIBS_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DBENCHMARK_ENABLE_GTEST_TESTS=OFF -DCMAKE_CXX_FLAGS=-fpic --no-warn-unused-cli
)

ExternalProject_Add(googletest
    URL https://github.com/google/googletest/archive/release-1.8.1.tar.gz
    CMAKE_ARGS -DCMAKE_BUILD_TYPE=${PONYC_LIBS_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_CXX_FLAGS=-fpic -Dgtest_force_shared_crt=ON --no-warn-unused-cli
)

add_library(blake2 STATIC
    blake2/blake2b-ref.c)
install(TARGETS blake2
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    COMPONENT library
)

find_package(Git)
if(GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/../.git")
# Update submodules as needed
    option(GIT_SUBMODULE "Check submodules during build" ON)
    if(GIT_SUBMODULE)
        message(STATUS "Updating submodules...")
        execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
                        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                        RESULT_VARIABLE GIT_SUBMOD_RESULT)
        if(NOT GIT_SUBMOD_RESULT EQUAL "0")
            message(FATAL_ERROR "git submodule update --init --recursive failed with ${GIT_SUBMOD_RESULT}, please checkout submodules")
        endif()
    endif()
endif()

add_subdirectory(llvm/src/llvm)
