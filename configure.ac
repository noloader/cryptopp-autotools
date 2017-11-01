## configure.ac for Crypto++ based on Debian configure.ac by László Böszörményi.

AC_INIT(libcryptopp, 6.0, http://www.cryptopp.com/wiki/Bug_Report)

AM_INIT_AUTOMAKE
AM_MAINTAINER_MODE

AC_CONFIG_MACRO_DIRS([m4])
AC_CONFIG_SRCDIR(configure.ac)
AC_CONFIG_HEADER([local.h])

AC_PROG_CXX
AC_PROG_LIBTOOL
AC_PROG_INSTALL

AC_OUTPUT(Makefile)

AC_CONFIG_COMMANDS(['C++ is not C! WTF?'],
    [sed -e "/CC =/d" Makefile > Makefile.fixed],
    [mv Makefile.fixed Makefile],
    [sed -e "/CFLAGS =/d" Makefile > Makefile.fixed],
    [mv Makefile.fixed Makefile],
    [sed -e "/ac_ct_CC =/d" Makefile > Makefile.fixed],
    [mv Makefile.fixed Makefile])
