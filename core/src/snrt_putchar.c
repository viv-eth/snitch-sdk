// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stdio.h>

void snrt_putchar(char character) { putchar(character); }

void _putchar(char character) __attribute__((weak, alias("snrt_putchar")));
