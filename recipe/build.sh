#!/bin/bash

set -euxo pipefail

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
  entt_build_testing=ON
else
  entt_build_testing=OFF
fi

# EnTT 4.0 requires C++20, so CMake (>=3.28) + Ninja + Clang enables C++20 module
# dependency scanning by default. That scan step shells out to clang-scan-deps,
# which the conda-forge clang toolchain does not expose to CMake on osx-64,
# failing with "CMAKE_CXX_COMPILER_CLANG_SCAN_DEPS-NOTFOUND: command not found".
# EnTT ships no C++20 module units, so scanning is unnecessary here; disable it.
cmake $SRC_DIR \
  ${CMAKE_ARGS} \
  -G Ninja \
  -B build \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_SCAN_FOR_MODULES=OFF \
  -DENTT_BUILD_TESTING=$entt_build_testing \
  -DENTT_FIND_GTEST_PACKAGE=ON \
  -DENTT_INSTALL=ON

cmake --build build --parallel

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
  ctest --test-dir build --output-on-failure
fi

cmake --build build --parallel --target install
