project(libponyrt.benchmarks VERSION ${VERSION_NUMBER} LANGUAGES CXX)

add_executable(libponyrt.benchmarks
    gbenchmark_main.cc
    common/common.cc
    ds/hash.cc
    mem/heap.cc
    mem/pool.cc
)

target_include_directories(libponyrt.benchmarks
    PRIVATE ../../src/common
    PRIVATE ../../src/libponyrt
    PRIVATE ../../build/libs/include
)

target_link_libraries(libponyrt.benchmarks
    PRIVATE libponyrt
    PRIVATE benchmark::benchmark
)

if (MSVC)
    target_link_libraries(libponyrt.benchmarks PRIVATE dbghelp)
endif (MSVC)
