package: OpenSSL
version: v1.0.2o
tag: OpenSSL_1_0_2o
source: https://github.com/openssl/openssl
prefer_system: (?!slc5|slc6)
prefer_system_check: |
  true
build_requires:
 - zlib
 - "GCC-Toolchain:(?!osx)"
---
#!/bin/bash -e

rsync -av --delete --exclude="**/.git" $SOURCEDIR/ .

./config --prefix="$INSTALLROOT"                   \
         --openssldir="$INSTALLROOT/etc/ssl"       \
         --libdir=lib                              \
         zlib                                      \
         no-idea                                   \
         no-mdc2                                   \
         no-rc5                                    \
         no-ec                                     \
         no-ecdh                                   \
         no-ecdsa                                  \
         no-asm                                    \
         no-krb5                                   \
         shared                                    \
         -fno-strict-aliasing                      \
         -L"$INSTALLROOT/lib"                      \
         -Wa,--noexecstack
make depend
make  # don't ever try to build in multicore
make install_sw # no not install man pages

# Remove static libraries and pkgconfig
rm -rf $INSTALLROOT/lib/pkgconfig \
       $INSTALLROOT/lib/*.a


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
module load BASE/1.0 ${ZLIB_REVISION:+zlib/$ZLIB_VERSION-$ZLIB_REVISION} ${GCC_TOOLCHAIN_ROOT:+GCC-Toolchain/$GCC_TOOLCHAIN_VERSION-$GCC_TOOLCHAIN_REVISION}
# Our environment
set OPENSSL_ROOT \$::env(BASEDIR)/$PKGNAME/\$version
setenv OPENSSL_ROOT \$OPENSSL_ROOT
prepend-path PATH \$OPENSSL_ROOT/bin
prepend-path LD_LIBRARY_PATH \$OPENSSL_ROOT/lib
EoF
