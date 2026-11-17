# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

set(SNITCH_ABI ilp32d CACHE STRING "ABI for the target Snitch flavor. Default is ilp32d.")
set(SNITCH_ISA rv32imafd_xdma_xfrep_xssr CACHE STRING "ISA for the target Snitch flavor. Default is rv32imafd_xdma_xfrep_xssr.")
set(SNITCH_SIMULATOR rtl CACHE STRING "Simulator for the Snitch target (a directory under target/). Default is rtl.")
set(PICOLIBC_DIR "" CACHE PATH "Optional picolibc install, for toolchains without a C library.")

# dma.h passes "i" asm operands through inline functions, so the runtime cannot build at -O0
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type: Release (default), Debug (-Og), RelWithDebInfo or MinSizeRel." FORCE)
endif()

if(CMAKE_C_COMPILER_VERSION VERSION_LESS 18)
  message(WARNING "[SNITCH-SDK] Needs PULP LLVM 18.1, found ${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION}.")
endif()

# Set common compiler flags
set(COMMON_COMPILE_OPTIONS
  -march=${SNITCH_ISA}
  -mabi=${SNITCH_ABI}
  -mcpu=snitch
  -mcmodel=small
  -ffast-math
  -fno-builtin-printf
  -fno-common
  -mno-relax
  -fopenmp
  -ffunction-sections
  -Wextra
  -static
  $<$<CONFIG:Debug>:-Og>
)
if(PICOLIBC_DIR)
  list(APPEND COMMON_COMPILE_OPTIONS -isystem${PICOLIBC_DIR}/include)
endif()

message(STATUS "[SNITCH-SDK] CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
message(STATUS "[SNITCH-SDK] SNITCH_ABI: ${SNITCH_ABI}")
message(STATUS "[SNITCH-SDK] SNITCH_ISA: ${SNITCH_ISA}")
message(STATUS "[SNITCH-SDK] SNITCH_SIMULATOR: ${SNITCH_SIMULATOR}")
if(PICOLIBC_DIR)
  message(STATUS "[SNITCH-SDK] PICOLIBC_DIR: ${PICOLIBC_DIR}")
endif()
