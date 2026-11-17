Usage
=====

Building the SDK
----------------

The Snitch-SDK needs PULP's RISC-V LLVM 18.1 (``llvm-18.1.4-pulp``), which provides ``-mcpu=snitch`` and the Snitch extensions Xssr, Xfrep and Xdma. chimera-sdk builds it with ``make llvm`` and ships it, with picolibc, in its container under ``/app/install``. Older PULP LLVM releases such as ``pulp-llvm-0.12.0`` (LLVM 12) cannot build the runtime.

Generic Environment
^^^^^^^^^^^^^^^^^^^

Before building, ensure that the external dependencies are initialized:

.. code-block:: bash

    git submodule update --init --recursive

To build the SDK and all tests contained within it, run:

.. code-block:: bash

    mkdir build && cd build
    cmake -DCMAKE_BUILD_TYPE=Release -DSNITCH_DEVICE=<device> ..
    cmake --build . -j

Replace ``<device>`` with one of the supported device flavors (e.g., ``snitch_cluster``). The resulting binaries will be stored in ``build/bin`` and can be used to run tests or deploy applications on the Snitch cluster.

If you did not globally install the toolchain, you need to specify the ``TOOLCHAIN_DIR`` parameter when running cmake:

.. code-block:: bash

    mkdir build && cd build
    cmake -DCMAKE_BUILD_TYPE=Release -DSNITCH_DEVICE=<device> -DTOOLCHAIN_DIR=<path-to-toolchain> ..
    cmake --build . -j

.. note:: ``Release`` (``-O3``) is the default build type, and ``Debug`` builds use ``-Og``. The DMA functions pass immediates to inline assembly and must be inlined, so the runtime cannot be built at ``-O0``.

The hardware headers are generated from the cluster configuration ``-DSN_HW_CFG=<path>`` (default: ``devices/<device>/cfg/default.json``) with clustergen and PeakRDL, which need the Python packages in ``requirements.txt``. If they live in an inactive virtual environment, pass ``-DPython3_EXECUTABLE=<venv>/bin/python``. For a toolchain without a C library, pass ``-DPICOLIBC_DIR=<picolibc-install>``.

IIS Workstations
^^^^^^^^^^^^^^^^

IIS systems have no pre-installed PULP LLVM 18.1 (``/usr/pack/riscv-1.0-kgf/pulp-llvm-0.12.0`` is LLVM 12). Build the toolchain and picolibc once with chimera-sdk, into a directory on a scratch disk, and point the SDK at them:

.. code-block:: bash

    make -C <chimera-sdk> llvm compiler-rt-riscv-multilib picolibc-multilib INSTALL_DIR=<install>
    mkdir build && cd build
    cmake -DSNITCH_DEVICE=<device> -DTOOLCHAIN_DIR=<install>/llvm-18.1.4-pulp -DPICOLIBC_DIR=<install>/picolibc ..
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

To enable automatic configuration of the C/C++ extension and integrated CMake build flow in Visual Studio Code, add the following to your ``.vscode/settings.json``:

.. code-block:: json

    {
        "cmake.configureSettings": {
            "TOOLCHAIN_DIR": "<install>/llvm-18.1.4-pulp",
            "PICOLIBC_DIR": "<install>/picolibc",
            "SNITCH_DEVICE": "snitch_cluster"
        }
    }

Replace ``<install>`` with the directory that holds your toolchain.

