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
/*
 * The exit routines are declared here but will be defined exactly once
 * in start.c. This avoids duplicate definitions when the header is
 * included in multiple translation units.
 *
 * The noinline attribute is applied in the source file to ensure that
 * these functions are not inlined away. (If desired you could also mark
 * them here with __attribute__((noinline)) in the declaration; however,
 * it is typically better to do that on the definition.)
 */
void snrt_exit_default(int exit_code);
#ifndef SNRT_CRT0_ALTERNATE_EXIT
void snrt_exit(int exit_code);
#endif
#endif /* SNRT_CRT0_EXIT */

#ifdef SNRT_INIT_CLS
inline uint32_t snrt_cls_base_addr() {
  extern volatile uint32_t __cdata_start, __cdata_end;
  extern volatile uint32_t __cbss_start, __cbss_end;
  uint32_t cdata_size = ((uint32_t)&__cdata_end) - ((uint32_t)&__cdata_start);
  uint32_t cbss_size = ((uint32_t)&__cbss_end) - ((uint32_t)&__cbss_start);
  uint32_t l1_end_addr = SNRT_TCDM_START_ADDR +
                         snrt_cluster_idx() * SNRT_CLUSTER_OFFSET +
                         SNRT_TCDM_SIZE;
  return l1_end_addr - cdata_size - cbss_size;
}
#endif
#endif /* SNITCH_START_H */