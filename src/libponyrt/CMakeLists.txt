project(libponyrt VERSION ${VERSION_NUMBER} LANGUAGES C CXX)

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

target_include_directories(libponyrt
    PRIVATE .
    PRIVATE ../common
)

set(_ll_src "${libponyrt_SOURCE_DIR}/lang/except_try_catch.ll")
set(_ll_obj "${libponyrt_BINARY_DIR}/libponyrt.dir/except_try_catch.o")

add_custom_command(TARGET libponyrt PRE_LINK
    COMMAND "../../libs/bin/llc" -filetype=obj -o ${_ll_obj} ${_ll_src}
    WORKING_DIRECTORY ${libponyrt_BINARY_DIR}
    BYPRODUCTS ${_ll_obj}
)

target_link_libraries(libponyrt
    PRIVATE ${_ll_obj}
)

if (MSVC)
    file(GLOB_RECURSE CFILES "${PROJECT_SOURCE_DIR}/*.c")
    set_source_files_properties(${CFILES} PROPERTIES LANGUAGE CXX)
endif (MSVC)
