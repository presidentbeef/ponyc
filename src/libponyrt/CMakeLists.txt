project(libponyrt VERSION ${VERSION_NUMBER} LANGUAGES C CXX)

set(CMAKE_VERBOSE_MAKEFILE ON)

find_package(LLVM REQUIRED PATHS "../../build/libs/${CMAKE_BUILD_TYPE}/lib/cmake/llvm")

add_library(libponyrt STATIC
    actor/actor.c
    actor/messageq.c
    asio/asio.c
    asio/epoll.c
    asio/event.c
    asio/iocp.c
    asio/kqueue.c
    ds/fun.c
    ds/hash.c
    ds/list.c
    ds/stack.c
    gc/actormap.c
    gc/cycle.c
    gc/delta.c
    gc/gc.c
    gc/objectmap.c
    gc/serialise.c
    gc/trace.c
    lang/directory.c
    lang/io.c
    lang/lsda.c
    lang/paths.c
    lang/posix_except.c
    lang/process.c
    lang/socket.c
    lang/ssl.c
    lang/stat.c
    lang/stdfd.c
    lang/time.c
    lang/win_except.c
    mem/alloc.c
    mem/heap.c
    mem/pagemap.c
    mem/pool.c
    options/options.c
    platform/ponyassert.c
    platform/threads.c
    sched/cpu.c
    sched/mpmcq.c
    sched/mutemap.c
    sched/scheduler.c
    sched/start.c
)

target_compile_definitions(libponyrt
    PRIVATE LLVM_BUILD_MODE=${PONY_LLVM_BUILD_MODE}
    PRIVATE LLVM_VERSION="${LLVM_VERSION}"
    PRIVATE PONY_ALWAYS_ASSERT
    PRIVATE PONY_BUILD_CONFIG="${CMAKE_BUILD_TYPE}"
    PRIVATE PONY_USE_BIGINT
    PRIVATE PONY_VERSION="${VERSION_NUMBER}"
    PRIVATE PONY_VERSION_STR="${VERSION_NUMBER}-${GIT_REVISION} [${CMAKE_BUILD_TYPE}]\\ncompiled with: llvm ${LLVM_VERSION} -- ${CMAKE_C_COMPILER_ID}-${CMAKE_C_COMPILER_VERSION}-${CMAKE_C_COMPILER_ARCHITECTURE_ID}"
)

target_include_directories(libponyrt
    PRIVATE .
    PRIVATE ../common
)

add_custom_command(TARGET libponyrt PRE_LINK
    COMMAND ${CMAKE_BINARY_DIR}/../libs/${CMAKE_BUILD_TYPE}/bin/llc -filetype=obj -o ${libponyrt_BINARY_DIR}/libponyrt.dir/${CMAKE_BUILD_TYPE}/except_try_catch.o ${libponyrt_SOURCE_DIR}/lang/except_try_catch.ll
)

target_link_libraries(libponyrt
    ${libponyrt_BINARY_DIR}/libponyrt.dir/${CMAKE_BUILD_TYPE}/except_try_catch.o
)

if (MSVC)
    target_compile_definitions(libponyrt
        PUBLIC "_MBCS"
        PUBLIC "_CRT_SECURE_NO_WARNINGS"
    )

    file(GLOB_RECURSE CFILES "${PROJECT_SOURCE_DIR}/*.c")
    set_source_files_properties(${CFILES} PROPERTIES LANGUAGE CXX)
endif (MSVC)

# get_cmake_property(_variableNames VARIABLES)
# list (SORT _variableNames)
# foreach (_variableName ${_variableNames})
#     message(STATUS "${_variableName}=${${_variableName}}")
# endforeach()
