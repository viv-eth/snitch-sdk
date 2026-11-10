// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stdint.h>

#include "snrt_compat.h"

#ifdef SNITCH_CLUSTER_ADDRMAP_CLUSTER_ALIAS_BASE_ADDR
inline volatile snitch_cluster_t* snrt_cluster_alias();
#endif

SNRT_OVERLOADABLE inline volatile snitch_cluster_t* snrt_cluster(
    int cluster_idx);

SNRT_OVERLOADABLE inline volatile snitch_cluster_t* snrt_cluster(void);

inline uint32_t __attribute__((const)) snrt_l1_start_addr();

inline uint32_t __attribute__((const)) snrt_l1_end_addr();

inline volatile uint32_t* __attribute__((const)) snrt_clint_mutex_ptr();

inline volatile uint32_t* __attribute__((const)) snrt_clint_msip_ptr(
    uint32_t hartid);

inline volatile uint32_t* __attribute__((const)) snrt_cluster_clint_set_ptr();

inline volatile uint32_t* __attribute__((const)) snrt_cluster_clint_clr_ptr();

inline uint32_t __attribute__((const)) snrt_cluster_perf_counters_addr();

inline volatile uint32_t* __attribute__((const)) snrt_zero_memory_ptr();
