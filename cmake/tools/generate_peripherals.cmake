# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

# --- Set the peripheral directory and register configuration file ---
set(SN_PERIPH_DIR "${SNITCH_ROOT_DIR}/hw/snitch_cluster/src/snitch_cluster_peripheral")
set(SN_PERIPH_REG_CFG "${SN_PERIPH_DIR}/snitch_cluster_peripheral_reg.hjson")

# --- Set the output location and name for the generated peripheral header ---
# This header will be placed under the 'generated' directory.
set(SNITCH_PERIPH_HEADER "${GENERATED_CONFIG_DIR}/snitch_cluster_peripheral.h")

# --- Determine the REGGEN tool using BENDER ---
# First, find the BENDER executable if not already defined.
if(NOT DEFINED BENDER)
  find_program(BENDER_EXECUTABLE NAMES bender)
  if(NOT BENDER_EXECUTABLE)
    message(FATAL_ERROR "Bender not found. Please install Bender or set the BENDER variable.")
  endif()
  set(BENDER "${BENDER_EXECUTABLE}")
endif()

# Execute the BENDER command to get the register interface path.
execute_process(
  COMMAND ${BENDER} path register_interface
  OUTPUT_VARIABLE REGISTER_INTERFACE_PATH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)
# Append the subpath to get the full path to regtool.py.
set(REGGEN "${REGISTER_INTERFACE_PATH}/vendor/lowrisc_opentitan/util/regtool.py")

# --- Custom command to generate the peripheral header ---
add_custom_command(
  OUTPUT "${SNITCH_PERIPH_HEADER}"
  COMMAND ${Python3_EXECUTABLE} ${REGGEN} -D -o "${SNITCH_PERIPH_HEADER}" "${SN_PERIPH_REG_CFG}"
  DEPENDS "${SN_PERIPH_REG_CFG}"
  COMMENT "[REGGEN] Generating snitch_cluster_peripheral.h from ${SN_PERIPH_REG_CFG}"
)

# --- Custom target to tie the command into the build ---
add_custom_target(generate_snitch_cluster_peripheral_header ALL
  DEPENDS "${SNITCH_PERIPH_HEADER}"
)

# --- Add the generated headers directory to the include path ---
include_directories(${GENERATED_CONFIG_DIR})
