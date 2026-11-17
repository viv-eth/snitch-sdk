// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

// The address map structs are C only; start.S needs only the macros
#ifndef __ASSEMBLER__
#include "snitch_cluster_addrmap.h"
#endif
#include "snitch_cluster_cfg.h"
#include "snitch_cluster_peripheral_addrmap.h"
#include "snitch_cluster_raw_addrmap.h"
#define SNRT_TCDM_START_ADDR SNITCH_CLUSTER_ADDRMAP_CLUSTER_TCDM_BASE_ADDR
