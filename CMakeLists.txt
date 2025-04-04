# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

### Building the runtime
# cmake -DTOOLCHAIN_DIR=/usr/pack/riscv-1.0-kgf/pulp-llvm-0.12.0 .. && cmake --build .


# -----------------------------------------------------------------------------
# Project and Global Settings
# -----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.13)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_COMPILER_WORKS 1)  # Skip compiler tests for bare-metal
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)
set(CMAKE_VERBOSE_MAKEFILE TRUE)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_LIST_DIR}/cmake/toolchains/toolchain_llvm.cmake)
project(snitch_runtime VERSION 1.0 LANGUAGES C ASM)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/common.cmake)

# -----------------------------------------------------------------------------
# Device Settings
# -----------------------------------------------------------------------------
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/tools/SnitchUtilities.cmake)
set(SN_DEVICE "snitch_cluster")
set(SN_CFG_DIR "${CMAKE_CURRENT_SOURCE_DIR}/devices/${SN_DEVICE}/cfg")
set(SN_HW_CFG "${SN_CFG_DIR}/default.hjson" CACHE STRING
    "Path to the hardware configuration file. Use fdiv.hjson etc. to override the default.")
set(SN_TEMPLATE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/devices/${SN_DEVICE}/templates")
set(SN_DEPS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/deps" CACHE STRING "Directory for external dependencies")
set(SN_GENERATED_DIR "${CMAKE_CURRENT_BINARY_DIR}/generated" CACHE PATH "Directory for generated headers")
file(MAKE_DIRECTORY "${SN_GENERATED_DIR}")

# -----------------------------------------------------------------------------
# Generate Hardware Headers
# -----------------------------------------------------------------------------
generate_all_headers()

# add_custom_target(generate_hw_headers ALL DEPENDS ${GENERATED_HEADERS})

# -----------------------------------------------------------------------------
# Include Directories
# -----------------------------------------------------------------------------
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/target/common/inc)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/target/${SNITCH_SIMULATOR}/inc)


# -----------------------------------------------------------------------------
# Output Directories
# -----------------------------------------------------------------------------
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)


# -----------------------------------------------------------------------------
# Add Subdirectories for Runtime Components
# -----------------------------------------------------------------------------

add_subdirectory(core)
add_subdirectory(omp)
# VIVIANEP: Both the core and omp libs depend on the generated headers
add_dependencies(snitch_runtime_core generate_all_headers)
add_dependencies(snitch_runtime_omp generate_all_headers)

if (ENABLE_SARIS)
  message(STATUS "[SNITCH_RUNTIME] Building SARIS runtime")
  add_subdirectory(saris)
endif()


# -----------------------------------------------------------------------------
# Create Aggregated Static Library from Object Libraries
# -----------------------------------------------------------------------------
add_library(snitch_runtime STATIC
    $<TARGET_OBJECTS:snitch_runtime_core>
    $<TARGET_OBJECTS:snitch_runtime_omp>
)
if(ENABLE_SARIS)
    target_link_libraries(snitch_runtime PUBLIC snitch_runtime_saris)
endif()


# -----------------------------------------------------------------------------
# Specify Interface for snitch_runtime
# -----------------------------------------------------------------------------
add_library(snitch_common_inc INTERFACE)
target_include_directories(snitch_common_inc INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/core/inc>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/omp/inc>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/target/common/inc>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/target/${SNITCH_SIMULATOR}/inc>
    $<BUILD_INTERFACE:${SN_DEPS_DIR}>
    $<BUILD_INTERFACE:${SN_DEPS_DIR}>/printf
    $<BUILD_INTERFACE:${SN_GENERATED_DIR}>
    $<INSTALL_INTERFACE:inc>  
)
    
target_link_libraries(snitch_runtime
    PUBLIC
    snitch_common_inc
)

# -----------------------------------------------------------------------------
# Set Link Options for snitch_runtime
# -----------------------------------------------------------------------------
# TODO: Check which of these link options are actually needed
target_link_options(snitch_runtime
  PUBLIC
  -L${CMAKE_CURRENT_LIST_DIR}/linker
  -mcpu=snitch
  -static
  -mcmodel=small
  -Wl, -dead_strip
  -Wl, -mno-relax
  -nostartfiles
  -ffast-math
  -fno-common
  -fno-builtin-printf
  -march=${SNITCH_ISA}
  -mabi=${SNITCH_ABI}
)


# -----------------------------------------------------------------------------
# Installation
# -----------------------------------------------------------------------------
include(CMakePackageConfigHelpers)

# Install common include directories.
install(TARGETS snitch_common_inc
    EXPORT SnitchRuntimeTargets
    INCLUDES DESTINATION inc
)

# Install the snitch_runtime target.
install(TARGETS snitch_runtime
    EXPORT SnitchRuntimeTargets
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)

# Install public headers.
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/core/inc 
        DESTINATION include/snitch_runtime/core)
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/omp/inc 
        DESTINATION include/snitch_runtime/omp)
install(DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/target/common/inc 
        DESTINATION include/snitch_runtime/common)
install(DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/target/${SNITCH_SIMULATOR}/inc 
        DESTINATION include/snitch_runtime/${SNITCH_SIMULATOR})
install(DIRECTORY ${SN_DEPS_DIR} 
        DESTINATION include/snitch_runtime/deps)
install(DIRECTORY ${SN_GENERATED_DIR}
        DESTINATION include/snitch_runtime/generated)


# Export the targets for downstream use.
install(EXPORT SnitchRuntimeTargets
    FILE SnitchRuntimeTargets.cmake
    NAMESPACE SnitchRuntime::
    DESTINATION lib/cmake/SnitchRuntime
)

# Create a package configuration file.
configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/SnitchRuntimeConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/SnitchRuntimeConfig.cmake
    INSTALL_DESTINATION lib/cmake/SnitchRuntime
)

# Create a version file for the package.
write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/SnitchRuntimeConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

# Install the package configuration files.
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/SnitchRuntimeConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/SnitchRuntimeConfigVersion.cmake
    DESTINATION lib/cmake/SnitchRuntime
)


