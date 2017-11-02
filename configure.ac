## configure.ac - Autotools configuration file for Crypto++.
##                written and placed in public domain by Jeffrey Walton.
##                based on Debian configure.ac by László Böszörményi.
##

## TODO
##
## - Figure out how to make Autotools to stop using the fucking C compiler for tasks.
##   The damn tool does not honor AC_PROG_CXX or observe the absence of AC_PROG_CC. It also fails
##   to provide a AC_PROG_NO_CC macro. The tool is no better than Cmake.
##
## - Figure out how to use AC_OUTPUT and AC_CONFIG_COMMANDS_POST. The commands we execute do not
##   perform the work we expect, and the docs do not explain what we should be doing. Also see
##   https://www.gnu.org/software/autoconf/manual/autoconf-2.60/html_node/Configuration-Commands.html
##
## - Stop using local.h, and write the config data into a Crypto++ compatible config.h. There's not
##   much to "Crypto++ compatible config.h". We need test and write preprocessor macros like
##   IS_BIG_ENDIAN, IS_LITTLE_ENDIAN, CRYPTOPP_CXX11, etc.
##

AC_INIT(Crypto++, 6.0, http://www.cryptopp.com/wiki/Bug_Report)
LT_INIT
AM_INIT_AUTOMAKE
AM_MAINTAINER_MODE

AC_CONFIG_MACRO_DIRS([m4])
AC_CONFIG_SRCDIR(configure.ac)
AC_CONFIG_HEADER([local.h])

AC_ENABLE_SHARED
AC_ENABLE_STATIC

AC_PROG_CXX
AC_PROG_CXXCPP

AC_PROG_LIBTOOL
AC_PROG_INSTALL

## Squash this useless warning
AC_CONFIG_COMMANDS_PRE([[mkdir -p m4/ 2>/dev/null]])

## Remove existing makefiles
AC_CONFIG_COMMANDS_PRE([[rm -f GNUmakefile 2>/dev/null]])
AC_CONFIG_COMMANDS_PRE([[rm -f GNUmakefile-cross 2>/dev/null]])

AC_OUTPUT(Makefile)

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
    mv Makefile.xxx Makefile; \
]])
