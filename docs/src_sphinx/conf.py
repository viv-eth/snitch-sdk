# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

import os
import sys

# Insert the repository root into sys.path for autodoc (if needed)
sys.path.insert(0, os.path.abspath('../../'))

project = 'Snitch-SDK'
copyright = '2025, Viviane Potocnik'
author = 'Viviane Potocnik'
release = '1.0'

# -- General configuration ---------------------------------------------------
# See: https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    'myst_parser',  # Parser for Markdown files
    'breathe',  # Breathe extension for Doxygen integration
    'sphinxcontrib.moderncmakedomain',  # Modern CMake domain
    'sphinx_rtd_theme',  # ReadTheDocs theme
    'sphinx.ext.intersphinx',  # Link to other projects
    'sphinx.ext.todo',  # Support for TODO items
    'sphinx.ext.autosectionlabel',  # Automatic section labels
    # Optional Python extensions:
    # 'sphinx.ext.napoleon',
    # 'sphinx.ext.autodoc',
    # 'sphinx.ext.autosummary',
]
autosummary_generate = True
napoleon_use_ivar = True
add_module_names = True
autodoc_member_order = "bysource"

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store', "*flycheck_*"]

# -- Options for HTML output -------------------------------------------------
# See: https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']

# -- Options for Breathe -----------------------------------------------------
# See: https://breathe.readthedocs.io/en/latest/

breathe_projects = {
    "snitch_sdk":
    "../_build_doxygen/xml",  # Adjust this path based on your Doxygen output
}
breathe_default_project = "snitch_sdk"

# -- Options for ToDo ---------------------------------------------------------
# See: https://www.sphinx-doc.org/en/master/usage/extensions/todo.html

todo_include_todos = True

# -- Options for HTML templates ------------------------------------------------
# Extract branch name from git for versioning
branch = os.popen("git rev-parse --abbrev-ref HEAD").read().strip()

html_context = {
    'current_version':
    f"{branch}",
    'versions': [
        ["master", "https://pulp-platform.github.io/snitch-sdk/"],
        ["devel", "https://pulp-platform.github.io/snitch-sdk/branch/devel/"],
    ],
}
