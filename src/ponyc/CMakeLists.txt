project(ponyc VERSION ${VERSION_NUMBER} LANGUAGES C CXX)

add_executable(ponyc main.c)

target_include_directories(ponyc
    PRIVATE ../../src/common
    PRIVATE ../../src/libponyc
    PRIVATE ../../build/libs/include
)

llvm_config(ponyc all)

target_link_directories(ponyc
    PRIVATE ../../build/libs/lib
)

target_link_libraries(ponyc
    PRIVATE libponyc
    PRIVATE libponyrt
    PRIVATE blake2
)

if (MSVC)
    target_link_libraries(ponyc
        PRIVATE dbghelp
        PRIVATE ucrt
        PRIVATE Ws2_32
        PRIVATE Shlwapi
    )

    get_target_property(TARGET_LIBRARIES ponyc LINK_LIBRARIES)
    LIST(REMOVE_ITEM TARGET_LIBRARIES LTO)
    set_property(TARGET ponyc PROPERTY LINK_LIBRARIES ${TARGET_LIBRARIES})
    set_property(TARGET ponyc PROPERTY LINK_OPTIONS "/WHOLEARCHIVE:libponyrt.lib")

    set_source_files_properties(main.c PROPERTIES LANGUAGE CXX)

    add_custom_command(TARGET ponyc POST_BUILD
        COMMAND $<$<CONFIG:Debug>:${CMAKE_COMMAND}> ARGS -E copy ${libponyrt_BINARY_DIR}/debug/libponyrt.lib ${CMAKE_BINARY_DIR}/debug/libponyrt.lib
        COMMAND $<$<CONFIG:Release>:${CMAKE_COMMAND}> ARGS -E copy ${libponyrt_BINARY_DIR}/release/libponyrt.lib ${CMAKE_BINARY_DIR}/release/libponyrt.lib
        COMMAND $<$<CONFIG:RelWithDebInfo>:${CMAKE_COMMAND}> ARGS -E copy ${libponyrt_BINARY_DIR}/relwithdebinfo/libponyrt.lib ${CMAKE_BINARY_DIR}/relwithdebinfo/libponyrt.lib
        COMMAND $<$<CONFIG:MinSizeRel>:${CMAKE_COMMAND}> ARGS -E copy ${libponyrt_BINARY_DIR}/minsizerel/libponyrt.lib ${CMAKE_BINARY_DIR}/minsizerel/libponyrt.lib
    )
endif (MSVC)
