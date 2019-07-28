config ?= release
arch ?= native
version ?= $(shell cat VERSION)

srcDir := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
buildDir := $(srcDir)/build/build_$(config)
outDir := $(srcDir)/build/$(config)

libsSrcDir := $(srcDir)/lib
libsBuildDir := $(srcDir)/build/build_libs
libsOutDir := $(srcDir)/build/libs

.PHONY: all libs cleanlibs configure build test clean

all: configure build

libs:
	mkdir -p $(libsBuildDir)
	cd $(libsBuildDir) && cmake -B $(libsBuildDir) -S $(libsSrcDir) -DCMAKE_INSTALL_PREFIX="$(libsOutDir)" -DCMAKE_BUILD_TYPE=Release
	cd $(libsBuildDir) && cmake --build $(libsBuildDir) --target install --config Release

cleanlibs:
	rm -rf $(libsBuildDir)
	rm -rf $(libsOutDir)

configure:
	mkdir -p $(buildDir)
	cd $(buildDir) && cmake -B $(buildDir) -S $(srcDir) -DCMAKE_BUILD_TYPE=$(config) -DCMAKE_C_FLAGS="-march=$(arch)" -DCMAKE_CXX_FLAGS="-march=$(arch)" -DPONYC_VERSION=$(version)

build:
	cd $(buildDir) && cmake --build $(buildDir) --config $(config) --target all

test:
	cd $(outDir) && ./libponyrt.tests
	cd $(outDir) && ./libponyc.tests

clean:
	([ -d $(buildDir) ] && cd $(buildDir) && cmake --build $(buildDir) --config $(config) --target clean) || true
	rm -rf $(buildDir)
	rm -rf $(outDir)

distclean:
	([ -d build ] && rm -rf build) || true
