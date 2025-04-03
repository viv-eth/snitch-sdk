# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

set(SNITCH_ABI ilp32d CACHE STRING "ABI for the target Snitch flavor. Default is ilp32d.")
set(SNITCH_ISA rv32imafd_xdma1 CACHE STRING "ISA for the target Snitch flavor. Default is rv32imafd.")
set(SNITCH_SIMULATOR rtl CACHE STRING "Simulator for the Snitch target. Default is rtl.")

message(STATUS "[SNITCH_RUNTIME] SNITCH_ABI: ${SNITCH_ABI}")
message(STATUS "[SNITCH_RUNTIME] SNITCH_ISA: ${SNITCH_ISA}")
message(STATUS "[SNITCH_RUNTIME] SNITCH_SIMULATOR: ${SNITCH_SIMULATOR}")