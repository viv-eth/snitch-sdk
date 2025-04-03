# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

file(GLOB RUNTIME_CORE_SOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.S"
)

add_library(snitch_runtime_core STATIC ${RUNTIME_CORE_SOURCES})

target_compile_options(snitch_runtime_core PUBLIC
    -march=${SNITCH_ISA}
    -mabi=${SNITCH_ABI}
    -mcpu=snitch
    -mcmodel=small
    -ffast-math
    -fno-builtin-printf
    -fno-common
    -mno-relax
    -Wno-atomic-alignment
    -fopenmp
    -ffunction-sections
    -Wextra
    -static
)

target_include_directories(snitch_runtime_core
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/inc
    ${CMAKE_CURRENT_SOURCE_DIR}/../omp/inc
    ${CMAKE_CURRENT_SOURCE_DIR}/../../sw/deps/
)