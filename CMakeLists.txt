cmake_minimum_required(VERSION 3.0.0)

project(h7-project VERSION 0.1.0)
enable_language(C CXX ASM)

file(GLOB APP_CSRC ${CMAKE_CURRENT_SOURCE_DIR}/app/*.c)
file(GLOB APP_CXXSRC ${CMAKE_CURRENT_SOURCE_DIR}/app/*.cpp)
file(GLOB APP_H ${CMAKE_CURRENT_SOURCE_DIR}/app/*.h)
add_executable(${PROJECT_NAME} ${APP_CXXSRC} ${APP_CSRC} ${APP_H})
target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/app/)

set(STMLIB_PATH ${CMAKE_CURRENT_SOURCE_DIR}/libstm32h7)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/stmlib.cmake)
