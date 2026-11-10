// Copyright 2026 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

// C gets the C++ overloads, and default arguments as overloads, from clang
#ifndef SNRT_OVERLOADABLE
#ifdef __cplusplus
#define SNRT_OVERLOADABLE
#elif defined(__clang__)
#define SNRT_OVERLOADABLE __attribute__((overloadable))
#else
#error "The runtime's C API needs clang's overloadable attribute"
#endif
#endif

// C has no default arguments: C callers pass every argument explicitly
#ifndef SNRT_DEFAULT_ARG
#ifdef __cplusplus
#define SNRT_DEFAULT_ARG(value) = value
#else
#define SNRT_DEFAULT_ARG(value)
#endif
#endif
