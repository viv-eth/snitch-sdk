// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d(uint64_t dst, uint64_t src,
                                                    size_t size,
                                                    uint32_t channel);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d(uint64_t dst, uint64_t src,
                                                    size_t size);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d(volatile void *dst,
                                                    const volatile void *src,
                                                    size_t size,
                                                    uint32_t channel);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d(volatile void *dst,
                                                    const volatile void *src,
                                                    size_t size);

extern void snrt_dma_set_awuser(uint64_t field);

extern void snrt_dma_enable_multicast(uint64_t mask);

extern void snrt_dma_enable_reduction(uint64_t mask,
                                      snrt_collective_opcode_t opcode);

extern void snrt_dma_disable_multicast();

extern void snrt_dma_disable_reduction();

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d_reduction(
    uint64_t dst, uint64_t src, size_t size, uint64_t mask,
    snrt_collective_opcode_t opcode, uint32_t channel);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d_reduction(
    uint64_t dst, uint64_t src, size_t size, uint64_t mask,
    snrt_collective_opcode_t opcode);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d_reduction(
    uint64_t dst, uint64_t src, size_t size, snrt_comm_t comm,
    snrt_collective_opcode_t opcode, uint32_t channel);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d_reduction(
    uint64_t dst, uint64_t src, size_t size, snrt_comm_t comm,
    snrt_collective_opcode_t opcode);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d_mcast(
    uint64_t dst, uint64_t src, size_t size, uint64_t mask, uint32_t channel);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d_mcast(uint64_t dst,
                                                          uint64_t src,
                                                          size_t size,
                                                          uint64_t mask);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d_mcast(uint64_t dst,
                                                          uint64_t src,
                                                          size_t size,
                                                          snrt_comm_t comm,
                                                          uint32_t channel);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d_mcast(uint64_t dst,
                                                          uint64_t src,
                                                          size_t size,
                                                          snrt_comm_t comm);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d_reduction(
    volatile void *dst, const volatile void *src, size_t size, uint64_t mask,
    snrt_collective_opcode_t opcode, uint32_t channel);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d_reduction(
    volatile void *dst, const volatile void *src, size_t size, uint64_t mask,
    snrt_collective_opcode_t opcode);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d_mcast(
    volatile void *dst, const volatile void *src, size_t size, uint64_t mask,
    uint32_t channel);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_1d_mcast(
    volatile void *dst, const volatile void *src, size_t size, uint64_t mask);

SNRT_OVERLOADABLE extern snrt_dma_txid_t snrt_dma_start_2d(
    uint64_t dst, uint64_t src, size_t size, size_t dst_stride,
    size_t src_stride, size_t repeat, uint32_t channel);

SNRT_OVERLOADABLE extern snrt_dma_txid_t snrt_dma_start_2d(
    uint64_t dst, uint64_t src, size_t size, size_t dst_stride,
    size_t src_stride, size_t repeat);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_2d(
    volatile void *dst, const volatile void *src, size_t size,
    size_t dst_stride, size_t src_stride, size_t repeat, uint32_t channel);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_2d(
    volatile void *dst, const volatile void *src, size_t size,
    size_t dst_stride, size_t src_stride, size_t repeat);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_2d_mcast(
    uint64_t dst, uint64_t src, size_t size, size_t dst_stride,
    size_t src_stride, size_t repeat, uint32_t mask, uint32_t channel);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_2d_mcast(
    uint64_t dst, uint64_t src, size_t size, size_t dst_stride,
    size_t src_stride, size_t repeat, uint32_t mask);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_2d_mcast(
    volatile void *dst, const volatile void *src, size_t size,
    size_t dst_stride, size_t src_stride, size_t repeat, uint32_t mask,
    uint32_t channel);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_2d_mcast(
    volatile void *dst, const volatile void *src, size_t size,
    size_t dst_stride, size_t src_stride, size_t repeat, uint32_t mask);

extern void snrt_dma_start_tracking();

extern void snrt_dma_stop_tracking();

extern void snrt_dma_memset(void *ptr, uint8_t value, uint32_t len);

extern snrt_dma_txid_t snrt_dma_load_1d_tile(volatile void *dst,
                                             const volatile void *src,
                                             size_t tile_idx, size_t tile_size,
                                             uint32_t prec);

extern snrt_dma_txid_t snrt_dma_load_1d_tile_mcast(
    void *dst, const volatile void *src, size_t tile_idx, size_t tile_size,
    uint32_t prec, uint64_t mask);

extern snrt_dma_txid_t snrt_dma_reduction_load_1d_tile(
    void *dst, const volatile void *src, size_t tile_idx, size_t tile_size,
    uint32_t prec, uint64_t mask, snrt_collective_opcode_t opcode);

extern snrt_dma_txid_t snrt_dma_1d_to_2d(volatile void *dst,
                                         const volatile void *src, size_t size,
                                         size_t row_size, size_t stride);

extern snrt_dma_txid_t snrt_dma_2d_to_1d(volatile void *dst,
                                         const volatile void *src, size_t size,
                                         size_t row_size, size_t stride);

extern snrt_dma_txid_t snrt_dma_store_1d_tile(void *dst,
                                              const volatile void *src,
                                              size_t tile_idx, size_t tile_size,
                                              uint32_t prec);

SNRT_OVERLOADABLE extern snrt_dma_txid_t snrt_dma_load_2d_tile(
    void *dst, const volatile void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, size_t tile_ld);

SNRT_OVERLOADABLE extern snrt_dma_txid_t snrt_dma_load_2d_tile(
    void *dst, const volatile void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec);

SNRT_OVERLOADABLE extern snrt_dma_txid_t snrt_dma_load_2d_tile_mcast(
    void *dst, const volatile void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, size_t tile_ld, uint32_t mask);

SNRT_OVERLOADABLE extern snrt_dma_txid_t snrt_dma_load_2d_tile_mcast(
    void *dst, const volatile void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, uint32_t mask);

SNRT_OVERLOADABLE extern snrt_dma_txid_t snrt_dma_load_2d_tile_mcast(
    void *dst, const volatile void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, snrt_comm_t comm);

extern snrt_dma_txid_t snrt_dma_load_2d_tile_in_banks(
    void *dst, const volatile void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, size_t num_banks);

SNRT_OVERLOADABLE extern snrt_dma_txid_t snrt_dma_store_2d_tile(
    void *dst, const volatile void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, size_t tile_ld);

SNRT_OVERLOADABLE extern snrt_dma_txid_t snrt_dma_store_2d_tile(
    void *dst, const volatile void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec);

extern snrt_dma_txid_t snrt_dma_store_2d_tile_from_banks(
    void *dst, const volatile void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, size_t num_banks);

#ifdef SNRT_SUPPORTS_DMA_COMPUTE

extern void snrt_dma_set_opcode_params(uint32_t opcode, uint32_t params);

extern void snrt_dma_set_opcode(uint32_t opcode);

extern void snrt_dma_enable_transpose(uint32_t mode, uint32_t tensor_m,
                                      uint32_t tensor_n);

extern void snrt_dma_disable_compute();

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_transpose(
    uint64_t dst, uint64_t src, size_t size, uint32_t mode, uint32_t tensor_m,
    uint32_t tensor_n, uint32_t channel);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_transpose(
    uint64_t dst, uint64_t src, size_t size, uint32_t mode, uint32_t tensor_m,
    uint32_t tensor_n);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_transpose(
    volatile void *dst, const volatile void *src, size_t size, uint32_t mode,
    uint32_t tensor_m, uint32_t tensor_n, uint32_t channel);

SNRT_OVERLOADABLE extern uint32_t snrt_dma_start_transpose(
    volatile void *dst, const volatile void *src, size_t size, uint32_t mode,
    uint32_t tensor_m, uint32_t tensor_n);

#endif
