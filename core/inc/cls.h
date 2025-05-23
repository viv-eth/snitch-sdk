// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

extern __thread cls_t* _cls_ptr;

static inline cls_t* cls() { return _cls_ptr; }
