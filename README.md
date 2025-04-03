# Snitch-SDK

This repository contains the Snitch-SDK, a stand-alone library for programming flavors of the [Snitch cluster](https://github.com/pulp-platform/snitch_cluster/tree/main). The SDK provides a runtime environment for developing and deploying applications on various configurations of the Snitch cluster. It includes the core runtime, parallel programming (OMP) support, and different simulation targets (RTL, [Banshee](https://github.com/pulp-platform/banshee)).

The Snitch cluster and the Snitch-SDK are developed as part of the [PULP project](https://github.com/pulp-platform), a joint effort between ETH Zurich and the University of Bologna.

## License

Unless specified otherwise in the respective file headers, all code checked into this repository is made available under a permissive license. All software sources are licensed under Apache 2.0 (see LICENSE) or compatible licenses, with the exception of `scripts/run_clang_format.py`, which is licensed under the MIT license.

## Documentation

All revelevant documentation can be found in the docs folder and is hosted on GitHub Pages. Access the documentation on

* [Master Branch](https://pulp-platform.github.io/snitch-sdk/)
* [Devel Branch](https://pulp-platform.github.io/snitch-sdk/branch/devel)

The documentation for a specific branch can be accessed via `https://pulp-platform.github.io/snitch-sdk/branch/<branch>`.

## Contributing


### Formatting

To simplify formatting of the code, we provide a Makefiles target that runs clang-format on all source files. We recomment that you setup a virtual environment and install the required dependencies using the following commands:

```
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Alternatively you can also use any mamba/conda environment.

Then, to format the code, run the following command:

```
make format
```

**The Makefile is only used for utility purposes and not by the build system!**


