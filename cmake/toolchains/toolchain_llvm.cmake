# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>
# Philip Wiese <wiesep@iis.ee.ethz.ch>

set(CMAKE_EXECUTABLE_SUFFIX ".elf")

set(CMAKE_SYSTEM_NAME Generic)

set(LLVM_TAG llvm)

# Use TOOLCHAIN_DIR (passed in via -DTOOLCHAIN_DIR=...) for locating LLVM/Clang tools
set(CMAKE_C_COMPILER ${TOOLCHAIN_DIR}/bin/clang)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_DIR}/bin/clang++)
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_DIR}/bin/clang)

set(CMAKE_OBJCOPY ${TOOLCHAIN_DIR}/bin/${LLVM_TAG}-objcopy)
set(CMAKE_OBJDUMP ${TOOLCHAIN_DIR}/bin/${LLVM_TAG}-objdump)
set(CMAKE_AR ${TOOLCHAIN_DIR}/bin/${LLVM_TAG}-ar)
set(CMAKE_RANLIB ${TOOLCHAIN_DIR}/bin/${LLVM_TAG}-ranlib)
set(CMAKE_STRIP ${TOOLCHAIN_DIR}/bin/${LLVM_TAG}-strip)

# Disable ABI detection
set(CMAKE_C_ABI_COMPILED "False")

# ---------------------------------------------------------------------------
# Compile Options
# ---------------------------------------------------------------------------
add_compile_options("--target=riscv32-unknown-elf")

# ---------------------------------------------------------------------------
# Link Options
# ---------------------------------------------------------------------------
# Use LLVM LLD linker
add_link_options("-fuse-ld=lld")

# ---------------------------------------------------------------------------
# LLVM Version Check
# ---------------------------------------------------------------------------
execute_process(
    COMMAND ${CMAKE_C_COMPILER} --version
    OUTPUT_VARIABLE LLVM_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Extract major/minor/patch version numbers
string(REGEX MATCH "^[0-9]+" LLVM_VERSION_MAJOR "${LLVM_VERSION}")
string(REGEX MATCH "[0-9]+$" LLVM_VERSION_MINOR "${LLVM_VERSION}")
string(REGEX MATCH "[0-9]+$" LLVM_VERSION_PATCH "${LLVM_VERSION}")

if (LLVM_VERSION_MAJOR LESS 15)
    message(STATUS "Disabling linker relaxation for LLVM < 15")
    # WIESEP: Disable linker relaxation for LLVM 12
    add_compile_options("-mno-relax")
    add_link_options("-Wl,--no-relax")
endif()