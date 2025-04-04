# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

# This module provides functions to generate hardware and peripheral headers.
#
# Required variables (set them before including this module):
#   SN_TEMPLATE_DIR        - Directory with template (*.tpl) files for hardware headers.
#   SN_HW_CFG              - Path to the hardware configuration file (e.g., default.hjson).
#   SN_GENERATED_DIR       - Directory where the hardware headers are generated.
#   SNITCH_ROOT_DIR        - Root directory of the Snitch project.
#   GENERATED_CONFIG_DIR   - Directory where the peripheral header will be generated.
#   Python3_EXECUTABLE     - Path to the Python3 executable.
#
# Optionally, you can set:
#   CLUSTER_GEN_PY         - Path to clustergen.py (defaults to <CMAKE_CURRENT_SOURCE_DIR>/scripts/clustergen.py)
#   BENDER                 - Path to the Bender executable; if not set, it will be searched.

# Function to generate hardware headers.
function(generate_hw_headers)
  # Use a default for clustergen.py if not already defined.
  if(NOT DEFINED CLUSTER_GEN_PY)
    set(CLUSTER_GEN_PY "${CMAKE_CURRENT_SOURCE_DIR}/scripts/clustergen.py")
  endif()

  file(GLOB TEMPLATE_FILES CONFIGURE_DEPENDS "${SN_TEMPLATE_DIR}/*.tpl")
  message(STATUS "[DEBUG] Found template files: ${TEMPLATE_FILES}")

  set(GENERATED_HEADERS "")
  foreach(template ${TEMPLATE_FILES})
    get_filename_component(template_name ${template} NAME_WE)
    set(output_file "${SN_GENERATED_DIR}/${template_name}.h")
    add_custom_command(
      OUTPUT ${output_file}
      DEPENDS ${template} ${SN_HW_CFG} ${CLUSTER_GEN_PY}
      COMMAND ${Python3_EXECUTABLE} ${CLUSTER_GEN_PY} 
              --clustercfg ${SN_HW_CFG} 
              --template ${template} 
              --outdir ${SN_GENERATED_DIR}
      COMMENT "Generating hardware header ${output_file} with clustergen.py"
    )
    list(APPEND GENERATED_HEADERS ${output_file})
  endforeach()

  add_custom_target(generate_hw_headers ALL DEPENDS ${GENERATED_HEADERS})
endfunction()

# Function to generate the peripheral header.
function(generate_peripheral_header)
  # Define the peripheral directory and register configuration file.
  set(SN_PERIPH_REG_CFG "${SN_TEMPLATE_DIR}/snitch_cluster_peripheral_reg.hjson")
  set(SN_PERIPH_HEADER "${SN_GENERATED_DIR}/snitch_cluster_peripheral.h")

  # Locate Bender if not already defined.
  if(NOT DEFINED BENDER)
    find_program(BENDER_EXECUTABLE NAMES bender)
    if(NOT BENDER_EXECUTABLE)
      message(FATAL_ERROR "Bender not found. Please install Bender or set the BENDER variable.")
    endif()
    set(BENDER "${BENDER_EXECUTABLE}")
  endif()

  # Get the register interface path from Bender.
  execute_process(
    COMMAND ${BENDER} path register_interface
    OUTPUT_VARIABLE REGISTER_INTERFACE_PATH
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  # Append the subpath to regtool.py.
  set(REGGEN "${REGISTER_INTERFACE_PATH}/vendor/lowrisc_opentitan/util/regtool.py")

  add_custom_command(
    OUTPUT "${SN_PERIPH_HEADER}"
    COMMAND ${Python3_EXECUTABLE} ${REGGEN} -D -o "${SN_PERIPH_HEADER}" "${SN_PERIPH_REG_CFG}"
    DEPENDS "${SN_PERIPH_REG_CFG}"
    COMMENT "[REGGEN] Generating snitch_cluster_peripheral.h from ${SN_PERIPH_REG_CFG}"
  )

  add_custom_target(generate_snitch_cluster_peripheral_header ALL
    DEPENDS "${SN_PERIPH_HEADER}"
  )
endfunction()

# Function to aggregate all header generation.
function(generate_all_headers)
  generate_hw_headers()
  generate_peripheral_header()
  add_custom_target(generate_all_headers ALL
    DEPENDS generate_hw_headers generate_snitch_cluster_peripheral_header
  )
endfunction()