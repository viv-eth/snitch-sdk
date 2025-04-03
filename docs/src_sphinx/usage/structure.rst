Folder Structure
================

The SDK is organized into the following main folders:

.. code-block:: none

    Snitch-SDK/
    ├── cmake/              # CMake modules, toolchain files, and configuration templates
    ├── core/               # Core runtime source files and public headers
    ├── deps/               # External dependencies (managed as Git submodules)
    ├── docs/               # Documentation sources (Sphinx, Doxygen, etc.)
    ├── omp/                # Parallel programming (OMP) support sources and headers
    ├── scripts/            # Utility scripts (e.g., header generation, formatting)
    ├── target/             # Target-specific header files for common and simulation environments
    │   ├── common/
    │   │   └── inc/        # Common public headers
    │   └── <simulator>/    # Simulator-specific headers (e.g., RTL, Banshee)
    │       └── inc/
    ├── tests/              # (Future) Test suite and test applications
    ├── LICENSE             # License file
    └── README.md           # Project README file
