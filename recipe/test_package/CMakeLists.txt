cmake_minimum_required(VERSION 3.15)

project(entt_consumer LANGUAGES CXX)

find_package(EnTT CONFIG REQUIRED)

add_executable(entt_consumer test_package.cpp)
target_compile_features(entt_consumer PRIVATE cxx_std_17)
target_link_libraries(entt_consumer PRIVATE EnTT::EnTT)
