config ?= release

srcDir = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
buildDir = $(srcDir)/build/build_$(config)
outDir = $(srcDir)/build/$(config)

libsSrcDir = $(srcDir)/lib
libsBuildDir = $(srcDir)/build/build_libs
libsDir = $(srcDir)/build/libs

libs:
	mkdir -p $(libsBuildDir)
	cd $(libsBuildDir) && cmake -B $(libsBuildDir) -S $(libsSrcDir) -DCMAKE_INSTALL_PREFIX="$(libsDir)" -DCMAKE_BUILD_TYPE=$(config)
	cd $(libsBuildDir) && cmake --build $(libsBuildDir) --target install --config $(config)
