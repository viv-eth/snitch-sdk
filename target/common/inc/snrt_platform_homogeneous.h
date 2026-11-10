// Copyright 2026 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Homogeneous platform; functions, not macros (core/src/team.c emits copies)

#pragma once

#include <stdint.h>

inline uint32_t __attribute__((const)) snrt_platform_cluster_num(void) {
    return SNRT_CLUSTER_NUM;
}

inline uint32_t __attribute__((const)) snrt_platform_cluster_core_num(
    uint32_t cluster_idx) {
    (void)cluster_idx;
    return SNRT_CLUSTER_CORE_NUM;
}

inline uint32_t __attribute__((const)) snrt_platform_cluster_base_hartid(
    uint32_t cluster_idx) {
    return SNRT_BASE_HARTID + cluster_idx * SNRT_CLUSTER_CORE_NUM;
}
