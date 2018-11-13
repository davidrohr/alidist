package: CLHEP
version: "2.2.0.8"
source: https://github.com/alisw/clhep
prefer_system: .*
prefer_system_check: |
  true
tag: CLHEP_2_2_0_8
---
#!/bin/sh
cmake $SOURCEDIR \
  -DCMAKE_INSTALL_PREFIX:PATH="$INSTALLROOT"
  
make ${JOBS+-j $JOBS}
make install
