cmake_minimum_required(VERSION 3.0.0)

project(h7-project VERSION 0.1.0)
enable_language(C CXX ASM)

file(GLOB APP_SRC ${CMAKE_CURRENT_SOURCE_DIR}/app/*.c ${CMAKE_CURRENT_SOURCE_DIR}/app/*.cpp)
add_executable(${PROJECT_NAME} ${APP_SRC})
target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/app/)

set(STMLIB_PATH ${CMAKE_CURRENT_SOURCE_DIR}/libstm32h7)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/stmlib.cmake)
