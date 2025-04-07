# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

set(SNITCH_ABI ilp32d CACHE STRING "ABI for the target Snitch flavor. Default is ilp32d.")
set(SNITCH_ISA rv32imafd_xdma1 CACHE STRING "ISA for the target Snitch flavor. Default is rv32imafd.")
set(SNITCH_SIMULATOR rtl CACHE STRING "Simulator for the Snitch target. Default is rtl.")

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
)

message(STATUS "[SNITCH-SDK] SNITCH_ABI: ${SNITCH_ABI}")
message(STATUS "[SNITCH-SDK] SNITCH_ISA: ${SNITCH_ISA}")
message(STATUS "[SNITCH-SDK] SNITCH_SIMULATOR: ${SNITCH_SIMULATOR}")