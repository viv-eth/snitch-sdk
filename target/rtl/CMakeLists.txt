# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

file(GLOB RUNTIME_TARGET_SOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.S"
)

add_library(snitch_runtime_target STATIC ${RUNTIME_TARGET_SOURCES})

target_compile_options(snitch_runtime_target 
    PUBLIC
        ${COMMON_COMPILE_OPTIONS}
)

target_include_directories(snitch_runtime_target
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/inc
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/../../core/src
    ${CMAKE_CURRENT_SOURCE_DIR}/../../omp/src
)

target_link_libraries(snitch_runtime_target
  PUBLIC
    snitch_runtime_core
)