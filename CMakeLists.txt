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
set(SNITCH_DEVICE "snitch_cluster" CACHE STRING "Device name")
set(SNITCH_DEPS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/deps" CACHE STRING "Directory for external dependencies")

# -----------------------------------------------------------------------------
# Include Helper CMake Modules
# -----------------------------------------------------------------------------
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/tools/generate_hw_headers.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/tools/generate_peripherals.cmake)


# -----------------------------------------------------------------------------
# Generate Hardware Headers
# -----------------------------------------------------------------------------
set(SNITCH_CLUSTER_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/scripts/snitch_cluster_cfg.h.tpl")
set(SNITCH_ADDRMAP_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/scripts/snitch_cluster_addrmap.h.tpl")
generate_hw_header(${SNITCH_CLUSTER_HEADER})
generate_hw_header(${SNITCH_ADDRMAP_HEADER})

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
# Specify Public Include Directories for snitch_runtime
# -----------------------------------------------------------------------------
target_include_directories(snitch_runtime
  PUBLIC
    $<BUILD_INTERFACE:${GENERATED_CONFIG_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/core/inc>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/omp/inc>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/target/common/inc>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/target/${SNITCH_SIMULATOR}/inc>
    $<BUILD_INTERFACE:${SNITCH_DEPS_DIR}>
    $<INSTALL_INTERFACE:include>
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
install(DIRECTORY ${SNITCH_DEPS_DIR} 
        DESTINATION include/snitch_runtime/deps)

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


