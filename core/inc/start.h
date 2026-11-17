// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef SNITCH_START_H
#define SNITCH_START_H

#include "snrt.h"

#ifdef OPENOCD_SEMIHOSTING
#include "openocd.h"
#endif

#ifdef SNRT_CRT0_EXIT
// Defined once in start.c (noinline) rather than inline as upstream
void snrt_exit_default(int exit_code);
#ifndef SNRT_CRT0_ALTERNATE_EXIT
void snrt_exit(int exit_code);
#endif
#endif /* SNRT_CRT0_EXIT */

#ifdef SNRT_INIT_CLS
inline uint32_t snrt_cls_base_addr() {
    /* Linker script symbols: use extern char[] (address token only). */
    extern char __cdata_start[], __cdata_end[];
    extern char __cbss_start[], __cbss_end[];
    uint32_t cdata_size = (uintptr_t)__cdata_end - (uintptr_t)__cdata_start;
    uint32_t cbss_size = (uintptr_t)__cbss_end - (uintptr_t)__cbss_start;
    uint32_t l1_end_addr = SNRT_TCDM_START_ADDR +
                           snrt_cluster_idx() * SNRT_CLUSTER_OFFSET +
                           SNRT_TCDM_SIZE;
    return l1_end_addr - cdata_size - cbss_size;
}
#endif
#endif /* SNITCH_START_H */
