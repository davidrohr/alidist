package: googletest
version: "1.8.0"
source: https://github.com/google/googletest
tag: release-1.8.0
prefer_system: .*
prefer_system_check: |
  true
build_requires:
 - "GCC-Toolchain:(?!osx)"
 - CMake
---
#!/bin/sh
cmake $SOURCEDIR                           \
      -DCMAKE_INSTALL_PREFIX=$INSTALLROOT

make ${JOBS+-j $JOBS}
make install
