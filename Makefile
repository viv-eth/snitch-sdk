# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Authors: Viviane Potocnik <vivianep@iis.ee.ethz.ch>

ROOT_DIR := $(patsubst %/,%, $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

CLANG_FORMAT_EXECUTABLE ?= clang-format

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Available Targets:"
	@echo " - format: Format all code"

format:
	@echo "Formatting code..."
	@python scripts/run_clang_format.py -ir tests/ hal/ targets/ drivers/ devices/ --clang-format-executable=$(CLANG_FORMAT_EXECUTABLE)
	@python -m yapf -rip .


.PHONY: format help
