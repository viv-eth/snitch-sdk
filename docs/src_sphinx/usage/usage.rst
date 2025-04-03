Usage
=====

Building the SDK
----------------

The Snitch-SDK is built using RISC-V LLVM 12.0.1 or later to ensure compatibility.

.. important::
    For LLVM versions less than 15, linker relaxation is not supported and is disabled.

Generic Environment
^^^^^^^^^^^^^^^^^^^

Before building, ensure that the external dependencies are initialized:

.. code-block:: bash

    git submodule update --init --recursive

To build the SDK and all tests contained within it, run:

.. code-block:: bash

    mkdir build && cd build
    cmake -DSNITCH_DEVICE=<device> ..
    cmake --build . -j

Replace ``<device>`` with one of the supported device flavors (e.g., ``snitch_cluster``). The resulting binaries will be stored in ``build/bin`` and can be used to run tests or deploy applications on the Snitch cluster.

If you did not globally install the toolchain, you need to specify the ``TOOLCHAIN_DIR`` parameter when running cmake:

.. code-block:: bash

    mkdir build && cd build
    cmake -DSNITCH_DEVICE=<device> -DTOOLCHAIN_DIR=<path-to-toolchain> ..
    cmake --build . -j

IIS Workstations
^^^^^^^^^^^^^^^^

On IIS systems, users can leverage the pre-installed LLVM compiler by activating the riscv environment with the ``riscv`` command. This sets up the necessary environment variables for the toolchain. To build the SDK on an IIS workstation, run:

.. code-block:: bash

    riscv <SHELL_TYPE> # Setup the default riscv environment (modifies PATH and LD_LIBRARY_PATH)
    mkdir build && cd build
    cmake -DSNITCH_DEVICE=<device> -DTOOLCHAIN_DIR=/usr/pack/riscv-1.0-kgf/pulp-llvm-0.12.0 ..
    cmake --build . -j

Targets
-------

The SDK is intended to support multiple device flavors of the Snitch cluster, each with a different configuration. The available devices are defined in the SDK configuration (default is ``snitch_cluster``). For example, you might support:

- ``snitch_cluster``: The default configuration for the Snitch cluster.
- ``serita``: An alternative configuration with different peripheral support.

Tests
-----

.. warning::
   The integrated test suite is still to be implemented. The instructions below are provided for future use once test support is added.

In the meantime, you can run the generated binaries manually to validate the functionality of your code.


You can validate the functional correctness of your code using the integrated test suite. The tests can be run with your preferred simulator or on actual hardware. For example, if you are using a simulator, execute:

.. code-block:: bash

    ./path/to/simulator --device=<device> --binary <path-to-binary> run

Replace ``<device>`` with the appropriate device flavor and ``<path-to-binary>`` with the path to the generated binary in ``build/bin``.

Visual Studio Code Integration
------------------------------

To enable automatic configuration of the C/C++ extension and integrated CMake build flow in Visual Studio Code on IIS workstations, add the following to your ``.vscode/settings.json``:

.. code-block:: json

    {
        "cmake.configureSettings": {
            "TOOLCHAIN_DIR": "/usr/pack/riscv-1.0-kgf/pulp-llvm-0.12.0",
            "SNITCH_DEVICE": "snitch_cluster"
        }
    }

If you are not on an IIS system, adjust the paths according to your local installation.

