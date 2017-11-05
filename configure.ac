## configure.ac - Autotools configuration file for Crypto++.
##                written and placed in public domain by Jeffrey Walton.
##                based on Debian configure.ac by László Böszörményi.
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
## - Add architectural flags for Aarch32/64 and Power7/8.
##
## - Add -ffunction-sections, -fdata-sections, -Wl,--gc-sections, and -Wl,-dead_strip for IoT gadgets.
##
## - Add ubsan and asan targets for testing.
##
##

#############################################################################
AC_INIT([Crypto++], [6.0], [http://www.cryptopp.com/wiki/Bug_Report], [cryptopp], [http://www.cryptopp.com])
AM_INIT_AUTOMAKE

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_FILES([Makefile] [libcryptopp.pc])
AC_CONFIG_SRCDIR([configure.ac])
AC_CONFIG_HEADERS([local.h])

AM_PROG_AR
LT_INIT

AC_PROG_CXX
AC_LANG([C++])
AC_PROG_CXXCPP
AC_PROG_GREP

AC_ENABLE_SHARED
AC_ENABLE_STATIC

#############################################################################

## Determine the CPU and OS of the machine we are building for.
## Most people call this the target machine, but not Autotools.
AC_CANONICAL_HOST

## Determine the compiler's target. We add '2>/dev/null' because IBM's xlC
## dumps the man page since '-dumpmachine' is not a valid option.
COMPILER_TARGET=`"$CXX" -dumpmachine 2>/dev/null`

## echo "    Build triplet: $build"
## echo "  Compiler target: $COMPILER_TARGET"

#############################################################################
## pthreads for thread local storage

AC_ARG_ENABLE(tls,
   AS_HELP_STRING([--enable-tls], [enable thread storage (default is yes)]),
   ac_enable_tls=$enableval,
   ac_enable_tls=yes)
AM_CONDITIONAL(HAS_PTHREADS, test $ac_enable_tls = yes)

if test "$ac_enable_tls" = "yes"; then
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

#############################################################################
## Fix AR on iOS and OS X

## AR and ARFLAGS usage is currently broke under Autotools. Also see
## https://lists.gnu.org/archive/html/bug-autoconf/2017-11/msg00002.html

#IS_APPLE=`echo "$build" | $EGREP -i -c 'apple'`
#if test "$IS_APPLE" -ne "0"; then
#   AC_SUBST([AR], ["/usr/bin/libtool"])
#   AC_SUBST([ARFLAGS], ["-static -o"])
#   AC_SUBST([ac_ct_AR], ["/usr/bin/libtool"])
#fi

#############################################################################
## Solaris, GCC and -Wa,--divide

IS_SUN_OS=`uname -s | $EGREP -i -c 'SunOS'`
if test "$IS_SUN_OS" -ne "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   CXXFLAGS="-Wa,--divide"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_WA_DIVIDE], ["-Wa,--divide"])]
   )

   if test "$CRYPTOPP_WA_DIVIDE" = "-Wa,--divide"; then
      AM_CXXFLAGS="$AM_CXXFLAGS -Wa,--divide"
   fi

   # Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## Solaris and libraries

if test "$IS_SUN_OS" -ne "0"; then

   ## Save LDFLAGS
   SAVED_LDFLAGS="$LDFLAGS"

   LDFLAGS="-lnsl -lsocket"
   AC_MSG_CHECKING([if $LD supports $LDFLAGS])
   AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_NSL_SOCKET], ["-lnsl -lsocket"])]
   )

   if test "$CRYPTOPP_NSL_SOCKET" = "-lnsl -lsocket"; then
      AM_LDFLAGS="$AM_LDFLAGS -lnsl -lsocket"
   fi

   # Restore LDFLAGS
   LDFLAGS="$SAVED_LDFLAGS"
fi

#############################################################################
## IA-32, i386, i586, i686, x86_64, etc.

## We are kind of screwed on some platforms because AC_COMPILE_IFELSE fails to
## detect "illegal option". The SunCC compiler literally generates and prints
## the message, but Autoconf ignores it and reports the option is valid.

IS_IA32=`echo $build | $EGREP -i -c -E 'i.86|x86_64|amd64'`
if test "$IS_IA32" -ne "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   ## cryptlib.cpp
   AC_SUBST([CRYPTOPP_CRYPTLIB_FLAG])

   ## cpu.cpp
   CXXFLAGS="-msse2"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for SSE])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_CPU_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )

   if test x"$CRYPTOPP_CPU_FLAG" = "x"; then
      AC_DEFINE([CRYPTOPP_DISABLE_ASM], [1], [XXX])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ASM"
   fi

   ## integer.cpp
   AC_SUBST([CRYPTOPP_INTEGER_FLAG])

   ## aria-simd.cpp
   CXXFLAGS="-mssse3"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for ARIA])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_ARIA_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )

   if test x"$CRYPTOPP_ARIA_FLAG" = "x"; then
      AC_DEFINE([CRYPTOPP_DISABLE_SSSE3], [1], [XXX])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SSSE3"
   fi

   ## blake2-simd.cpp
   CXXFLAGS="-msse4.2"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for BLAKE2])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_BLAKE2_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )

   if test x"$CRYPTOPP_BLAKE2_FLAG" = "x"; then
      AC_DEFINE([CRYPTOPP_DISABLE_SSE4], [1], [XXX])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SSE4"
   fi

   ## crc-simd.cpp
   CXXFLAGS="-msse4.2"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for CRC32])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_CRC_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )
   ## BLAKE2 set -DDCRYPTOPP_DISABLE_SSE4

   ## gcm-simd.cpp
   CXXFLAGS="-mssse3 -mpclmul"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for GCM])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_GCM_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )

   if test x"$CRYPTOPP_GCM_FLAG" = "x"; then
      AC_DEFINE([CRYPTOPP_DISABLE_CLMUL], [1], [XXX])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_CLMUL"
   fi

   ## neon-simd.cpp
   AC_SUBST([CRYPTOPP_NEON_SIMD])

   ## ppc-simd.cpp
   AC_SUBST([CRYPTOPP_PPC_FLAG])

   ## rijndael-simd.cpp
   CXXFLAGS="-msse4.1 -maes"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for AES])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_AES_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )

   if test x"$CRYPTOPP_AES_FLAG" = "x"; then
      AC_DEFINE([CRYPTOPP_DISABLE_AESNI], [1], [XXX])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_AESNI"
   fi

   ## sha-simd.cpp
   CXXFLAGS="-msse4.2 -msha"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for SHA])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_SHA_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )

   if test x"$CRYPTOPP_SHA_FLAG" = "x"; then
      AC_DEFINE([CRYPTOPP_DISABLE_SHA], [1], [XXX])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SHA"
   fi

   # Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## ARM A-32, including NEON, soft floats and hard floats

IS_ARM32=`echo $build | $EGREP -i -c 'arm'`
IS_ANDROID=`echo $build | $EGREP -i -c -E 'android'`

if test "$IS_ARM32" -ne "0" && test "$IS_ANDROID" -ne "0"; then
   AC_MSG_ERROR(["Android is not ready. Ping noloader, gmail to move it along."])
fi

if test "$IS_ARM32" -ne "0" && test "$IS_ANDROID" -eq "0"; then

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

   ## cryptlib.cpp
   AC_SUBST([CRYPTOPP_CRYPTLIB_FLAG])

   ## cpu.cpp
   AC_SUBST([CRYPTOPP_CPU_FLAG])

   ## integer.cpp
   AC_SUBST([CRYPTOPP_INTEGER_FLAG])

   ## crc-simd.cpp
   AC_SUBST([CRYPTOPP_CRC_FLAG])

   ## ppc-simd.cpp
   AC_SUBST([CRYPTOPP_PPC_FLAG])

   ## rijndael-simd.cpp
   AC_SUBST([CRYPTOPP_AES_FLAG])

   ## rijndael-simd.cpp
   AC_SUBST([CRYPTOPP_SHA_FLAG])

   CXXFLAGS="-march=armv7-a -mfloat-abi=$FP_FLAG -mfpu=neon"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([ARM_FLAG], [1])],
      [AC_MSG_RESULT([no])]
   )

   if test "$ARM_FLAG" -eq "1"; then
      AC_SUBST([CRYPTOPP_NEON_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_GCM_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_ARIA_FLAG], [$CXXFLAGS])
      AC_SUBST([CRYPTOPP_BLAKE2_FLAG], [$CXXFLAGS])
   else
      AC_SUBST([CRYPTOPP_ARIA_FLAG])
      AC_SUBST([CRYPTOPP_BLAKE2_FLAG])
      AC_SUBST([CRYPTOPP_GCM_FLAG])
      AC_SUBST([CRYPTOPP_NEON_FLAG])
      AC_DEFINE([CRYPTOPP_DISABLE_NEON], [1], [XXX])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_NEON"
   fi

   # Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## ARM Aarch32 and Aarch64

IS_AARCH64=`echo $build | $EGREP -i -c -E 'aarch32|aarch64'`
if test "$IS_AARCH64" -ne "0"; then

   ## Save CXXFLAGS
   SAVED_CXXFLAGS="$CXXFLAGS"

   ## cryptlib.cpp
   AC_SUBST([CRYPTOPP_CRYPTLIB_FLAG])

   ## cpu.cpp
   AC_SUBST([CRYPTOPP_CPU_FLAG])

   ## integer.cpp
   AC_SUBST([CRYPTOPP_INTEGER_FLAG])

   ## aria-simd.cpp
   CXXFLAGS="-march=armv8-a"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for ARIA])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_ARIA_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )

   if test x"$CRYPTOPP_ARIA_FLAG" = "x"; then
      AC_DEFINE([CRYPTOPP_DISABLE_ASIMD], [1], [XXX])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ASIMD"
   fi

   ## blake2-simd.cpp
   CXXFLAGS="-march=armv8-a"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for BLAKE2])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_BLAKE2_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )
   ## ARIA set -DCRYPTOPP_DISABLE_ASIMD

   ## crc-simd.cpp
   CXXFLAGS="-march=armv8-a+crc"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for CRC32])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_CRC_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )

   if test x"$CRYPTOPP_CRC_FLAG" = "x"; then
      AC_DEFINE([CRYPTOPP_DISABLE_CRC32], [1], [XXX])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_CRC32"
   fi

   ## gcm-simd.cpp
   CXXFLAGS="-march=armv8-a+crypto"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for GCM])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_GCM_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )

   if test x"$CRYPTOPP_GCM_FLAG" = "x"; then
      AC_DEFINE([CRYPTOPP_DISABLE_PMULL], [1], [XXX])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_PMULL"
   fi

   ## neon-simd.cpp
   CXXFLAGS="-march=armv8-a"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for ASIMD])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_NEON_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )
   ## ARIA set -DCRYPTOPP_DISABLE_ASIMD

   ## ppc-simd.cpp
   AC_SUBST([CRYPTOPP_PPC_FLAG])

   ## rijndael-simd.cpp
   CXXFLAGS="-march=armv8-a+crypto"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for AES])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_AES_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )

   if test x"$CRYPTOPP_AES_FLAG" = "x"; then
      AC_DEFINE([CRYPTOPP_DISABLE_AES], [1], [XXX])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_AES"
   fi

   ## sha-simd.cpp
   CXXFLAGS="-march=armv8-a+crypto"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for SHA])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_SHA_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )

   if test x"$CRYPTOPP_SHA_FLAG" = "x"; then
      AC_DEFINE([CRYPTOPP_DISABLE_SHA], [1], [XXX])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SHA"
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

   ## cryptlib.cpp
   AC_SUBST([CRYPTOPP_CRYPTLIB_FLAG])

   ## cpu.cpp
   AC_SUBST([CRYPTOPP_CPU_FLAG])

   ## integer.cpp
   AC_SUBST([CRYPTOPP_INTEGER_FLAG])

   ## aria-simd.cpp
   AC_SUBST([CRYPTOPP_ARIA_FLAG])

   ## blake2-simd.cpp
   AC_SUBST([CRYPTOPP_BLAKE2_FLAG])

   ## crc-simd.cpp
   AC_SUBST([CRYPTOPP_CRC_FLAG])

   ## gcm-simd.cpp
   AC_SUBST([CRYPTOPP_GCM_FLAG])

   ## neon-simd.cpp
   AC_SUBST([CRYPTOPP_NEON_FLAG])

   ## ppc-simd.cpp. Altivec needs Power4, but the VSX loads and stores needs Power7.
   CXXFLAGS="-maltivec -mcpu=power8"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for PPC])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_PPC_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )

   if test x"$CRYPTOPP_PPC_FLAG" = "x"; then
      AC_DEFINE([CRYPTOPP_DISABLE_PPC], [1], [XXX])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_ASM"
   fi

   ## rijndael-simd.cpp
   CXXFLAGS="-maltivec -mcpu=power8"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for AES])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_AES_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )

   if test x"$CRYPTOPP_AES_FLAG" = "x"; then
      AC_DEFINE([CRYPTOPP_DISABLE_AES], [1], [XXX])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_AES"
   fi

   ## sha-simd.cpp
   CXXFLAGS="-maltivec -mcpu=power8"
   AC_MSG_CHECKING([if $CXX supports $CXXFLAGS for SHA])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([yes]); AC_SUBST([CRYPTOPP_SHA_FLAG], [$CXXFLAGS])],
      [AC_MSG_RESULT([no])]
   )

   if test x"$CRYPTOPP_SHA_FLAG" = "x"; then
      AC_DEFINE([CRYPTOPP_DISABLE_SHA], [1], [XXX])
      AM_CXXFLAGS="$AM_CXXFLAGS -DCRYPTOPP_DISABLE_SHA"
   fi

   # Restore CXXFLAGS
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

#############################################################################
## Other fodder

## Add -pipe for non-IoT gadgets to speedup the compile. IoT gadgets, like
## BeagleBoards and CubieTrucks, don't have swap files and run out of memory.

if test "$IS_IA32" -ne "0" || test "$IS_AARCH64" -ne "0" || test "$IS_PPC" -ne "0"; then

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

## Remove existing makefiles
AC_CONFIG_COMMANDS_PRE([[rm -f GNUmakefile 2>/dev/null]])
AC_CONFIG_COMMANDS_PRE([[rm -f GNUmakefile-cross 2>/dev/null]])

## Write the Automake flags we set
AC_SUBST([AM_CXXFLAGS])
AC_SUBST([AM_LDFLAGS])

AC_OUTPUT

## Automake bug workaround. If libcryptopp_la_SOURCES is an empty list, Automake assumes
## C source files and drive link through the C compiler. We provide the empty adhoc.cpp
## to get things back on course, so adhoc.cpp must always be copied.

AC_CONFIG_COMMANDS_POST([[cp adhoc.cpp.proto adhoc.cpp]])
