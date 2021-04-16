cmake_minimum_required(VERSION 3.0.0)

project(hello_world VERSION 0.1.0 LANGUAGES C CXX ASM)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/stmlib.cmake)
create_app_from_project(${CMAKE_CURRENT_SOURCE_DIR}/libstm32h7)
