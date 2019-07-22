project (libponyc.benchmarks VERSION ${VERSION_NUMBER} LANGUAGES CXX)

add_executable(libponyc.benchmarks
    gbenchmark_main.cc
    common/common.cc
)

target_include_directories(libponyc.benchmarks
    PRIVATE ../../src/common
    PRIVATE ../../src/libponyc
    PRIVATE ../../build/libs/include
)

llvm_config(libponyc.benchmarks all)

target_link_directories(libponyc.benchmarks
    PRIVATE ../../build/libs/lib
)

target_link_libraries(libponyc.benchmarks
    PRIVATE libponyc
    PRIVATE libponyrt
    PRIVATE blake2
    PRIVATE benchmark::benchmark
)

if (MSVC)
    target_link_libraries(libponyc.benchmarks
        PRIVATE dbghelp
        PRIVATE ucrt
        PRIVATE Ws2_32
        PRIVATE Shlwapi
    )

    get_target_property(TARGET_LIBRARIES libponyc.benchmarks LINK_LIBRARIES)
    LIST(REMOVE_ITEM TARGET_LIBRARIES LTO)
    set_property(TARGET libponyc.benchmarks PROPERTY LINK_LIBRARIES ${TARGET_LIBRARIES})
    set_property(TARGET libponyc.benchmarks PROPERTY LINK_OPTIONS "/WHOLEARCHIVE:libponyrt.lib")
endif (MSVC)
