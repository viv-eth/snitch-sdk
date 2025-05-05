# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

file(GLOB RUNTIME_CORE_SOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c"
)

add_library(snitch_runtime_core STATIC ${RUNTIME_CORE_SOURCES})

target_compile_options(snitch_runtime_core 
  PUBLIC
    ${COMMON_COMPILE_OPTIONS}
)

target_include_directories(snitch_runtime_core
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/inc
)

target_link_libraries(snitch_runtime_core
  PUBLIC
  snitch_common_inc
)