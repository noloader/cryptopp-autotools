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
##
## - Figure out how to use AC_OUTPUT and AC_CONFIG_COMMANDS_POST. The commands we execute do not
##   perform the work we expect, and the docs do not explain what we should be doing. Also see
##   https://www.gnu.org/software/autoconf/manual/autoconf-2.60/html_node/Configuration-Commands.html
##
## - Stop using local.h, and write the config data into a Crypto++ compatible config.h. There's not
##   much to "Crypto++ compatible config.h". We need test and write preprocessor macros like
##   IS_BIG_ENDIAN, IS_LITTLE_ENDIAN, CRYPTOPP_CXX11, etc.
##
## - Add architectural flags for Aarch32/64 and Power7/8.
##

AC_INIT([Crypto++], [6.0], [http://www.cryptopp.com/wiki/Bug_Report])

LT_INIT
AM_INIT_AUTOMAKE
AM_MAINTAINER_MODE

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_FILES([Makefile])
AC_CONFIG_SRCDIR([configure.ac])
AC_CONFIG_HEADERS([local.h])

AC_PROG_CXX
AC_LANG([C++])
AC_PROG_CXXCPP
AC_PROG_GREP

AC_ENABLE_SHARED
AC_ENABLE_STATIC

######################################
## pthreads for thread local storage
AC_ARG_ENABLE(tls,
   AS_HELP_STRING([--enable-tls], [enable thread storage (default is yes)]),
   ac_enable_tls=$enableval,
   ac_enable_tls=yes)
AM_CONDITIONAL(HAS_PTHREADS, test $ac_enable_tls = yes)

# Determine the CPU and OS of the machine we are building for.
## Most people call this the target machine, but not Autotools.
AC_CANONICAL_HOST

######################################
## IA-32, i386, i586, i686, x86_64, etc.
IS_IA32=`echo $build | $EGREP -i -c -E 'i.86|x86_64|amd64'`
if [[ $IS_IA32 -ne 0 ]]; then
   ## cryptlib.cpp
   AC_SUBST([CRYPTLIB_FLAG])

   ## cpu.cpp
   SAVED_CXXFLAGS="$CXXFLAGS"
   CXXFLAGS="-msse2"
   AC_MSG_CHECKING([$CXX flags for cpu.cpp])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([-msse2]); AC_SUBST([CPU_FLAG], ["-msse2"])],
      [AC_MSG_RESULT([none])]
   )
   CXXFLAGS="$SAVED_CXXFLAGS"

   ## integer.cpp
   AC_SUBST([INTEGER_FLAG])

   ## aria-simd.cpp
   SAVED_CXXFLAGS="$CXXFLAGS"
   CXXFLAGS="-mssse3"
   AC_MSG_CHECKING([$CXX flags for aria-simd.cpp])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([-mssse3]); AC_SUBST([ARIA_FLAG], ["-mssse3"])],
      [AC_MSG_RESULT([none])]
   )
   CXXFLAGS="$SAVED_CXXFLAGS"

   ## blake2-simd.cpp
   SAVED_CXXFLAGS="$CXXFLAGS"
   CXXFLAGS="-msse4.2"
   AC_MSG_CHECKING([$CXX flags for blake2-simd.cpp])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([-msse4.2]); AC_SUBST([BLAKE2_FLAG], ["-msse4.2"])],
      [AC_MSG_RESULT([none])]
   )
   CXXFLAGS="$SAVED_CXXFLAGS"

   ## crc-simd.cpp
   SAVED_CXXFLAGS="$CXXFLAGS"
   CXXFLAGS="-msse4.2"
   AC_MSG_CHECKING([$CXX flags for crc-simd.cpp])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([-msse4.2]); AC_SUBST([CRC_FLAG], ["-msse4.2"])],
      [AC_MSG_RESULT([none])]
   )
   CXXFLAGS="$SAVED_CXXFLAGS"

   ## gcm-simd.cpp
   SAVED_CXXFLAGS="$CXXFLAGS"
   CXXFLAGS="-mssse3 -mpclmul"
   AC_MSG_CHECKING([$CXX flags for gcm-simd.cpp])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([-mssse3 -mpclmul]); AC_SUBST([GCM_FLAG], ["-mssse3 -mpclmul"])],
      [AC_MSG_RESULT([none])]
   )
   CXXFLAGS="$SAVED_CXXFLAGS"

   ## neon-simd.cpp
   AC_SUBST([NEON_FLAG])

   ## ppc-simd.cpp
   AC_SUBST([PPC_FLAG])

   ## rijndael-simd.cpp
   SAVED_CXXFLAGS="$CXXFLAGS"
   CXXFLAGS="-msse4.1 -maes"
   AC_MSG_CHECKING([$CXX flags for rijndael-simd.cpp])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([-msse4.1 -maes]); AC_SUBST([AES_FLAG], ["-msse4.1 -maes"])],
      [AC_MSG_RESULT([none])]
   )
   CXXFLAGS="$SAVED_CXXFLAGS"

   ## sha-simd.cpp
   SAVED_CXXFLAGS="$CXXFLAGS"
   CXXFLAGS="-msse4.2 -msha"
   AC_MSG_CHECKING([$CXX flags for sha-simd.cpp])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
      [AC_MSG_RESULT([-msse4.2 -msha]); AC_SUBST([SHA_FLAG], ["-msse4.2 -msha"])],
      [AC_MSG_RESULT([none])]
   )
   CXXFLAGS="$SAVED_CXXFLAGS"
fi

## Remove existing makefiles
AC_CONFIG_COMMANDS_PRE([[rm -f GNUmakefile 2>/dev/null]])
AC_CONFIG_COMMANDS_PRE([[rm -f GNUmakefile-cross 2>/dev/null]])

AC_SUBST([AM_CXXFLAGS])
AC_SUBST([AM_LDFLAGS])

AC_OUTPUT

## Avoid C compiler. It creates a lot of problems on AIX and Solaris using IBM's xlc and Sun's cc
AC_CONFIG_COMMANDS_POST([[ \
    sed -e '/S["CC"]/d' config.status > config.status.xxx; \
    mv config.status.xxx config.status; \
    sed -e '/S["FLAGS"]/d' config.status > config.status.xxx; \
    mv config.status.xxx config.status; \
    sed -e '/S["ac_ct_CC"]/d' config.status > config.status.xxx; \
    mv config.status.xxx config.status;
]])

## Avoid C compiler. It creates a lot of problems on AIX and Solaris using IBM's xlc and Sun's cc
AC_CONFIG_COMMANDS_POST([[ \
    sed -e '/CC =/d' Makefile > Makefile.xxx; \
    mv Makefile.xxx Makefile; \
    sed -e '/CFLAGS =/d' Makefile > Makefile.xxx; \
    mv Makefile.xxx Makefile; \
    sed -e '/ac_ct_CC =/d' Makefile > Makefile.xxx; \
    mv Makefile.xxx Makefile;
]])

## Automake bug workaround. If XXX is an empty list, it assumes C source files and drive link
## through the C compiler. We provide the empty adhoc.cpp to get things back on course.
AC_CONFIG_COMMANDS_POST([[cp adhoc.cpp.proto adhoc.cpp]])