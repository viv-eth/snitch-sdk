// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

#ifdef SNITCH_CLUSTER_ADDRMAP_CLUSTER_ALIAS_BASE_ADDR
extern volatile snitch_cluster_t* snrt_cluster_alias();
#endif

SNRT_OVERLOADABLE extern volatile snitch_cluster_t* snrt_cluster(
    int cluster_idx);

SNRT_OVERLOADABLE extern volatile snitch_cluster_t* snrt_cluster(void);

extern uint32_t snrt_l1_start_addr();

extern uint32_t snrt_l1_end_addr();

extern volatile uint32_t* snrt_cluster_clint_set_ptr();

extern volatile uint32_t* snrt_cluster_clint_clr_ptr();

extern uint32_t snrt_cluster_perf_counters_addr();

extern volatile uint32_t* snrt_zero_memory_ptr();
