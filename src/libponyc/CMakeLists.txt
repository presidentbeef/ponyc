project(libponyc VERSION ${VERSION_NUMBER} LANGUAGES C CXX)

set(CMAKE_VERBOSE_MAKEFILE ON)

find_package(LLVM REQUIRED PATHS "../../build/libs/${CMAKE_BUILD_TYPE}/lib/cmake/llvm")

add_library(libponyc STATIC
    ponyc.c
    ast/ast.c
    ast/bnfprint.c
    ast/error.c
    ast/frame.c
    ast/id.c
    ast/lexer.c
    ast/lexint.c
    ast/parser.c
    ast/parserapi.c
    ast/printbuf.c
    ast/source.c
    ast/stringtab.c
    ast/symtab.c
    ast/token.c
    ast/treecheck.c
    codegen/codegen.c
    codegen/genbox.c
    codegen/gencall.c
    codegen/gencontrol.c
    codegen/gendesc.c
    codegen/genexe.c
    codegen/genexpr.c
    codegen/genfun.c
    codegen/genheader.c
    codegen/genident.c
    codegen/genlib.c
    codegen/genmatch.c
    codegen/genname.c
    codegen/genobj.c
    codegen/genoperator.c
    codegen/genprim.c
    codegen/genreference.c
    codegen/genserialise.c
    codegen/gentrace.c
    codegen/gentype.c
    codegen/gendebug.cc
    codegen/genjit.cc
    codegen/genopt.cc
    codegen/host.cc
    expr/array.c
    expr/call.c
    expr/control.c
    expr/ffi.c
    expr/lambda.c
    expr/literal.c
    expr/match.c
    expr/operator.c
    expr/postfix.c
    expr/reference.c
    options/options.c
    pass/docgen.c
    pass/expr.c
    pass/finalisers.c
    pass/flatten.c
    pass/import.c
    pass/names.c
    pass/pass.c
    pass/refer.c
    pass/scope.c
    pass/serialisers.c
    pass/sugar.c
    pass/syntax.c
    pass/traits.c
    pass/verify.c
    pkg/buildflagset.c
    pkg/ifdef.c
    pkg/package.c
    pkg/platformfuns.c
    pkg/program.c
    pkg/use.c
    platform/paths.c
    platform/vcvars.c
    plugin/plugin.c
    reach/paint.c
    reach/reach.c
    reach/subtype.c
    type/alias.c
    type/assemble.c
    type/cap.c
    type/compattype.c
    type/lookup.c
    type/matchtype.c
    type/reify.c
    type/safeto.c
    type/sanitise.c
    type/subtype.c
    type/typeparam.c
    type/viewpoint.c
    verify/call.c
    verify/control.c
    verify/fun.c
    verify/type.c
)

target_include_directories(libponyc
    PUBLIC ../common
    PRIVATE ${LLVM_BINARY_DIR}/include
    PRIVATE ${LLVM_SOURCE_DIR}/include
    PRIVATE ../../lib/blake2
  )

llvm_config(libponyc core executionengine orcjit support x86codegen x86info x86desc)

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

target_compile_definitions(libponyc
    PUBLIC LLVM_BUILD_MODE=${PONY_LLVM_BUILD_MODE}
    PUBLIC LLVM_VERSION="${LLVM_VERSION}"
    PUBLIC PONY_ALWAYS_ASSERT
    PUBLIC PONY_BUILD_CONFIG="${CMAKE_BUILD_TYPE}"
    PUBLIC PONY_USE_BIGINT
    PUBLIC PONY_VERSION="${VERSION_NUMBER}"
    PUBLIC PONY_VERSION_STR="${VERSION_NUMBER}-${GIT_REVISION} [${CMAKE_BUILD_TYPE}]\\ncompiled with: llvm ${LLVM_VERSION} -- ${CMAKE_C_COMPILER_ID}-${CMAKE_C_COMPILER_VERSION}-${CMAKE_C_COMPILER_ARCHITECTURE_ID}"
)

if (MSVC)
    target_compile_definitions(libponyc
        PUBLIC "_MBCS"
        PUBLIC "_CRT_SECURE_NO_WARNINGS"
    )

    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd4142 /wd4996")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4142 /wd4996")
    file(GLOB_RECURSE CFILES "${PROJECT_SOURCE_DIR}/*.c")
    set_source_files_properties(${CFILES} PROPERTIES LANGUAGE CXX)
endif (MSVC)

get_cmake_property(_variableNames VARIABLES)
list (SORT _variableNames)
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()
