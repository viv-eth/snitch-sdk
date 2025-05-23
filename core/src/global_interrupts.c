// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

extern void snrt_int_sw_clear(uint32_t hartid);

extern void snrt_int_sw_set(uint32_t hartid);

extern uint32_t snrt_int_sw_get(uint32_t hartid);
