# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

# This module generates the hardware headers with clustergen.py and PeakRDL, as upstream snitch_cluster does.
#
# Required variables (set them before including this module):
#   SN_TEMPLATE_DIR        - Directory with the templates (*.tpl) and snitch_cluster_peripheral_reg.rdl.
#   SN_HW_CFG              - Path to the hardware configuration file (e.g., default.json).
#   SN_GENERATED_DIR       - Directory where the hardware headers are generated.
#   SNITCH_ROOT_DIR        - Root directory of the Snitch SDK.
#   Python3_EXECUTABLE     - Path to a Python3 executable with the packages from requirements.txt.
#
# Optionally, you can set:
#   CLUSTER_GEN_PY         - Path to clustergen.py (defaults to <SNITCH_ROOT_DIR>/scripts/clustergen/clustergen.py)
#   PEAKRDL                - PeakRDL command (defaults to <Python3_EXECUTABLE> -m peakrdl)

# Function to fill every template with clustergen.py: <name>.tpl generates <name>.
function(generate_hw_headers OUTPUTS_VAR)
  # Use a default for clustergen.py if not already defined.
  if(NOT DEFINED CLUSTER_GEN_PY)
    set(CLUSTER_GEN_PY "${SNITCH_ROOT_DIR}/scripts/clustergen/clustergen.py")
  endif()
  get_filename_component(CLUSTER_GEN_DIR ${CLUSTER_GEN_PY} DIRECTORY)

  file(GLOB TEMPLATE_FILES CONFIGURE_DEPENDS "${SN_TEMPLATE_DIR}/*.tpl")

  set(GENERATED_FILES "")
  foreach(template ${TEMPLATE_FILES})
    get_filename_component(template_name ${template} NAME)
    string(REGEX REPLACE "\\.tpl$" "" output_name ${template_name})
    set(output_file "${SN_GENERATED_DIR}/${output_name}")
    add_custom_command(
      OUTPUT ${output_file}
      DEPENDS ${template} ${SN_HW_CFG} ${CLUSTER_GEN_PY}
              ${CLUSTER_GEN_DIR}/cluster.py ${CLUSTER_GEN_DIR}/snitch_cluster.schema.json
      COMMAND ${Python3_EXECUTABLE} ${CLUSTER_GEN_PY}
              --clustercfg ${SN_HW_CFG}
              --template ${template}
              --output ${output_file}
      COMMENT "[SNITCH-SDK] Generating ${output_name} with clustergen.py"
    )
    list(APPEND GENERATED_FILES ${output_file})
  endforeach()

  set(${OUTPUTS_VAR} ${GENERATED_FILES} PARENT_SCOPE)
endfunction()

# Function to generate the C headers from the SystemRDL descriptions with PeakRDL.
function(generate_rdl_headers OUTPUTS_VAR)
  if(NOT DEFINED PEAKRDL)
    set(PEAKRDL ${Python3_EXECUTABLE} -m peakrdl)
  endif()

  set(PERIPH_RDL "${SN_TEMPLATE_DIR}/snitch_cluster_peripheral_reg.rdl")
  set(CLUSTER_RDL "${SN_GENERATED_DIR}/snitch_cluster.rdl")
  set(ADDRMAP_RDL "${SN_GENERATED_DIR}/snitch_cluster_addrmap.rdl")
  set(RDL_INCDIRS -I ${SN_TEMPLATE_DIR} -I ${SN_GENERATED_DIR})

  set(ADDRMAP_H "${SN_GENERATED_DIR}/snitch_cluster_addrmap.h")
  set(RAW_ADDRMAP_H "${SN_GENERATED_DIR}/snitch_cluster_raw_addrmap.h")
  set(PERIPH_H "${SN_GENERATED_DIR}/snitch_cluster_peripheral.h")
  set(PERIPH_ADDRMAP_H "${SN_GENERATED_DIR}/snitch_cluster_peripheral_addrmap.h")

  add_custom_command(
    OUTPUT ${ADDRMAP_H}
    DEPENDS ${ADDRMAP_RDL} ${CLUSTER_RDL} ${PERIPH_RDL}
    COMMAND ${PEAKRDL} c-header ${ADDRMAP_RDL} -o ${ADDRMAP_H} -i -b ltoh ${RDL_INCDIRS}
    COMMENT "[SNITCH-SDK] Generating snitch_cluster_addrmap.h with PeakRDL"
  )
  add_custom_command(
    OUTPUT ${RAW_ADDRMAP_H}
    DEPENDS ${ADDRMAP_RDL} ${CLUSTER_RDL} ${PERIPH_RDL}
    COMMAND ${PEAKRDL} raw-header ${ADDRMAP_RDL} -o ${RAW_ADDRMAP_H}
            --base_name snitch_cluster_raw_addrmap --format c ${RDL_INCDIRS}
    COMMENT "[SNITCH-SDK] Generating snitch_cluster_raw_addrmap.h with PeakRDL"
  )
  add_custom_command(
    OUTPUT ${PERIPH_H}
    DEPENDS ${PERIPH_RDL}
    COMMAND ${PEAKRDL} c-header ${PERIPH_RDL} -o ${PERIPH_H} -i -b ltoh
    COMMENT "[SNITCH-SDK] Generating snitch_cluster_peripheral.h with PeakRDL"
  )
  add_custom_command(
    OUTPUT ${PERIPH_ADDRMAP_H}
    DEPENDS ${PERIPH_RDL}
    COMMAND ${PEAKRDL} raw-header ${PERIPH_RDL} -o ${PERIPH_ADDRMAP_H} --format c
    COMMENT "[SNITCH-SDK] Generating snitch_cluster_peripheral_addrmap.h with PeakRDL"
  )

  set(${OUTPUTS_VAR} ${ADDRMAP_H} ${RAW_ADDRMAP_H} ${PERIPH_H} ${PERIPH_ADDRMAP_H} PARENT_SCOPE)
endfunction()

# Function to aggregate all header generation.
function(generate_all_headers)
  set(SN_PY_MODULES "json5, jsonref, jsonschema, mako")
  if(NOT DEFINED PEAKRDL)
    string(APPEND SN_PY_MODULES ", peakrdl, peakrdl_cheader, peakrdl_rawheader")
  endif()
  execute_process(
    COMMAND ${Python3_EXECUTABLE} -c "import ${SN_PY_MODULES}"
    RESULT_VARIABLE SN_PY_MODULES_MISSING
    OUTPUT_QUIET ERROR_QUIET
  )
  if(SN_PY_MODULES_MISSING)
    message(FATAL_ERROR "[SNITCH-SDK] ${Python3_EXECUTABLE} cannot import ${SN_PY_MODULES}: "
                        "install requirements.txt or set Python3_EXECUTABLE to an environment with them.")
  endif()

  generate_hw_headers(HW_HEADERS)
  generate_rdl_headers(RDL_HEADERS)
  add_custom_target(generate_all_headers ALL DEPENDS ${HW_HEADERS} ${RDL_HEADERS})
endfunction()
