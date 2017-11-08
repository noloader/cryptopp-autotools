## configure.ac - Autotools configuration file for Crypto++.
##                written and placed in public domain by Jeffrey Walton.
##                based on Debian configure.ac by László Böszörményi.
##

## Visit the link below for the original Debian Autotools files
##   https://sources.debian.net/src/libcrypto++/5.6.4-8/debian/autotools/
##

## TODO
##
## - Figure out how to make Autoconf stop using the fucking C compiler for tasks.
##   The damn tool does not honor AC_PROG_CXX or observe the absence of AC_PROG_CC. It also
##   fails to provide a AC_PROG_NO_CC macro. The damn tool is no better than Cmake.
##
## - Fix Autoconf using the wrong AR and ARFLAGS on platforms like OS X.
##   Also see https://lists.gnu.org/archive/html/bug-autoconf/2017-11/msg00002.html.
##
## - Stop using local.h, and write the config data into a Crypto++ compatible config.h. There's not
##   much to "Crypto++ compatible config.h". We need test and write preprocessor macros like
##   IS_BIG_ENDIAN, IS_LITTLE_ENDIAN, CRYPTOPP_CXX11, etc.
##
## - Fix compile tests on Solaris using SunCC. AC_COMPILE_IFELSE returns success even for failure.
##
## - Add ubsan and asan targets for testing.
##
## - Setup test environment with Dash, which appears to be the lamest shell
##

#############################################################################
AC_INIT([Crypto++], [6.0], [http://www.cryptopp.com/wiki/Bug_Report], [cryptopp], [http://www.cryptopp.com])
AM_INIT_AUTOMAKE

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_FILES([Makefile] [libcryptopp.pc])
AC_CONFIG_SRCDIR([configure.ac])
AC_CONFIG_HEADERS([local.h])

AC_PROG_LIBTOOL
LT_INIT

AC_PROG_CXX
AC_LANG([C++])
AC_PROG_CXXCPP
AC_PROG_GREP

AC_ENABLE_SHARED
AC_ENABLE_STATIC

## Assert this once to avoid surprises
AC_LANG_ASSERT([C++])

#############################################################################

## Determine the CPU and OS of the machine we are building for.
## Most people call this the target machine, but not Autotools.

AC_CANONICAL_HOST

## These are some variables that help us track platform and compiler.
## It speeds up configuration by adding some intelligence to the
## test selection process. It also avoids failed configurations by
## avoiding some tests that fail but Autotools reports as success.

IS_SUN_OS=`uname -s | $EGREP -i -c 'SunOS'`
IS_APPLE_OS=`echo "$build" | $EGREP -i -c 'apple'`
IS_ANDROID_OS=`echo $build | $EGREP -i -c -E 'android'`
IS_CYGWIN_OS=`echo $build | $EGREP -i -c -E 'cygwin'`

IS_IA32=`echo $build | $EGREP -i -c -E 'i.86|x86_64|amd64'`
IS_ARM32=`echo $build | $EGREP -i -c 'arm'`
IS_AARCH64=`echo $build | $EGREP -i -c -E 'aarch32|aarch64'`

#############################################################################

## Determine the compiler's target. GCC '-dumpmachine' is the build target,
## so it represents what the compiler is building for (and not what its
## running on). We add '2>/dev/null' because IBM's xlC dumps the man page
## when presented with '-dumpmachine' since it is not a valid option.

COMPILER_TARGET=`"$CXX" -dumpmachine 2>/dev/null`

## Determine the compiler's vendor. We need to work around some Autoconf bugs.

COMPILER_VERSION=`"$CXX" --version 2>/dev/null | head -n 1`

## IBM xlC test if COMPILER_VERSION is empty
if test x"$COMPILER_VERSION" = "x"; then
   COMPILER_VERSION=`"$CXX" -qversion 2>/dev/null | head -n 1`
fi

## SunCC test if COMPILER_VERSION is empty
if test x"$COMPILER_VERSION" = "x"; then
   COMPILER_VERSION=`"$CXX" -V 2>&1 | head -n 1`
fi

IS_SUN_COMPILER=`echo $COMPILER_VERSION | $EGREP -i -c -E 'Sun C\+\+'`

##echo "**********************************************"
##echo "    Build triplet: $build"
##echo "         Build OS: $build_os"
##echo "  Compiler target: $COMPILER_TARGET"
##echo " Compiler version: $COMPILER_VERSION"
##echo "**********************************************"

#############################################################################
## pthreads for thread local storage

AC_ARG_ENABLE(tls,
   AS_HELP_STRING([--enable-tls], [enable thread storage (default is yes)]),
   ac_enable_tls=$enableval,
   ac_enable_tls=yes)
AM_CONDITIONAL(HAS_PTHREADS, test $ac_enable_tls = yes)

## Hack: Use IS_SUN_COMPILER because AC_COMPILE_IFELSE misdetects the flag
if test "$ac_enable_tls" = "yes"; then
if test "$IS_SUN_COMPILER" -eq "0"; then

   SAVED_CXXFLAGS="$CXXFLAGS"
   CXXFLAGS="-pthread"
   AC_MSG_CHECKING([for C++ compiler pthread support])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_FAILURE(["--enable-tls=yes but pthreads are not available"])]
   )
   AC_MSG_CHECKING([for linker pthread support])
   AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_FAILURE(["--enable-tls=yes but pthreads are not available"])]
   )
   # AC_MSG_FAILURE stops the configure process
   AM_CXXFLAGS="$AM_CXXFLAGS -pthread"
   AM_LDFLAGS="$AM_LDFLAGS -pthread"
   CXXFLAGS="$SAVED_CXXFLAGS"
fi
fi

#############################################################################
## Big endian/little endian

AC_C_BIGENDIAN(
  AC_DEFINE(IS_BIG_ENDIAN, 1, [machine is big-endian]),
  AC_DEFINE(IS_LITTLE_ENDIAN, 1, [machine is little-endian]),
  AC_MSG_ERROR(unknown endianess),
  AC_MSG_ERROR(universial endianess not supported)
)

#############################################################################
## Fix AR on iOS and OS X

## AR and ARFLAGS usage is currently broke under Autotools. Also see
## https://lists.gnu.org/archive/html/bug-autoconf/2017-11/msg00002.html

#if test "$IS_APPLE_OS" -ne "0"; then
#   AC_SUBST([AR], ["/usr/bin/libtool"])
#   AC_SUBST([ARFLAGS], ["-static -o"])
#   AC_SUBST([ac_ct_AR], ["/usr/bin/libtool"])
#fi

#############################################################################
## Dead code stripping

if true; then

   ## Save FLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"
   SAVED_LDFLAGS="$LDFLAGS"

   CXXFLAGS="-fdata-sections"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
   fi

   CXXFLAGS="-ffunction-sections"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
   fi

   ## -Wl,-dead_strip is an OS X.
   if test "$IS_APPLE_OS" -ne "0"; then

      LDFLAGS="-Wl,-dead_strip"
      AC_MSG_CHECKING([if $LD supports $LDFLAGS])
      AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
         [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
         [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
      )

      if test "$tr_RESULT" -eq "1"; then
         AM_LDFLAGS="$AM_LDFLAGS $LDFLAGS"
      fi

   else

      LDFLAGS="-Wl,--gc-sections"
      AC_MSG_CHECKING([if $LD supports $LDFLAGS])
      AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
         [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
         [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
      )

      if test "$tr_RESULT" -eq "1"; then
         AM_LDFLAGS="$AM_LDFLAGS $LDFLAGS"
      fi

   fi

   # Restore FLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
   LDFLAGS="$SAVED_LDFLAGS"
fi

#############################################################################
## Solaris, GCC and -Wa,--divide

if test "$IS_SUN_OS" -ne "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   CXXFLAGS="-Wa,--divide"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
   fi

   # Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## Newlib and _XOPEN_SOURCE

if true; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   ## This test may need to be changed if the Newlib folks provide directions.
   ## Also see https://www.sourceware.org/ml/newlib/2017/msg01095.html.

   AC_MSG_CHECKING([if runtime library is Newlib])
   AC_PREPROC_IFELSE([AC_LANG_PROGRAM([#include <_newlib_version.h>])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then

      CXXFLAGS="-D_XOPEN_SOURCE=600"
      AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
      AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
         [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
         [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
      )

      if test "$tr_RESULT" -eq "1"; then
         AC_DEFINE([_XOPEN_SOURCE], [600],
            [Define to 600 if you are using Newlib as your runtime library.])
         AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
      fi
   fi

   # Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## Disable DLL's and shared objects on Windows

if true; then

   ## https://stackoverflow.com/a/21455267/608639
   case $host_os in
      msys* | mingw* | cygwin* )
         AC_MSG_RESULT([checking if shared libraries should be enabled... no])
         enable_shared=no; enable_static=yes ;;
   esac
fi

#############################################################################
## Solaris, map file and libraries

if test "$IS_SUN_OS" -ne "0"; then

   ## Save LDFLAGS
   SAVED_LDFLAGS="$LDFLAGS"

   ## IA-32 gets a Mapfile for capabilities
if test "$IS_IA32" -ne "0"; then
   LDFLAGS="-M cryptopp.mapfile"
   AC_MSG_CHECKING([if $LD supports $LDFLAGS])
   AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AM_LDFLAGS="$AM_LDFLAGS $LDFLAGS"
   fi
fi

   LDFLAGS="-lnsl"
   AC_MSG_CHECKING([if $LD supports $LDFLAGS])
   AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AM_LDFLAGS="$AM_LDFLAGS $LDFLAGS"
   fi

   LDFLAGS="-lsocket"
   AC_MSG_CHECKING([if $LD supports $LDFLAGS])
   AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AM_LDFLAGS="$AM_LDFLAGS $LDFLAGS"
   fi

   # Restore LDFLAGS
   LDFLAGS="$SAVED_LDFLAGS"
fi

#############################################################################
## IA-32, i386, i586, i686, x86_64, etc.

## We are kind of screwed on some platforms because AC_COMPILE_IFELSE fails to
## detect "illegal option". The SunCC compiler literally generates and prints
## the message, but Autoconf ignores it and reports the option is valid.

## This block handles GCC and friends. i86pc and SunCC is handled after this block
if test "$IS_IA32" -ne "0" && test "$IS_SUN_COMPILER" -eq "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   ## Flags not conditionally set below
   AC_SUBST([CRYPTOPP_CRYPTLIB_FLAG])
   AC_SUBST([CRYPTOPP_INTEGER_FLAG])
   AC_SUBST([CRYPTOPP_PPC_FLAG])

   ## cpu.cpp
   CXXFLAGS="-msse2"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_CPU_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_SSE2_AVAILABLE], [1],
         [Define to 1 if you have IA-32 SSE2 instructions available.])
   else
      AC_SUBST([CRYPTOPP_CPU_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_ASM], [1],
         [Define to 1 if you do not have IA-32 SSE2 instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ASM"
   fi

   CXXFLAGS="-mssse3"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_ARIA_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_SSSE3_AVAILABLE], [1],
         [Define to 1 if you have IA-32 SSSE3 instructions available.])
   else
      AC_SUBST([CRYPTOPP_ARIA_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_SSSE3], [1],
         [Define to 1 if you do not have IA-32 SSSE3 instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SSSE3"
   fi

   CXXFLAGS="-msse4.1"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_DEFINE([CRYPTOPP_SSE41_AVAILABLE], [1],
         [Define to 1 if you have IA-32 SSE4.1 instructions available.])
   else
      AC_DEFINE([CRYPTOPP_DISABLE_SSE4], [1],
         [Define to 1 if you do not have IA-32 SSE4.1 instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SSE4"
   fi

   CXXFLAGS="-msse4.2"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_BLAKE2_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_CRC_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_SSE42_AVAILABLE], [1],
         [Define to 1 if you have IA-32 SSE4.2 instructions available.])
   else
      AC_SUBST([CRYPTOPP_BLAKE2_FLAG])
      AC_SUBST([CRYPTOPP_CRC_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_SSE4], [1],
         [Define to 1 if you do not have IA-32 SSE4.2 instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SSE4"
   fi

   CXXFLAGS="-mssse3 -mpclmul"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_GCM_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_CLMUL_AVAILABLE], [1],
         [Define to 1 if you have IA-32 CLMUL instructions available.])
   else
      AC_SUBST([CRYPTOPP_GCM_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_CLMUL], [1],
         [Define to 1 if you do not have IA-32 CLMUL instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_CLMUL"
   fi

   CXXFLAGS="-msse4.1 -maes"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_AES_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_AESNI_AVAILABLE], [1],
         [Define to 1 if you have IA-32 AES-NI instructions available.])
   else
      AC_SUBST([CRYPTOPP_AES_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_AESNI], [1],
         [Define to 1 if you do not have IA-32 AES-NI instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_AESNI"
   fi

   CXXFLAGS="-msse4.2 -msha"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_SHA_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_SHANI_AVAILABLE], [1],
         [Define to 1 if you have IA-32 SHA instructions available.])
   else
      AC_SUBST([CRYPTOPP_SHA_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_SHANI], [1],
         [Define to 1 if you do not have IA-32 SHA instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SHANI"
   fi

   # Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

## This block handles i86pc and SunCC. GCC and friends were handled before this block
if test "$IS_IA32" -ne "0" && test "$IS_SUN_COMPILER" -ne "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   ## Flags not conditionally set below
   AC_SUBST([CRYPTOPP_CRYPTLIB_FLAG])
   AC_SUBST([CRYPTOPP_INTEGER_FLAG])
   AC_SUBST([CRYPTOPP_PPC_FLAG])

   CXXFLAGS="-xarch=sse2"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_CPU_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_SSE2_AVAILABLE], [1],
         [Define to 1 if you have IA-32 SSE2 instructions available.])
      AM_LDFLAGS="$AM_LDFLAGS -xarch=sse2"
   else
      AC_SUBST([CRYPTOPP_CPU_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_ASM], [1],
         [Define to 1 if you do not have IA-32 SSE2 instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ASM"
   fi

   CXXFLAGS="-xarch=ssse3"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_ARIA_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_SSSE3_AVAILABLE], [1],
         [Define to 1 if you have IA-32 SSSE3 instructions available.])
      AM_LDFLAGS="$AM_LDFLAGS -xarch=ssse3"
   else
      AC_SUBST([CRYPTOPP_ARIA_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_SSSE3], [1],
         [Define to 1 if you do not have IA-32 SSSE3 instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SSSE3"
   fi

   CXXFLAGS="-xarch=sse4_1"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_DEFINE([CRYPTOPP_SSE41_AVAILABLE], [1],
         [Define to 1 if you have IA-32 SSE4.1 instructions available.])
      AM_LDFLAGS="$AM_LDFLAGS -xarch=sse4_1"
   else
      AC_DEFINE([CRYPTOPP_DISABLE_SSE4], [1],
         [Define to 1 if you do not have IA-32 SSE4.1 instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SSE4"
   fi
   
   CXXFLAGS="-xarch=sse4_2"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_CRC_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_BLAKE2_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_SSE42_AVAILABLE], [1],
         [Define to 1 if you have IA-32 SSE42 instructions available.])
      AM_LDFLAGS="$AM_LDFLAGS -xarch=sse4_2"
   else
      AC_SUBST([CRYPTOPP_CRC_FLAG])
      AC_SUBST([CRYPTOPP_BLAKE2_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_SSE4], [1],
         [Define to 1 if you do not have IA-32 SSE4.2 instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SSE4"
   fi

   CXXFLAGS="-xarch=aes"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_GCM_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_AES_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_CLMUL_AVAILABLE], [1],
         [Define to 1 if you have IA-32 CLMUL instructions available.])
      AC_DEFINE([CRYPTOPP_AESNI_AVAILABLE], [1],
         [Define to 1 if you have IA-32 AES-NI instructions available.])
      AM_LDFLAGS="$AM_LDFLAGS -xarch=aes"
   else
      AC_SUBST([CRYPTOPP_GCM_FLAG])
      AC_SUBST([CRYPTOPP_AES_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_CLMUL], [1],
         [Define to 1 if you do not have IA-32 CLMUL instructions available.])
      AC_DEFINE([CRYPTOPP_DISABLE_AESNI], [1],
         [Define to 1 if you do not have IA-32 AES-NI instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_AESNI"
   fi

## Hack: disable -xarch=sha for the moment; enable the defines
if false; then
   CXXFLAGS="-xarch=sha"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_SHA_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_SHA_AVAILABLE], [1],
         [Define to 1 if you have IA-32 SHA-NI instructions available.])
      AM_LDFLAGS="$AM_LDFLAGS -xarch=sha"
   else
      AC_SUBST([CRYPTOPP_SHA_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_SHANI], [1],
         [Define to 1 if you do not have IA-32 SHA instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SHANI"
   fi
else
   AC_SUBST([CRYPTOPP_SHA_FLAG])
   AC_DEFINE([CRYPTOPP_DISABLE_SHANI], [1],
      [Define to 1 if you do not have IA-32 SHA instructions available.])
   AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SHANI"
fi

   # Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## ARM A-32, including NEON, soft floats and hard floats

if test "$IS_ARM32" -ne "0" && test "$IS_ANDROID_OS" -ne "0"; then
   AC_MSG_ERROR(["Android is not ready. Ping noloader, gmail to move it along."])
fi

if test "$IS_ARM32" -ne "0" && test "$IS_ANDROID_OS" -eq "0"; then

   ## Most Linux are hard-float systems.
   IS_ARMHF=`echo $build | $EGREP -i -c -E 'armhf|arm7l|gnueabihf'`
   if test "$IS_ARMHF" -ne "0"; then
      AC_MSG_NOTICE([ARM hard-floats detected, using -mfloat-abi=hard.])
      FP_FLAG="hard"
   else
      AC_MSG_NOTICE([ARM soft-floats detected, using -mfloat-abi=softfp.])
      FP_FLAG="softfp"
   fi

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   ## Flags not conditionally set below
   AC_SUBST([CRYPTOPP_CRYPTLIB_FLAG])
   AC_SUBST([CRYPTOPP_CPU_FLAG])
   AC_SUBST([CRYPTOPP_INTEGER_FLAG])
   AC_SUBST([CRYPTOPP_CRC_FLAG])
   AC_SUBST([CRYPTOPP_PPC_FLAG])
   AC_SUBST([CRYPTOPP_AES_FLAG])
   AC_SUBST([CRYPTOPP_SHA_FLAG])

   CXXFLAGS="-march=armv7-a -mfloat-abi=$FP_FLAG -mfpu=neon"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_ARIA_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_BLAKE2_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_GCM_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_NEON_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_ARM_NEON_AVAILABLE], [1],
         [Define to 1 if you have the NEON instructions available.])
   else
      AC_SUBST([CRYPTOPP_ARIA_FLAG])
      AC_SUBST([CRYPTOPP_BLAKE2_FLAG])
      AC_SUBST([CRYPTOPP_GCM_FLAG])
      AC_SUBST([CRYPTOPP_NEON_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_ASM], [1],
         [Define to 1 if you do not have ARM NEON instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ASM"
   fi

   # Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## ARM Aarch32 and Aarch64

if test "$IS_AARCH64" -ne "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   ## Flags not conditionally set below
   AC_SUBST([CRYPTOPP_CRYPTLIB_FLAG])
   AC_SUBST([CRYPTOPP_CPU_FLAG])
   AC_SUBST([CRYPTOPP_INTEGER_FLAG])
   AC_SUBST([CRYPTOPP_PPC_FLAG])

   ## aria-simd.cpp, blake2-simd.cpp, neon-simd.cpp
   CXXFLAGS="-march=armv8-a"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_ARIA_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_BLAKE2_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_NEON_FLAG], [$CXXFLAGS])
   else
      AC_SUBST([CRYPTOPP_ARIA_FLAG])
      AC_SUBST([CRYPTOPP_BLAKE2_FLAG])
      AC_SUBST([CRYPTOPP_NEON_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_ASM], [1],
         [Define to 1 if you do not have ARM NEON instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ASM"
   fi

   ## crc-simd.cpp
   CXXFLAGS="-march=armv8-a+crc"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_CRC_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_ARM_CRC32_AVAILABLE], [1],
         [Define to 1 if you have ARMv8-a CRC32 instructions available.])
   else
      AC_DEFINE([CRYPTOPP_DISABLE_CRC32], [1],
         [Define to 1 if you do not have ARMv8-a CRC32 instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ARM_CRC32"
   fi

   ## gcm-simd.cpp, rijndael-simd.cpp, sha-simd.cpp
   CXXFLAGS="-march=armv8-a+crypto"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_GCM_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_AES_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SHA_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_ARM_PMULL_AVAILABLE], [1],
         [Define to 1 if you have ARMv8-a PMULL instructions available.])
      AC_DEFINE([CRYPTOPP_ARM_AES_AVAILABLE], [1],
         [Define to 1 if you have ARMv8-a AES instructions available.])
      AC_DEFINE([CRYPTOPP_ARM_SHA_AVAILABLE], [1],
         [Define to 1 if you have ARMv8-a SHA instructions available.])
   else
      AC_SUBST([CRYPTOPP_GCM_FLAG])
      AC_SUBST([CRYPTOPP_AES_FLAG])
      AC_SUBST([CRYPTOPP_SHA_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_ARM_PMULL], [1],
         [Define to 1 if you do not have ARMv8-a PMULL instructions available.])
      AC_DEFINE([CRYPTOPP_DISABLE_ARM_AES], [1],
         [Define to 1 if you do not have ARMv8-a AES instructions available.])
      AC_DEFINE([CRYPTOPP_DISABLE_ARM_SHA], [1],
         [Define to 1 if you do not have ARMv8-a SHA instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ARM_PMULL"
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ARM_AES"
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ARM_SHA"
   fi

   # Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## PowerPC and PowerPC-64

IS_PPC=`echo $build | $EGREP -i -c -E 'ppc|powerpc|powermac'`
if test "$IS_PPC" -ne "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   ## Flags not conditionally set below
   AC_SUBST([CRYPTOPP_CRYPTLIB_FLAG])
   AC_SUBST([CRYPTOPP_CPU_FLAG])
   AC_SUBST([CRYPTOPP_INTEGER_FLAG])
   AC_SUBST([CRYPTOPP_ARIA_FLAG])
   AC_SUBST([CRYPTOPP_BLAKE2_FLAG])
   AC_SUBST([CRYPTOPP_GCM_FLAG])
   AC_SUBST([CRYPTOPP_NEON_FLAG])

   ## ppc-simd.cpp, gcm-simd.cpp, rijndael-simd.cpp, sha-simd.cpp
   ## Altivec needs Power4, but the VSX loads and stores needs Power7.
   CXXFLAGS="-maltivec -mcpu=power8"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([tr_RESULT], [1])],
      [AC_MSG_RESULT([no]);  AC_SUBST([tr_RESULT], [0])]
   )

   if test "$tr_RESULT" -eq "1"; then
      AC_SUBST([CRYPTOPP_PPC_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_CRC_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_AES_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SHA_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_POWER7_AVAILABLE], [1],
         [Define to 1 if you have POWER7 instructions available.])
      AC_DEFINE([CRYPTOPP_POWER8_AVAILABLE], [1],
         [Define to 1 if you have POWER8 instructions available.])
      AC_DEFINE([CRYPTOPP_POWER8_CRC_AVAILABLE], [1],
         [Define to 1 if you have POWER8 Crypto instructions available.])
      AC_DEFINE([CRYPTOPP_POWER8_AES_AVAILABLE], [1],
         [Define to 1 if you have POWER8 Crypto instructions available.])
      AC_DEFINE([CRYPTOPP_POWER8_SHA_AVAILABLE], [1],
         [Define to 1 if you have POWER8 Crypto instructions available.])
   else
      AC_SUBST([CRYPTOPP_PPC_FLAG])
      AC_SUBST([CRYPTOPP_CRC_FLAG])
      AC_SUBST([CRYPTOPP_AES_FLAG])
      AC_SUBST([CRYPTOPP_SHA_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_POWER8_CRC], [1],
         [Define to 1 if you do not have the Power8 PMULL instructions available.])
      AC_DEFINE([CRYPTOPP_DISABLE_POWER8_AES], [1],
         [Define to 1 if you do not have the Power8 AES instructions available.])
      AC_DEFINE([CRYPTOPP_DISABLE_POWER8_SHA], [1],
         [Define to 1 if you do not have the Power8 SHA instructions available.])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_POWER8_CRC"
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_POWER8_AES"
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_POWER8_SHA"
   fi

   # Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## Other fodder

## Add -pipe for non-IoT gadgets to speedup the compile. IoT gadgets, like
## BeagleBoards and CubieTrucks, don't have swap files and run out of memory.
## Hack: Use IS_SUN_COMPILER because AC_COMPILE_IFELSE misdetects the flag

if test "$IS_IA32" -ne "0" || test "$IS_AARCH64" -ne "0" || test "$IS_PPC" -ne "0"; then
if test "$IS_SUN_COMPILER" -eq "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   CXXFLAGS="-pipe"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_PIPE], [$CXXFLAGS])]
   )

   if test "$CRYPTOPP_PIPE" = "$CXXFLAGS"; then
      AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
   fi

   # Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi
fi

## Without this 'make' uses out GNUmakefile, and not Makefile
AC_CONFIG_COMMANDS_PRE([rm -f GNUmakefile 2>/dev/null])
AC_CONFIG_COMMANDS_PRE([rm -f GNUmakefile-cross 2>/dev/null])

## Write the Automake flags we set
AC_SUBST([AM_CXXFLAGS])
AC_SUBST([AM_LDFLAGS])

## Write the output artifacts
AC_OUTPUT

## Automake bug workaround. If libcryptopp_la_SOURCES is an empty list, Automake assumes
## C source files and drive link through the C compiler. We provide the empty adhoc.cpp
## to get things back on course, so adhoc.cpp must always be copied.

AC_CONFIG_COMMANDS_POST([cp adhoc.cpp.proto adhoc.cpp])

#############################################################################
## Print a summary of information

echo ""
echo "***********************************************************************"
echo "Auto-configuration complete. A summary of options are below. If "
echo "something looks wrong then please modify config.h and please report it"
echo "at https://github.com/noloader/cryptopp-autotools."
echo ""

if test x"$CRYPTOPP_CPU_FLAG" != "x"; then
   echo "CRYPTOPP_CPU_FLAG: $CRYPTOPP_CPU_FLAG"
fi
if test x"$CRYPTOPP_NEON_FLAG" != "x"; then
   echo "CRYPTOPP_NEON_FLAG: $CRYPTOPP_NEON_FLAG"
fi
if test x"$CRYPTOPP_PPC_FLAG" != "x"; then
   echo "CRYPTOPP_PPC_FLAG: $CRYPTOPP_PPC_FLAG"
fi
if test x"$CRYPTOPP_ARIA_FLAG" != "x"; then
   echo "CRYPTOPP_ARIA_FLAG: $CRYPTOPP_ARIA_FLAG"
fi
if test x"$CRYPTOPP_BLAKE2_FLAG" != "x"; then
   echo "CRYPTOPP_BLAKE2_FLAG: $CRYPTOPP_BLAKE2_FLAG"
fi
if test x"$CRYPTOPP_CRC_FLAG" != "x"; then
   echo "CRYPTOPP_CRC_FLAG: $CRYPTOPP_CRC_FLAG"
fi
if test x"$CRYPTOPP_AES_FLAG" != "x"; then
   echo "CRYPTOPP_AES_FLAG: $CRYPTOPP_AES_FLAG"
fi
if test x"$CRYPTOPP_SHA_FLAG" != "x"; then
   echo "CRYPTOPP_SHA_FLAG: $CRYPTOPP_SHA_FLAG"
fi

echo ""
echo "Automake flags (can be overridden by user flags):"
echo "AM_CXXFLAGS: $AM_CXXFLAGS"
echo "AM_LDFLAGS: $AM_LDFLAGS"

echo ""
echo "User flags (overrides Automake flags on conflict):"
echo "CXXFLAGS: $CXXFLAGS"
echo "LDFLAGS: $LDFLAGS"
echo "***********************************************************************"
echo ""
