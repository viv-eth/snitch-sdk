# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

cmake_minimum_required(VERSION 3.13)

# --- Setup SNITCH paths ---
get_filename_component(SNITCH_ROOT_DIR "${SNITCH_ROOT_DIR}" REALPATH)

set(SNITCH_CFG_DIR "${SNITCH_ROOT_DIR}/target/snitch_cluster/cfg")
get_filename_component(SNITCH_CFG_DIR "${SNITCH_CFG_DIR}" REALPATH)

# --- HW configuration file ---
set(DEFAULT_HW_CONFIG "${SNITCH_CFG_DIR}/default.hjson")
set(LRU_HW_CONFIG     "${SNITCH_CFG_DIR}/lru.hjson")

# User-specified config file; if not specified, default to default.hjson.
set(HW_CONFIG_INPUT "${DEFAULT_HW_CONFIG}" CACHE STRING 
    "Path to the hardware configuration file. Use fdiv.hjson etc. to override the default.")
message(STATUS "[SNITCH_RUNTIME] HW config: ${HW_CONFIG_INPUT}")

# --- Update the LRU config using symlinks ---
if(NOT EXISTS "${LRU_HW_CONFIG}")
  execute_process(COMMAND ln -sf "${HW_CONFIG_INPUT}" "${LRU_HW_CONFIG}")
else()
  execute_process(
    COMMAND readlink -f "${LRU_HW_CONFIG}"
    OUTPUT_VARIABLE CURRENT_LRU_TARGET
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  if(NOT "${CURRENT_LRU_TARGET}" STREQUAL "${HW_CONFIG_INPUT}")
    execute_process(COMMAND rm -f "${LRU_HW_CONFIG}")
    execute_process(COMMAND ln -sf "${HW_CONFIG_INPUT}" "${LRU_HW_CONFIG}")
  endif()
endif()

# Now use the LRU file as the definitive HW configuration.
set(HW_CONFIG_FILE "${LRU_HW_CONFIG}")

# --- Find Python interpreter ---
find_package(Python3 COMPONENTS Interpreter REQUIRED)

# --- Set path for the generator script ---
set(CLUSTER_GEN_PY "${SNITCH_ROOT_DIR}/util/clustergen.py")

# --- Directory where generated headers are written ---
set(GENERATED_CONFIG_DIR "${CMAKE_BINARY_DIR}/generated" CACHE PATH "Directory for generated headers")
file(MAKE_DIRECTORY "${GENERATED_CONFIG_DIR}")

# --- Function: generate_hw_header ---
#
# This function generates a hardware header using the provided template.
#
# @param TEMPLATE_FILE: The full path to the template (e.g., *.tpl).
function(generate_hw_header TEMPLATE_FILE)
  execute_process(
    COMMAND ${Python3_EXECUTABLE} ${CLUSTER_GEN_PY} 
            --clustercfg ${HW_CONFIG_FILE}
            --template ${TEMPLATE_FILE}
            --outdir ${GENERATED_CONFIG_DIR}
    RESULT_VARIABLE result
  )
  if(NOT result EQUAL 0)
    message(FATAL_ERROR "[SNITCH_RUNTIME] clustergen.py failed with exit code ${result}")
  endif()
  # Assume that the generated header has the same base name as the template
  # (i.e. snitch_cluster_cfg.h.tpl -> snitch_cluster_cfg.h).
  get_filename_component(TEMPLATE_BASENAME ${TEMPLATE_FILE} NAME_WE)
endfunction()

# --- Optionally add the generated headers to the include path ---
include_directories(${GENERATED_CONFIG_DIR})

