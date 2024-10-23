@echo on

set entt_build_testing=ON
if "%CONDA_BUILD_CROSS_COMPILATION%"=="1" (
  set entt_build_testing=OFF
)

cmake %SRC_DIR% ^
  -B build ^
  -DBUILD_SHARED_LIBS=OFF ^
  -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
  -DENTT_BUILD_LIB=ON ^
  -DENTT_BUILD_TESTING=%entt_build_testing% ^
  -DENTT_FIND_GTEST_PACKAGE=ON
if errorlevel 1 exit 1

cmake --build build --parallel --config Release
if errorlevel 1 exit 1

if "%CONDA_BUILD_CROSS_COMPILATION%"=="0" (
  ctest --test-dir build --output-on-failure --build-config Release -E delegate
  if errorlevel 1 exit 1
)

cmake --build build --parallel --config Release --target install
if errorlevel 1 exit 1
