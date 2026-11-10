// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

snrt_allocator_t l3_allocator;

#ifdef __cplusplus
extern uintptr_t snrt_align_up(uintptr_t addr, size_t size, uintptr_t base);
extern void *snrt_align_up(void *addr, size_t size, void *base);
extern uintptr_t snrt_align_up_hyperbank(uintptr_t addr);
extern void *snrt_align_up_hyperbank(void *addr);
#else
extern uintptr_t snrt_align_up_uintptr(uintptr_t addr, size_t size,
                                       uintptr_t base);
extern void *snrt_align_up_ptr(void *addr, size_t size, void *base);
extern uintptr_t snrt_align_up_hyperbank_uintptr(uintptr_t addr);
extern void *snrt_align_up_hyperbank_ptr(void *addr);
#endif

extern void *snrt_l1_next();
extern void *snrt_l3_next();

extern void *snrt_l1_alloc(size_t size);
extern void *snrt_l3_alloc(size_t size);

extern snrt_allocator_t *snrt_l1_allocator();
extern snrt_allocator_t *snrt_l3_allocator();

extern void snrt_l1_update_next(void *next);

extern void snrt_alloc_init();
