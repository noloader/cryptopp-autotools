## configure.ac - Autotools configuration file for Crypto++.
##                written and placed in public domain by Jeffrey Walton.
##                based on Debian configure.ac by László Böszörményi.
##

## Visit the link below for the original Debian Autotools files
##   http://sources.debian.net/src/libcrypto++/5.6.4-8/debian/autotools/
##

## To generate the configure file perform the following. The extra steps are needed
## because the Autotools on some machines, like a PowerMac or Solaris, are not modern
## enough for macros like AC_PROG_LIBTOOL and AC_ENABLE_SHARED.
##
##   autoupdate && libtoolize -fi && autoreconf -fi
##

## TODO
##
## - Figure out how to make Autoconf stop using the fucking C compiler for tasks.
##   The damn tool does not honor AC_PROG_CXX or observe the absence of AC_PROG_CC. It also
##   fails to provide a AC_PROG_NO_CC macro. The damn tool is no better than Cmake.
##
## - Fix Autoconf using the wrong AR and ARFLAGS on platforms like OS X.
##   Also see http://lists.gnu.org/archive/html/bug-autoconf/2017-11/msg00002.html.
##
## - Fix Autoconf ignoring our config.h.in. This one looks like it is a problem without a solution.
##   Also see https://stackoverflow.com/q/48436715/608639
##
## - Stop using local.h, and write the config data into a Crypto++ compatible config.h. There's
##   not much to "Crypto++ compatible config.h". We need test and write preprocessor macros like
##   CRYPTOPP_BIG_ENDIAN, CRYPTOPP_LITTLE_ENDIAN, CRYPTOPP_CXX11, etc. There's just a lot of them.
##   This problem now appears to be closely related to the config.h.in problem. We can't supply a
##   template and expect Autotools to honor it. Also see
##   https://lists.gnu.org/archive/html/autoconf/2018-07/msg00014.html
##
## - Fix incorrect use of --with-sysroot. Autotools does not seem to honor it when it is set.
##   Also see http://stackoverflow.com/q/47226389/608639
##
## - Fix MSYS2 compile error due to `lt-cryptest.c` and `lt-cryptestcwd.c`. They are C files and
##   don't use necessary C++ flags. They also use Posix functions but fail to define _XOPEN_SOURCE.
##   I'm guessing this has something to do with libtool, but I have no idea how to fix it at
##   the moment. Also see http://lists.gnu.org/archive/html/bug-libtool/2017-11/msg00002.html.
##
## - Add ubsan and asan targets for testing.
##
## - Setup test environment with Dash, which appears to be the lamest shell
##
## - Package Autotools propery, for a regular user's definition of "proper". I don't know what the
##   final deliverables or artifacts are supposed to look like. We also get warnings and errors
##   due to a missing m4/ directory even though we don't use it. Maybe we need to distribute an
##   empty m4/ directory to keep the tools quiet.
##

#############################################################################

AC_INIT([Crypto++], [7.1], [http://www.cryptopp.com/wiki/Bug_Report], [cryptopp], [http://www.cryptopp.com])
AM_INIT_AUTOMAKE

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([local.h])
AC_CONFIG_FILES([Makefile] [libcryptopp.pc])
AC_CONFIG_SRCDIR([configure.ac])

AM_PROG_AS
#AC_PROG_LIBTOOL
LT_INIT

AC_PROG_CXX
AC_LANG([C++])
AC_PROG_GREP
AC_PROG_AWK

## Assert this once to avoid surprises
AC_LANG_ASSERT([C++])

## Used for our test compile and link to detect failures. It is more
## robust than Autotools and catches XL C/C++ and SunCC problems.

BAD_RESULT="fatal|error|unknown|unrecognized|illegal|ignored|not found|not exist|cannot find|not supported"

#############################################################################

## Determine the CPU and OS of the machine we are building for.
## Most people call this the target machine, but not Autotools.

AC_CANONICAL_HOST

## These are some variables that help us track platform and compiler.
## It speeds up configuration by adding some intelligence to the
## test selection process. It also avoids failed configurations by
## avoiding some tests that fail but Autotools reports as success.

IS_AIX_OS=`echo $host | $EGREP -i -c -E 'aix'`
IS_SUN_OS=`uname -s | $EGREP -i -c 'SunOS'`
IS_APPLE_OS=`echo "$host" | $EGREP -i -c -E 'apple|darwin'`
IS_ANDROID_OS=`echo $host | $EGREP -i -c -E 'android'`
IS_CYGWIN_OS=`echo $host | $EGREP -i -c -E 'cygwin'`

IS_IA32=`echo $host | $EGREP -i -c -E 'i.86|x86_64|amd64'`
IS_ARM32=`echo $host | $EGREP -i -c 'arm|armhf|arm7l|eabihf'`
IS_AARCH64=`echo $host | $EGREP -i -c -E 'aarch32|aarch64'`
IS_PPC=`echo $host | $EGREP -i -c -E 'ppc|powerpc|powermac'`
IS_SPARC=`echo $host | $EGREP -i -c -E 'sparc|sparcv8|sparcv9|sparc64'`

## Bitness
IS_64BIT=$(getconf LONG_BIT 2>&1 | grep -i -c 64)
if [[ "$IS_64BIT" = "0" ]]; then
    IS_64BIT=$(file /bin/ls 2>&1 | grep -i -c '64-bit')
fi

#############################################################################

## Determine the compiler's target. GCC '-dumpmachine' is the target,
## so it represents what the compiler is building for (and not what its
## running on). We add '2>/dev/null' because IBM's xlC dumps the man page
## when presented with '-dumpmachine' since it is not a valid option.

## See if CXX is valid. Autotools just trucks on with an invalid one.

if test x"$CXX" != "x"; then
   COMPILER_TARGET=`command -v "$CXX"`
   if test x"$COMPILER_TARGET" = "x"; then
      AC_MSG_FAILURE(["$CXX" is not a valid compiler or is not on-path])
   fi
fi

## Compiler is valid. Try to detect the target and vendor.
## SunCC is empty, so we just use $host

COMPILER_TARGET=`"$CXX" -dumpmachine 2>/dev/null`
if test -z "$COMPILER_TARGET"; then
   COMPILER_TARGET="$host"
fi

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

IS_GCC_COMPILER=`echo $COMPILER_VERSION | $EGREP -i -v 'Clang' | $EGREP -i -c -E 'GCC|G\+\+'`
IS_LLVM_COMPILER=`echo $COMPILER_VERSION | $EGREP -i -c -E 'LLVM|Clang'`
IS_SUN_COMPILER=`echo $COMPILER_VERSION | $EGREP -i -c -E 'Sun C\+\+'`
IS_ICC_COMPILER=`echo $COMPILER_VERSION | $EGREP -i -c 'ICC'`
IS_XLC_COMPILER=`echo $COMPILER_VERSION | $EGREP -i -c -E 'IBM XL C/C\+\+'`
IS_MACPORTS_COMPILER=`echo $COMPILER_VERSION | $EGREP -i -c -E 'MacPorts'`

## A catch-all for compilers that claim to be GCC compatible. Each should be
## able to handle GCC syntax. It excludes XLC, SunCC and MSVC
if test "$IS_GCC_COMPILER" != "0" || test "$IS_LLVM_COMPILER" != "0" || \
   test "$IS_ICC_COMPILER" != "0"; then
   IS_GNUC_COMPILER=1
else
   IS_GNUC_COMPILER=0
fi

## Friendly names for reporting
CXXNAME=`basename "$CXX"`
LDNAME=`basename "$LD"`

## Small fixup
case "$LDNAME" in
	"ld "*) LDNAME=ld
	;;
esac

#############################################################################

## An improved AC_COMPILE_IFELSE and XXX_LINK_IFELSE.
## Also see http://stackoverflow.com/q/47160617/608639 and
## http://lists.gnu.org/archive/html/autoconf/2009-03/msg00099.html.

AC_DEFUN([XXX_COMPILE_IFELSE],
   [AC_REQUIRE([AC_PROG_EGREP])
   AC_COMPILE_IFELSE(
      [$1],
      [retval=0
        if $EGREP -i -c -E "$BAD_RESULT" conftest.err >/dev/null; then retval=1; fi
      ],[retval=1]
   )
   AS_IF([test $retval = 0],[$2],[$3])]
)

AC_DEFUN([XXX_LINK_IFELSE],
   [AC_REQUIRE([AC_PROG_EGREP])
   AC_LINK_IFELSE(
      [$1],
      [retval=0
        if $EGREP -i -c -E "$BAD_RESULT" conftest.err >/dev/null; then retval=1; fi
      ],[retval=1]
   )
   AS_IF([test $retval = 0],[$2],[$3])]
)

#############################################################################
## Doxygen documentation
## This only provides a 'make html-doc' recipe in the Makefile.
## If Doxygen is available the user still must issue the command.

AC_CHECK_PROGS([DOXYGEN], [doxygen])
if test -z "$DOXYGEN"; then
   AM_CONDITIONAL([CRYPTOPP_DOXYGEN_AVAILABLE], [false])
else
   AM_CONDITIONAL([CRYPTOPP_DOXYGEN_AVAILABLE], [true])
fi

#############################################################################
## Shared and static libraries

if true; then

   ## Cant use AC_ENABLE_STATIC and AC_ENABLE_SHARED. AIX Autotools is too old.
   AC_MSG_RESULT([checking if static libraries should be enabled... yes])

   ## http://stackoverflow.com/a/21455267/608639
   case $host_os in
      msys* | mingw* | cygwin* )
         AC_MSG_RESULT([checking if shared libraries should be enabled... no])
         enable_shared=no; enable_static=yes;
         ;;
      *)
         AC_MSG_RESULT([checking if shared libraries should be enabled... yes])
         enable_shared=yes; enable_static=yes;
         ;;
   esac
fi

#############################################################################
## Big endian/little endian

AC_C_BIGENDIAN(
  AC_DEFINE(CRYPTOPP_BIG_ENDIAN, 1, [machine is big-endian]),
  AC_DEFINE(CRYPTOPP_LITTLE_ENDIAN, 1, [machine is little-endian]),
  AC_MSG_ERROR([unknown endianess]),
  AC_MSG_ERROR([universial endianess not supported])
)

#############################################################################
## Newlib and _XOPEN_SOURCE

if true; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   ## This test may need to be changed if the Newlib folks provide directions.
   ## Also see http://www.sourceware.org/ml/newlib/2017/msg01095.html.

   XXX_PROGRAM="#include <string>
      int main(int argc, char** argv) {
         #ifndef __NEWLIB__
         #  error
         #endif
         return 0;
      }"

   AC_MSG_CHECKING([whether runtime library is Newlib])
   XXX_COMPILE_IFELSE(
      [AC_LANG_SOURCE([$XXX_PROGRAM])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then

      CXXFLAGS="-D_XOPEN_SOURCE=600"
      AC_MSG_CHECKING([if runtime library supports $CXXFLAGS])
      XXX_COMPILE_IFELSE(
         [AC_LANG_PROGRAM([])],
         [AC_MSG_RESULT([yes])],
         [AC_MSG_RESULT([no])]
      )

      if test "$retval" = "0"; then
         AC_DEFINE([_XOPEN_SOURCE], [600], [Enable _XOPEN_SOURCE])
         AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
      fi
   fi

   ## Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## Pthread library

if true; then

   ## Add to both CXXFLAGS and LDFLAGS if supported.
   ## https://stackoverflow.com/q/2127797/608639.

   SAVED_CXXFLAGS="$CXXFLAGS"

   CXXFLAGS="-pthread"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_LINK_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
      AM_LDFLAGS="$AM_LDFLAGS $CXXFLAGS"
   fi

   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## Solaris, SunCC and missing optimizations

OPT_ANY=`echo $CXXFLAGS | $EGREP -c -E '\-O0|\-O1|\-O2|\-O3|\-O4|\-O5|\-xO0|\-xO1|\-xO2|\-xO3|\-xO4|\-xO5|\-Os|\-Og|\-Ofast'`

if test "$OPT_ANY" = "0"; then

   SAVED_CXXFLAGS="$CXXFLAGS"

   CXXFLAGS="-O2"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
   else

      # SunCC
      CXXFLAGS="-xO2"
      AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
      XXX_COMPILE_IFELSE(
         [AC_LANG_PROGRAM([])],
         [AC_MSG_RESULT([yes])],
         [AC_MSG_RESULT([no])]
      )

      if test "$retval" = "0"; then
         AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
      fi
   fi

   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## Fix AR on iOS and OS X

## AR and ARFLAGS usage is currently broke under Autotools. Also see
## http://lists.gnu.org/archive/html/bug-autoconf/2017-11/msg00002.html

#if test "$IS_APPLE_OS" != "0"; then
#   AC_SUBST([AR], ["/usr/bin/libtool"])
#   AC_SUBST([ARFLAGS], ["-static -o"])
#   AC_SUBST([ac_ct_AR], ["/usr/bin/libtool"])
#fi

#############################################################################
## Dead code stripping for compilers. Linkers are towards the end of script.

if true; then

   ## Save FLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   CXXFLAGS="-fdata-sections"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
   fi

   CXXFLAGS="-ffunction-sections"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
   fi

   ## Restore FLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## Solaris, GCC and -Wa,--divide

if test "$IS_SUN_OS" != "0" && test "$IS_SUN_COMPILER" = "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   CXXFLAGS="-Wa,--divide"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
   fi

   ## Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## MacPorts GCC using Clang integrated assembler

## Modern GCC must use Clang as the assembler. The old
## Apple assembler cannot handle much more than SSE3 or so

if test "$IS_APPLE_OS" != "0"; then
if test "$IS_GCC_COMPILER" != "0" && test "$IS_MACPORTS_COMPILER" != "0"; then

   HAVE_OPT=`echo $CXXFLAGS | $EGREP -i -c -E '\-Wa,-q'`
   if test "$HAVE_OPT" = "0"; then

      ## Save CXXFLAGS
      SAVED_CXXFLAGS="$CXXFLAGS"

      CXXFLAGS="-Wa,-q"
      AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
      XXX_COMPILE_IFELSE(
         [AC_LANG_PROGRAM([])],
         [AC_MSG_RESULT([yes])],
         [AC_MSG_RESULT([no])]
      )

      if test "$retval" = "0"; then
         AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
      fi

      HAVE_OPT=`echo $CXXFLAGS | $EGREP -i -c -E '\-DCRYPTOPP_CLANG_INTEGRATED_ASSEMBLER'`
      if test "$HAVE_OPT" = "1"; then
         AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_CLANG_INTEGRATED_ASSEMBLER=1"
         AC_DEFINE([CRYPTOPP_CLANG_INTEGRATED_ASSEMBLER], [1], [Enable Clang integrated assembler])
      fi

      ## Restore CXXFLAGS
      CXXFLAGS="$SAVED_CXXFLAGS"
   fi
fi
fi

#############################################################################
## Solaris, SunCC compiler options

if test "$IS_SUN_OS" != "0" && test "$IS_SUN_COMPILER" != "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   CXXFLAGS="-template=no%extdef"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
   fi

   ## Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## IA-32, i386, i586, i686, x86_64, etc.

## This block handles GCC and friends. i86pc and SunCC is handled after this block
if test "$IS_IA32" = "1" && test "$IS_GNUC_COMPILER" = "1"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   ## SSE2
   CXXFLAGS="-msse2"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_SSE2_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SSE_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_SSE2_AVAILABLE], [1], [Enable SSE2])
   else
      AC_DEFINE([CRYPTOPP_DISABLE_ASM], [1], [Disable SSE2])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ASM"
   fi

   ## SSSE3
   CXXFLAGS="-mssse3"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_SSSE3_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_ARIA_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_CHAM_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_LEA_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SIMECK_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SIMON_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SPECK_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_SSSE3_AVAILABLE], [1], [Enable SSSE3])
   else
      AC_DEFINE([CRYPTOPP_DISABLE_SSSE3], [1], [Disable SSSE3])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SSSE3"
   fi

   ## SSE4.1. Old BSD linkers don't support it.
   CXXFLAGS="-msse4.1"
   XXX_PROGRAM="#include <smmintrin.h>
      int main(int argc, char** argv) {
         __m128i x;
         x=_mm_blend_epi16 (x,x,0);
         return 0;
      }"

   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_LINK_IFELSE(
      [AC_LANG_SOURCE([$XXX_PROGRAM])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_SSE41_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_BLAKE2_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SIMON_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SPECK_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_SSE41_AVAILABLE], [1], [Enable SSE4.1])
   else
      AC_DEFINE([CRYPTOPP_DISABLE_SSE4], [1], [Disable SSE4.1])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SSE4"
   fi

   ## SSE4.2. Old BSD linkers don't support it.
   CXXFLAGS="-msse4.2"
   XXX_PROGRAM="#include <nmmintrin.h>
      int main(int argc, char** argv) {
         int x = _mm_crc32_u32(10,20);
         return 0;
      }"

   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_LINK_IFELSE(
      [AC_LANG_SOURCE([$XXX_PROGRAM])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_SSE42_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_CRC_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_SSE42_AVAILABLE], [1], [Enable SSE4.2])
   else
      AC_DEFINE([CRYPTOPP_DISABLE_SSE4], [1], [Disable SSE4.2])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SSE4"
   fi

   ## PCLMUL. Some old compilers and linkers don't support it.
   CXXFLAGS="-mssse3 -mpclmul"
   XXX_PROGRAM="#include <wmmintrin.h>
      int main(int argc, char** argv) {
         __m128i x;
         x=_mm_clmulepi64_si128 (x,x,0);
         return 0;
      }"

   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_LINK_IFELSE(
      [AC_LANG_SOURCE([$XXX_PROGRAM])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_GCM_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_CLMUL_AVAILABLE], [1], [Enable CLMUL])
   else
      AC_DEFINE([CRYPTOPP_DISABLE_CLMUL], [1], [Disable CLMUL])
   fi

   ## AES. Some old compilers and linkers don't support it.
   CXXFLAGS="-mssse3 -maes"
   XXX_PROGRAM="#include <wmmintrin.h>
      int main(int argc, char** argv) {
         __m128i x;
         x=_mm_aesenc_si128(x,x);
         x=_mm_aesenclast_si128(x,x);
         return 0;
      }"

   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_LINK_IFELSE(
      [AC_LANG_SOURCE([$XXX_PROGRAM])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_SM4_FLAG], [$CXXFLAGS])
   fi

   ## AES. Some compilers and linkers don't support it.
   CXXFLAGS="-msse4.1 -maes"
   XXX_PROGRAM="#include <wmmintrin.h>
      int main(int argc, char** argv) {
         __m128i x;
         x=_mm_aesenc_si128(x,x);
         x=_mm_aesenclast_si128(x,x);
         return 0;
      }"

   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_LINK_IFELSE(
      [AC_LANG_SOURCE([$XXX_PROGRAM])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_AES_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_AESNI_AVAILABLE], [1], [Enable AESNI])
   else
      AC_DEFINE([CRYPTOPP_DISABLE_AESNI], [1], [Disable AESNI])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_AESNI"
   fi

   ## SHA. Some compilers and linkers don't support it.
   CXXFLAGS="-msse4.2 -msha"
   XXX_PROGRAM="#include <immintrin.h>
      int main(int argc, char** argv) {
         __m128i x;
          x=_mm_sha1rnds4_epu32(x,x,0);
          return 0;
      }"

   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_LINK_IFELSE(
      [AC_LANG_SOURCE([$XXX_PROGRAM])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_SHA_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_SHANI_AVAILABLE], [1], [Enable SHANI])
   else
      AC_DEFINE([CRYPTOPP_DISABLE_SHANI], [1], [Disable SHANI])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SHANI"
   fi

   ## Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

## This block handles i86pc and SunCC. GCC and friends were handled before this block
if test "$IS_IA32" != "0" && test "$IS_SUN_COMPILER" != "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"
   ## SunCC does not pass GCC-like defines through the compiler
   SSE_DEFINES=""

   CXXFLAGS="-xarch=sse2"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   ## GCM AES and SHA should be overwritten with CLMUL, AES and SHA if available.
   ## If not available then need -xarch=sse2 due to SSE2, GCM_Xor16_SSE2, etc.
   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_SSE_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_GCM_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_AES_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SHA_FLAG], [$CXXFLAGS])
      SSE_DEFINES="$SSE_DEFINES -D__SSE2__=1"
      AC_DEFINE([CRYPTOPP_SSE2_AVAILABLE], [1], [Enable SSE2])
      AM_LDFLAGS="$AM_LDFLAGS -xarch=sse2"
   else
      AC_DEFINE([CRYPTOPP_DISABLE_ASM], [1], [Disable SSE2])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ASM"
   fi

   ## Nothing pivots around SSE3 specifically, but we do use
   ## insns from the ISA. Sun requires it as a linker flag.
   CXXFLAGS="-xarch=sse3"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      SSE_DEFINES="$SSE_DEFINES -D__SSE3__=1"
      AC_DEFINE([CRYPTOPP_SSE3_AVAILABLE], [1], [Enable SSE3])
      AM_LDFLAGS="$AM_LDFLAGS -xarch=sse3"
   else
      AC_DEFINE([CRYPTOPP_DISABLE_SSE3], [1], [Disable SSE3])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SSE3"
   fi

   CXXFLAGS="-xarch=ssse3"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_SSSE3_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_ARIA_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_CHAM_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_LEA_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SIMECK_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SIMON_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SPECK_FLAG], [$CXXFLAGS])
      SSE_DEFINES="$SSE_DEFINES -D__SSSE3__=1"
      AC_DEFINE([CRYPTOPP_SSSE3_AVAILABLE], [1], [Enable SSSE3])
      AM_LDFLAGS="$AM_LDFLAGS -xarch=ssse3"
   else
      AC_DEFINE([CRYPTOPP_DISABLE_SSSE3], [1], [Disable SSSE3])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SSSE3"
   fi

   CXXFLAGS="-xarch=sse4_1"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_SSE41_FLAG], [$CXXFLAGS])
      SSE_DEFINES="$SSE_DEFINES -D__SSE4_1__=1"
      AC_DEFINE([CRYPTOPP_SSE41_AVAILABLE], [1], [Enable SSE4.1])
      AM_LDFLAGS="$AM_LDFLAGS -xarch=sse4_1"
   else
      AC_DEFINE([CRYPTOPP_DISABLE_SSE4], [1], [Disable SSE4.1])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SSE4"
   fi

   CXXFLAGS="-xarch=sse4_2"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_SSE42_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_CRC_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_BLAKE2_FLAG], [$CXXFLAGS])
      SSE_DEFINES="$SSE_DEFINES -D__SSE4_2__=1"
      AC_DEFINE([CRYPTOPP_SSE42_AVAILABLE], [1], [Enable SSE4.2])
      AM_LDFLAGS="$AM_LDFLAGS -xarch=sse4_2"
   else
      AC_DEFINE([CRYPTOPP_DISABLE_SSE4], [1], [Disable SSE4.2])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SSE4"
   fi

   XXX_PROGRAM="#include <wmmintrin.h>
      int main(int argc, char** argv) {
         __m128i x;
         x=_mm_aesenc_si128(x,x);
         x=_mm_aesenclast_si128(x,x);
         return 0;
      }"

   CXXFLAGS="-xarch=aes"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_SOURCE([$XXX_PROGRAM])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_GCM_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_AES_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SM4_FLAG], [$CXXFLAGS])
      SSE_DEFINES="$SSE_DEFINES -D__AES__=1"
      AC_DEFINE([CRYPTOPP_CLMUL_AVAILABLE], [1], "Enable CLMUL")
      AC_DEFINE([CRYPTOPP_AESNI_AVAILABLE], [1], "Enable AESNI")
      AM_LDFLAGS="$AM_LDFLAGS -xarch=aes"
   else
      AC_DEFINE([CRYPTOPP_DISABLE_CLMUL], [1], "Disable CLMUL")
      AC_DEFINE([CRYPTOPP_DISABLE_AESNI], [1], "Disable AESNI")
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_CLMUL"
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_AESNI"
   fi

   XXX_PROGRAM="#include <immintrin.h>
      int main(int argc, char** argv) {
         __m128i x;
         x=_mm_sha1rnds4_epu32(x,x,0);
         return 0;
   }"

   CXXFLAGS="-xarch=sha"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_SOURCE([$XXX_PROGRAM])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_SHA_FLAG], [$CXXFLAGS])
      SSE_DEFINES="$SSE_DEFINES -D__SHA__=1"
      AC_DEFINE([CRYPTOPP_SHA_AVAILABLE], [1], "Enable SHANI")
      AM_LDFLAGS="$AM_LDFLAGS -xarch=sha"
   else
      AC_DEFINE([CRYPTOPP_DISABLE_SHANI], [1], "Disable SHANI")
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SHANI"
   fi

   if test x"$SSE_DEFINES" != "x"; then
      AM_CXXFLAGS="$AM_CXXFLAGS $SSE_DEFINES"
   fi

   ## Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## ARM A-32, including NEON, soft floats and hard floats

if test "$IS_ARM32" != "0" && test "$IS_ANDROID_OS" != "0"; then
   AC_MSG_ERROR(["Android is not ready. Ping noloader, gmail to move it along."])
fi

if test "$IS_ARM32" != "0" && test "$IS_ANDROID_OS" = "0"; then

   ## Most Linux are hard-float systems.
   IS_ARMHF=`echo $host | $EGREP -i -c -E 'armhf|arm7l|gnueabihf'`
   if test "$IS_ARMHF" != "0"; then
      #AC_MSG_NOTICE([ARM hard-floats detected, using -mfloat-abi=hard.])
      FP_FLAG="hard"
   else
      #AC_MSG_NOTICE([ARM soft-floats detected, using -mfloat-abi=softfp.])
      FP_FLAG="softfp"
   fi

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   CXXFLAGS="-march=armv7-a -mfloat-abi=$FP_FLAG -mfpu=neon"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_AES_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_ARIA_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_BLAKE2_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_CHAM_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_CRC_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_GCM_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_LEA_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_NEON_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SHA_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SM4_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SIMECK_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SIMON_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SPECK_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_ARM_NEON_AVAILABLE], [1], [Enable NEON])
   else
      AC_DEFINE([CRYPTOPP_DISABLE_ASM], [1], [Disbale NEON])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ASM"
   fi

   ## Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## ARM A-32 and aes-armv4.S

# Used by Makefile.am to compile aes-armv4.S
if test "$IS_ARM32" != "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   CXXFLAGS="-march=armv7-a -Wa,--noexecstack"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then

      AM_CONDITIONAL([CRYPTOGAMS_AES], [true])
      AC_SUBST([CRYPTOPGAMS_FLAGS], [$CXXFLAGS])

   else

      CXXFLAGS="-march=armv7-a"
      AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
      XXX_COMPILE_IFELSE(
         [AC_LANG_PROGRAM([])],
         [AC_MSG_RESULT([yes])],
         [AC_MSG_RESULT([no])]
      )

      if test "$retval" = "0"; then
         AM_CONDITIONAL([CRYPTOGAMS_AES], [true])
         AC_SUBST([CRYPTOPGAMS_FLAGS], [$CXXFLAGS])
      else
         AM_CONDITIONAL([CRYPTOGAMS_AES], [false])
      fi
   fi

   ## Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
else
   # Required for other platforms
   AM_CONDITIONAL([CRYPTOGAMS_AES], [false])
fi

#############################################################################
## ARM Aarch32 and Aarch64

if test "$IS_AARCH64" != "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   CXXFLAGS="-march=armv8-a"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_ARIA_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_CHAM_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_BLAKE2_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_LEA_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_NEON_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SIMECK_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SIMON_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SPECK_FLAG], [$CXXFLAGS])
   else
      AC_DEFINE([CRYPTOPP_DISABLE_ASM], [1], [Enable NEON])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ASM"
   fi

   CXXFLAGS="-march=armv8-a+crc"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_CRC_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_ARM_CRC32_AVAILABLE], [1], [Enable ARMv8 CRC32])
   else
      AC_DEFINE([CRYPTOPP_DISABLE_CRC32], [1], [Disable ARMv8 CRC32])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ARM_CRC32"
   fi

   CXXFLAGS="-march=armv8-a+crypto"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_GCM_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_AES_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SHA_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_ARM_PMULL_AVAILABLE], [1], [Enable ARMv8 PMULL])
      AC_DEFINE([CRYPTOPP_ARM_AES_AVAILABLE], [1], [Enable ARMv8 AES])
      AC_DEFINE([CRYPTOPP_ARM_SHA_AVAILABLE], [1], [Enable ARMv8 SHA])
   else
      AC_DEFINE([CRYPTOPP_DISABLE_ARM_PMULL], [1], [Disable ARMv8 PMULL])
      AC_DEFINE([CRYPTOPP_DISABLE_ARM_AES], [1], [Disable ARMv8 AES])
      AC_DEFINE([CRYPTOPP_DISABLE_ARM_SHA], [1], [Disable ARMv8 SHA])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ARM_PMULL"
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ARM_AES"
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ARM_SHA"
   fi

   CXXFLAGS="-march=armv8.4-a+sha3"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_SHA512_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SHA3_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_ARM_SHA512_AVAILABLE], [1], [Enable ARMv8 SHA-512])
      AC_DEFINE([CRYPTOPP_ARM_SHA3_AVAILABLE], [1], [Enable ARMv8 SHA3])
   #else
      #AC_DEFINE([CRYPTOPP_DISABLE_ARM_SHA512], [1], [Disable ARMv8 SHA-512])
      #AC_DEFINE([CRYPTOPP_DISABLE_ARM_SHA3], [1], [Disable ARMv8 SHA3])
      #AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ARM_SHA512"
      #AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ARM_SHA3"
   fi

   CXXFLAGS="-march=armv8.4-a+sm4"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AC_SUBST([CRYPTOPP_SM3_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SM4_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_ARM_SM3_AVAILABLE], [1], [Enable ARMv8 SM3])
      AC_DEFINE([CRYPTOPP_ARM_SM4_AVAILABLE], [1], [Enable ARMv8 SM4])
   #else
      #AC_DEFINE([CRYPTOPP_DISABLE_ARM_SM3], [1], [Disable ARMv8 SM3])
      #AC_DEFINE([CRYPTOPP_DISABLE_ARM_SM4], [1], [Disable ARMv8 SM4])
      #AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ARM_SM3"
      #AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ARM_SM4"
   fi

   ## Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## IBC XL C/C++ compiler, applies to IA-32 and PPC

if test "$IS_XLC_COMPILER" != "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   ## -qrtti must be present for some xlC compilers
   HAS_RTTI=`echo $CPPFLAGS $CXXFLAGS | $EGREP -i -c -E '\-qrtti'`
   if test "$HAS_RTTI" = "0"; then

      CXXFLAGS="-qrtti"
      AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
      XXX_COMPILE_IFELSE(
         [AC_LANG_PROGRAM([])],
         [AC_MSG_RESULT([yes])],
         [AC_MSG_RESULT([no])]
      )

      if test "$retval" = "0"; then
         AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
      fi
   fi

   # Promotes optimizations
   CXXFLAGS="-qmaxmem=-1"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
   fi

   ## Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
# More stupid LLVM games. Clang pretending to be three different compilers.
# https://lists.tetaneutral.net/pipermail/cfarm-users/2018-July/000331.html

if test "$IS_XLC_COMPILER" != "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   CXXFLAGS="-qxlcompatmacros"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
   fi

   ## Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"

fi

#############################################################################
## PowerPC and PowerPC-64

if test "$IS_PPC" != "0"; then

   if test "$IS_XLC_COMPILER" != "0"; then
      PPC_POWER4_FLAG="-qarch=pwr4 -qaltivec"
      PPC_POWER7_FLAG="-qarch=pwr7 -qaltivec"
      PPC_POWER8_FLAG="-qarch=pwr8 -qaltivec"
   else
      PPC_POWER4_FLAG="-mcpu=power4 -maltivec"
      PPC_POWER7_FLAG="-mcpu=power7 -maltivec"
      PPC_POWER8_FLAG="-mcpu=power8 -maltivec"
   fi

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"
   pwr_value="0"

   ## ppc-simd.cpp, gcm-simd.cpp, rijndael-simd.cpp, sha-simd.cpp
   ## Altivec needs Power4, but the VSX loads and stores needs Power7.
   CXXFLAGS="$PPC_POWER4_FLAG"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([pwr_value], [4])],
      [AC_MSG_RESULT([no])                             ]
   )

   CXXFLAGS="$PPC_POWER7_FLAG"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([pwr_value], [7])],
      [AC_MSG_RESULT([no])                             ]
   )

   CXXFLAGS="$PPC_POWER8_FLAG"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([pwr_value], [8])],
      [AC_MSG_RESULT([no])                             ]
   )

   ## Power8 and Crypto
   if test "$pwr_value" = "8"; then
      AC_SUBST([CRYPTOPP_PPC_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_CRC_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_AES_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_SHA_FLAG], [$CXXFLAGS])
      AC_DEFINE([CRYPTOPP_ALTIVEC_AVAILABLE], [1], [Enable Altivec])
      AC_DEFINE([CRYPTOPP_POWER7_AVAILABLE],  [1], [Enable Power7])
      AC_DEFINE([CRYPTOPP_POWER8_AVAILABLE],  [1], [Enable Power8])
      AC_DEFINE([CRYPTOPP_POWER8_CRC_AVAILABLE], [1], [Enable Power8 CRC])
      AC_DEFINE([CRYPTOPP_POWER8_AES_AVAILABLE], [1], [Enable Power8 AES])
      AC_DEFINE([CRYPTOPP_POWER8_SHA_AVAILABLE], [1], [Enable Power8 SHA])
   else
      AC_DEFINE([CRYPTOPP_DISABLE_POWER8], [1], [Disable Power8])
      AC_DEFINE([CRYPTOPP_DISABLE_POWER8_CRC], [1], [Disable Power8 CRC])
      AC_DEFINE([CRYPTOPP_DISABLE_POWER8_AES], [1], [Disable Power8 AES])
      AC_DEFINE([CRYPTOPP_DISABLE_POWER8_SHA], [1], [Disable Power8 SHA])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_POWER8=1"
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_POWER8_CRC=1"
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_POWER8_AES=1"
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_POWER8_SHA=1"

      ## Power7 and VSX
      if test "$pwr_value" = "7"; then
         AC_SUBST([CRYPTOPP_PPC_FLAG], [$CXXFLAGS])
         AC_DEFINE([CRYPTOPP_POWER7_AVAILABLE], [1], [Enable Power7])
      else
         AC_DEFINE([CRYPTOPP_DISABLE_POWER7], [1], [Disable Power7])
         AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_POWER7=1"

         ## Power4 and Altivec
         if test "$retval" = "0"; then
            AC_SUBST([CRYPTOPP_PPC_FLAG], [$CXXFLAGS])
            AC_DEFINE([CRYPTOPP_ALTIVEC_AVAILABLE], [1], [Enable Altivec])
         else
            AC_DEFINE([CRYPTOPP_DISABLE_ALTIVEC], [1], [Disable Altivec])
            AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ALTIVEC=1"
         fi
      fi
   fi

   ## These are much higher ISA's than needed and may break distros. The
   ## problem is LLVM on GCC119. It is a Power8 machine but Clang rejects
   ## -qarch=pwr4 and -qarch=pwr7. The only option we have is -qarch=pwr8.
   AC_SUBST([CRYPTOPP_CHAM_FLAG], [$CRYPTOPP_PPC_FLAG])
   AC_SUBST([CRYPTOPP_LEA_FLAG], [$CRYPTOPP_PPC_FLAG])
   AC_SUBST([CRYPTOPP_SIMECK_FLAG], [$CRYPTOPP_PPC_FLAG])
   AC_SUBST([CRYPTOPP_SIMON_FLAG], [$CRYPTOPP_PPC_FLAG])
   AC_SUBST([CRYPTOPP_SPECK_FLAG], [$CRYPTOPP_PPC_FLAG])
   AC_SUBST([CRYPTOPP_SM4_FLAG], [$CRYPTOPP_PPC_FLAG])

   ## Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## Add -pipe for non-IoT gadgets to speedup compiles. We use 2GB RAM as
## threshold. Anything with less than 2GB will not use -pipe.

# Unix, Linux and family
MEM_SIZE=`$EGREP "MemTotal" /proc/meminfo 2>/dev/null | $AWK '{print int($2/1024); exit;}'`

# Darwin
if test "$IS_APPLE_OS" != "0"; then
   MEM_SIZE=`sysctl -a 2>&1 | $EGREP "hw.memsize" 2>/dev/null | $AWK '{print int($3/1024/1024); exit;}'`
fi

# Solaris
if test "$IS_SUN_OS" != "0"; then
   MEM_SIZE=`prtconf 2>/dev/null | $EGREP "Memory" | $AWK '{print int($3/1024); exit;}'`
fi

# AIX
if test "$IS_AIX_OS" != "0"; then
   MEM_SIZE=`prtconf -m 2>/dev/null | $EGREP "MB" | $AWK '{print int($3/1024); exit;}'`
fi

if test "$MEM_SIZE" -ge "2"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   CXXFLAGS="-pipe"
   AC_MSG_CHECKING([if $CXXNAME supports $CXXFLAGS])
   XXX_COMPILE_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AM_CXXFLAGS="$AM_CXXFLAGS $CXXFLAGS"
   fi

   ## Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## Dead code stripping for linkers. Compilers are towards the head of script.

if true; then

   ## Save FLAGS
   SAVED_LDFLAGS="$LDFLAGS"

   # OS X uses -Wl,-dead_strip
   LDFLAGS="-Wl,-dead_strip"
   AC_MSG_CHECKING([if $LDNAME supports $LDFLAGS])
   XXX_LINK_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AM_LDFLAGS="$AM_LDFLAGS $LDFLAGS"
   fi

   # Linux uses 
   LDFLAGS="-Wl,--gc-sections"
   AC_MSG_CHECKING([if $LDNAME supports $LDFLAGS])
   XXX_LINK_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AM_LDFLAGS="$AM_LDFLAGS $LDFLAGS"
   fi

   ## Restore FLAGS
   LDFLAGS="$SAVED_LDFLAGS"
fi

#############################################################################
## Solaris, map file and libraries

if test "$IS_SUN_OS" != "0"; then

   ## Save LDFLAGS
   SAVED_LDFLAGS="$LDFLAGS"

   ## IA-32 gets a Mapfile for capabilities. Due to libtool stripping
   ## -M arguments, we need to escape it with -XCClinker in AM_LDFLAGS.
   if test "$IS_IA32" != "0"; then
      LDFLAGS="-Mcryptopp.mapfile"
      AC_MSG_CHECKING([if $LDNAME supports $LDFLAGS])
      XXX_LINK_IFELSE(
        [AC_LANG_PROGRAM([])],
         [AC_MSG_RESULT([yes])],
         [AC_MSG_RESULT([no])]
      )

      if test "$retval" = "0"; then
         AM_LDFLAGS="$AM_LDFLAGS -XCClinker -Mcryptopp.mapfile"
      fi
   fi

   LDFLAGS="-lnsl"
   AC_MSG_CHECKING([if $LDNAME supports $LDFLAGS])
   XXX_LINK_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

      if test "$retval" = "0"; then
      AM_LDFLAGS="$AM_LDFLAGS $LDFLAGS"
   fi

   LDFLAGS="-lsocket"
   AC_MSG_CHECKING([if $LDNAME supports $LDFLAGS])
   XXX_LINK_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AM_LDFLAGS="$AM_LDFLAGS $LDFLAGS"
   fi

   ## Restore LDFLAGS
   LDFLAGS="$SAVED_LDFLAGS"
fi

#############################################################################
## Add -Wl,--exclude-libs,ALL for GNU linker to stop us from re-exporting
## symbols in other libraries. This keeps our ELF section header smaller.

if test "$enable_shared" = "yes"; then

   SAVED_LDFLAGS="$LDFLAGS"
   LDFLAGS="-Wl,--exclude-libs,ALL"

   AC_MSG_CHECKING([if $LDNAME supports $LDFLAGS])
   XXX_LINK_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AM_LDFLAGS="$AM_LDFLAGS $LDFLAGS"
   fi

   LDFLAGS="$SAVED_LDFLAGS"
fi

#############################################################################
## Add -Wl,--as-needed for linker to avoid linking unneeded libraries.

if true; then

   SAVED_LDFLAGS="$LDFLAGS"
   LDFLAGS="-Wl,--as-needed"

   AC_MSG_CHECKING([if $LDNAME supports $LDFLAGS])
   XXX_LINK_IFELSE(
      [AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])]
   )

   if test "$retval" = "0"; then
      AM_LDFLAGS="$AM_LDFLAGS $LDFLAGS"
   fi

   LDFLAGS="$SAVED_LDFLAGS"
fi

#############################################################################
## It is too bad this does not work. If we could write directly
## to the config file we could do away with the library one.

if false; then

cat << EOT >> local.h
typedef unsigned char byte;
typedef unsigned short word16;
typedef unsigned int word32;

#if defined(_MSC_VER) || defined(__BORLANDC__)
   typedef unsigned __int64 word64;
   #define W64LIT(x) x##ui64
#elif (_LP64 || __LP64__)
   typedef unsigned long word64;
   #define W64LIT(x) x##UL
#else
   typedef unsigned long long word64;
   #define W64LIT(x) x##ULL
#endif

// define large word type, used for file offsets and such
typedef word64 lword;
const lword LWORD_MAX = W64LIT(0xffffffffffffffff);
EOT
fi

## Fix CCAS and CCASFLAGS
## Also see https://stackoverflow.com/q/51575580/608639
AC_SUBST([CCAS], [$CXX])
AC_SUBST([CCASFLAGS], [$CXXFLAGS])

## Without this 'make' uses out GNUmakefile, and not Makefile
# AC_CONFIG_COMMANDS_PRE([rm -f config.h 2>/dev/null])
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

echo "Auto-configuration complete. A summary of options are below. If"
echo "something looks wrong then please modify config.h and please report"
echo "it at http://github.com/noloader/cryptopp-autotools."
echo ""

echo "   Build triplet: $host"
echo " Compiler target: $COMPILER_TARGET"
echo "Compiler version: $COMPILER_VERSION"
echo ""

echo "Static library: $enable_static"
echo "Shared library: $enable_shared"
echo ""

if test x"$CRYPTOPP_SSE_FLAG" != "x"; then
   echo "CRYPTOPP_SSE_FLAG: $CRYPTOPP_SSE_FLAG"
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
if test x"$CRYPTOPP_CHAM_FLAG" != "x"; then
   echo "CRYPTOPP_CHAM_FLAG: $CRYPTOPP_CHAM_FLAG"
fi
if test x"$CRYPTOPP_CRC_FLAG" != "x"; then
   echo "CRYPTOPP_CRC_FLAG: $CRYPTOPP_CRC_FLAG"
fi
if test x"$CRYPTOPP_LEA_FLAG" != "x"; then
   echo "CRYPTOPP_LEA_FLAG: $CRYPTOPP_LEA_FLAG"
fi
if test x"$CRYPTOPP_GCM_FLAG" != "x"; then
   echo "CRYPTOPP_GCM_FLAG: $CRYPTOPP_GCM_FLAG"
fi
if test x"$CRYPTOPP_AES_FLAG" != "x"; then
   echo "CRYPTOPP_AES_FLAG: $CRYPTOPP_AES_FLAG"
fi
if test x"$CRYPTOPP_SHA_FLAG" != "x"; then
   echo "CRYPTOPP_SHA_FLAG: $CRYPTOPP_SHA_FLAG"
fi
if test x"$CRYPTOPP_SIMECK_FLAG" != "x"; then
   echo "CRYPTOPP_SIMECK_FLAG: $CRYPTOPP_SIMECK_FLAG"
fi
if test x"$CRYPTOPP_SIMON_FLAG" != "x"; then
   echo "CRYPTOPP_SIMON_FLAG: $CRYPTOPP_SIMON_FLAG"
fi
if test x"$CRYPTOPP_SPECK_FLAG" != "x"; then
   echo "CRYPTOPP_SPECK_FLAG: $CRYPTOPP_SPECK_FLAG"
fi
if test x"$CRYPTOPP_SM4_FLAG" != "x"; then
   echo "CRYPTOPP_SM4_FLAG: $CRYPTOPP_SM4_FLAG"
fi
if test x"$CRYPTOPGAMS_FLAGS" != "x"; then
   echo "CRYPTOPGAMS_FLAGS: $CRYPTOPGAMS_FLAGS"
fi

echo ""
echo "Automake flags (can be overridden by user flags):"
echo "AM_CXXFLAGS: $AM_CXXFLAGS"
echo "AM_LDFLAGS: $AM_LDFLAGS"

echo ""
echo "User flags (overrides Automake flags on conflict):"
echo "CXXFLAGS: $CXXFLAGS"
echo "LDFLAGS: $LDFLAGS"

OPT_NDEBUG=`echo $CPPFLAGS $CXXFLAGS | $EGREP -c -E '\-DNDEBUG'`
if test "$OPT_NDEBUG" = "0"; then
   echo ""
   echo "CPPFLAGS does not include -DNDEBUG. You should consider building"
   echo "with NDEBUG defined so an assert does not inadvertently crash your"
   echo "program and egress sensitive data to an error reporting service"
   echo "like AppPort, Windows Error Reporting, Crash Reporter, etc."
fi

OPT_SYM=`echo $CPPFLAGS $CXXFLAGS | $EGREP -c -E '\-g'`
if test "$OPT_SYM" = "0"; then
   echo ""
   echo "CPPFLAGS does not include -g. You should consider building with -g"
   echo "to add debug symbols in case you have to analyze a crash."
fi

OPT_O3=`echo $CXXFLAGS | $EGREP -c -E '\-O3|\-O4|\-O5|\-xO3|\-xO4|\-xO5|\-Os|\-Ofast'`
if test "$OPT_O3" = "0"; then
   echo ""
   echo "CXXFLAGS does not include -O3. You should consider building at -O3"
   echo "to engage compiler vectorizations and enhance performance."
fi

HAVE_WIDTH=`echo $CXXFLAGS | $EGREP -i -c -E '\-m32|\-m64|\-q32|\-q64|\-march=native|\-native|\-arch x86_64|\-arch arm64'`

## Don't print message for Aarch64
if test "$IS_AARCH64" = "0"; then
if test "$IS_64BITS" != "0" && test "$HAVE_WIDTH" = "0"; then
   echo ""
   echo "The machine is 64-bit capable but -m64 is not present in CXXFLAGS."
fi
fi

echo "***********************************************************************"
echo ""
