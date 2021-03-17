package: RapidJSON
version: v1.1.0-alice2
tag: 091de040edb3355dcf2f4a18c425aec51b906f08
source: https://github.com/Tencent/rapidjson.git
build_requires:
  - CMake
prefer_system: .*
prefer_system_check: |
  true
---
#!/bin/sh

cmake $SOURCEDIR                                                       \
      -DCMAKE_INSTALL_PREFIX=$INSTALLROOT                     \
      -DCMAKE_CXX_FLAGS="-Wno-error=implicit-fallthrough -Wno-error=class-memaccess"

make ${JOBS:+-j$JOBS} install

MODULEDIR="$INSTALLROOT/etc/modulefiles"
MODULEFILE="$MODULEDIR/$PKGNAME"
mkdir -p "$MODULEDIR"
cat > "$MODULEFILE" <<EoF
#%Module1.0
proc ModulesHelp { } {
  global version
  puts stderr "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
}
set version $PKGVERSION-@@PKGREVISION@$PKGHASH@@
module-whatis "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
# Dependencies
module load BASE/1.0
# Our environment
EoF
