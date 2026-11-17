// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stdint.h>

#include "snrt_compat.h"

/// A DMA transfer identifier.
typedef uint32_t snrt_dma_txid_t;

SNRT_OVERLOADABLE static inline uint32_t snrt_dma_busy(const uint32_t channel);

SNRT_OVERLOADABLE static inline uint32_t snrt_dma_busy(void);

SNRT_OVERLOADABLE static inline uint32_t snrt_dma_would_block(
    const uint32_t channel);

SNRT_OVERLOADABLE static inline uint32_t snrt_dma_would_block(void);

SNRT_OVERLOADABLE inline snrt_dma_txid_t snrt_dma_start_2d(
    uint64_t dst, uint64_t src, size_t size, size_t dst_stride,
    size_t src_stride, size_t repeat, const uint32_t channel);

SNRT_OVERLOADABLE inline snrt_dma_txid_t snrt_dma_start_2d(
    uint64_t dst, uint64_t src, size_t size, size_t dst_stride,
    size_t src_stride, size_t repeat);

SNRT_OVERLOADABLE inline uint32_t snrt_dma_start_1d(uint64_t dst, uint64_t src,
                                                    size_t size,
                                                    const uint32_t channel);

SNRT_OVERLOADABLE inline uint32_t snrt_dma_start_1d(uint64_t dst, uint64_t src,
                                                    size_t size);

inline void snrt_dma_memset(void *ptr, uint8_t value, uint32_t len);
