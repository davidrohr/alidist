package: FreeType
version: v2.10.1
requires:
 - AliEn-Runtime:(?!.*ppc64)
build_requires:
  - "autotools:(slc6|slc7)"
  - system-curl
prefer_system: (?!slc5)
prefer_system_check: |
  true
---
#!/bin/bash -ex
URL="http://download.savannah.gnu.org/releases/freetype/freetype-${PKGVERSION:1}.tar.gz"
curl -L -o freetype.tgz $URL
tar xzf freetype.tgz
rm -f freetype.tgz
cd freetype-${PKGVERSION:1}
./configure --prefix=$INSTALLROOT                \
            --with-png=no                        \
            ${ZLIB_ROOT:+--with-zlib=$ZLIB_ROOT}

make ${JOBS:+-j$JOBS}
make install

# Modulefile
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
module load BASE/1.0 $([[ "$ALIEN_RUNTIME_VERSION" ]] && echo AliEn-Runtime/$ALIEN_RUNTIME_VERSION-$ALIEN_RUNTIME_REVISION || echo ${ZLIB_REVISION:+zlib/$ZLIB_VERSION-$ZLIB_REVISION})
# Our environment
set FREETYPE_ROOT \$::env(BASEDIR)/$PKGNAME/\$version
setenv FREETYPE_ROOT \$FREETYPE_ROOT
prepend-path PATH \$FREETYPE_ROOT/bin
prepend-path LD_LIBRARY_PATH \$FREETYPE_ROOT/lib
EoF
