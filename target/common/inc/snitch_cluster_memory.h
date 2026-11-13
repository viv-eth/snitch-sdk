// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stddef.h>
#include <stdint.h>

#include "snrt_compat.h"

#ifdef SNITCH_CLUSTER_ADDRMAP_CLUSTER_ALIAS_BASE_ADDR
// Must return a pointer to the snitch_cluster_t struct
// of the cluster alias.
inline volatile snitch_cluster_t* snrt_cluster_alias() {
    return &(snitch_cluster_addrmap.cluster_alias);
}
#endif

// Must return a pointer to the snitch_cluster_t struct
// of the cluster selected by cluster_idx.
SNRT_OVERLOADABLE inline volatile snitch_cluster_t* snrt_cluster(
    int cluster_idx) {
    // Clusters are SNRT_CLUSTER_OFFSET apart, as start.S and sync.h assume
    uintptr_t addr = (uintptr_t)(&snitch_cluster_addrmap.cluster);
    addr += (uintptr_t)cluster_idx * SNRT_CLUSTER_OFFSET;
    return (volatile snitch_cluster_t*)addr;
}

// Must return a pointer to the snitch_cluster_t struct
// of the cluster invoking the function.
SNRT_OVERLOADABLE inline volatile snitch_cluster_t* snrt_cluster(void) {
    return snrt_cluster(snrt_cluster_idx());
}

// snitch-sdk accessors, kept for chimera-sdk and existing callers
inline uint32_t snrt_l1_start_addr() {
    return (uintptr_t)(snrt_cluster()->tcdm.mem);
}

inline uint32_t snrt_l1_end_addr() {
    return snrt_l1_start_addr() + SNRT_TCDM_SIZE;
}

inline volatile uint32_t* snrt_cluster_clint_set_ptr() {
    return (volatile uint32_t*)&(snrt_cluster()->peripheral_reg.cl_clint_set);
}

inline volatile uint32_t* snrt_cluster_clint_clr_ptr() {
    return (volatile uint32_t*)&(snrt_cluster()->peripheral_reg.cl_clint_clear);
}

inline uint32_t snrt_cluster_perf_counters_addr() {
    volatile snitch_cluster_t* cluster = snrt_cluster();
    return (uintptr_t)(&cluster->peripheral_reg.perf_regs);
}

inline volatile uint32_t* snrt_zero_memory_ptr() {
    return (volatile uint32_t*)(snrt_cluster()->zeromem.mem);
}
