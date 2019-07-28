project(libponyrt.tests VERSION ${PONYC_VERSION} LANGUAGES C CXX)

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

target_include_directories(libponyrt.tests
    PRIVATE ../../src/common
    PRIVATE ../../src/libponyrt
    PRIVATE ../../build/libs/include
)

target_link_libraries(libponyrt.tests
    PRIVATE libponyrt
    PRIVATE GTest::gtest
)

if (MSVC)
    target_link_libraries(libponyrt.tests PRIVATE dbghelp)
else()
    target_link_libraries(libponyrt.tests PRIVATE atomic dl)
endif (MSVC)
