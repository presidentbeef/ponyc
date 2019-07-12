project(libponyrt.tests VERSION ${VERSION_NUMBER} LANGUAGES C CXX)

add_executable(libponyrt.tests
    util.cc
    ds/fun.cc
    ds/hash.cc
    ds/list.cc
    lang/error.cc
    mem/heap.cc
    mem/pagemap.cc
    mem/pool.cc
)

target_compile_definitions(libponyrt.tests
    PRIVATE LLVM_BUILD_MODE=${PONY_LLVM_BUILD_MODE}
    PRIVATE LLVM_VERSION="${LLVM_VERSION}"
    PRIVATE PONY_ALWAYS_ASSERT
    PRIVATE PONY_BUILD_CONFIG="${CMAKE_BUILD_TYPE}"
    PRIVATE PONY_USE_BIGINT
    PRIVATE PONY_VERSION="${VERSION_NUMBER}"
    PRIVATE PONY_VERSION_STR="${VERSION_NUMBER}-${GIT_REVISION} [${CMAKE_BUILD_TYPE}]\\ncompiled with: llvm ${LLVM_VERSION} -- ${CMAKE_C_COMPILER_ID}-${CMAKE_C_COMPILER_VERSION}-${CMAKE_C_COMPILER_ARCHITECTURE_ID}"
)

target_include_directories(libponyrt.tests
    PRIVATE ../../src/common
    PRIVATE ../../src/libponyrt
    PRIVATE ../../build/libs/${CMAKE_BUILD_TYPE}/include
)

target_link_directories(libponyrt.tests
    PRIVATE ../../build/libs/${CMAKE_BUILD_TYPE}/lib
)

target_link_libraries(libponyrt.tests
    libponyrt
    GTest
)

if (MSVC)
    target_compile_definitions(libponyrt
        PUBLIC "_MBCS"
        PUBLIC "_CRT_SECURE_NO_WARNINGS"
    )

    target_link_libraries(libponyrt.tests dbghelp)
endif (MSVC)

get_cmake_property(_variableNames VARIABLES)
list (SORT _variableNames)
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()
