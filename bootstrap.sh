#!/usr/bin/env bash

# Written and placed in public domain by Jeffrey Walton
# Autotools sucks. My condolences you have to work with it.

if ! command -v aclocal >/dev/null 2>&1; then
    echo "aclocal not found. Bootstrap will probably fail"
fi

if ! command -v automake >/dev/null 2>&1; then
    echo "automake not found. Bootstrap will probably fail"
fi

if ! command -v autoupdate >/dev/null 2>&1; then
    echo "autoupdate not found. Bootstrap will probably fail"
fi

if ! command -v autoconf >/dev/null 2>&1; then
    echo "autoconf not found. Bootstrap will probably fail"
fi

if ! command -v autoreconf >/dev/null 2>&1; then
    echo "autoreconf not found. Bootstrap will probably fail"
fi

if ! command -v file >/dev/null 2>&1; then
    echo "file not found. Bootstrap will probably fail"
fi

if ! command -v wget >/dev/null 2>&1; then
    if ! command -v curl >/dev/null 2>&1; then
        echo "wget and curl not found. Updates will probably fail"
    fi
fi

#############################################################################

# Default tools
GREP=grep
SED=sed
AWK=awk

# Fixup, Solaris and friends
if [ -d /usr/xpg4/bin ]; then
	SED=/usr/xpg4/bin/sed
	AWK=/usr/xpg4/bin/awk
	GREP=/usr/xpg4/bin/grep
elif [ -d /usr/bin/posix ]; then
	SED=/usr/bin/posix/sed
	AWK=/usr/bin/posix/awk
	GREP=/usr/bin/posix/grep
fi

if command -v wget >/dev/null 2>&1; then
    FETCH_CMD="wget -q -O"
elif command -v curl >/dev/null 2>&1; then
    FETCH_CMD="curl -L -s -o"
else
    FETCH_CMD="curl-and-wget-not-found"
fi

# Fixup for sed and "illegal byte sequence"
IS_DARWIN=`uname -s 2>&1 | "$GREP" -i -c darwin`
if [ "$IS_DARWIN" -ne 0 ]; then
	LC_ALL=C; export LC_ALL
fi

#############################################################################

# https://www.gnu.org/software/automake/faq/autotools-faq.html#What-does-_002e_002fbootstrap-or-_002e_002fautogen_002esh-do_003f and
# http://www.fifi.org/doc/autobook/html/autobook_43.html
# This recipe does not work: aclocal && automake --gnu --add-missing && autoconf

# For some reason build-aux is now missing. Autotools really sucks.
mkdir -p m4 build-aux

echo "Running aclocal"
if ! aclocal >/dev/null 2>&1; then
	echo "aclocal failed."
	exit 1
fi

echo "Running autoupdate"
if ! autoupdate >/dev/null 2>&1; then
	echo "autoupdate failed."
	exit 1
fi

# Run autoreconf twice on failure. Also see
# https://github.com/tracebox/tracebox/issues/57
echo "Running autoreconf"
if ! autoreconf --force --install >/dev/null 2>&1; then
	echo "autoreconf failed, running again."
	if ! autoreconf --force --install >/dev/null 2>&1; then
		echo "autoreconf failed, again."
		exit 1
	fi
fi

# Create the configure script
if ! autoconf >/dev/null 2>&1; then
	echo "autoconf failed."
	exit 1
fi

#############################################################################

# Update config.sub config.guess. GNU recommends using the latest for all projects.
# https://www.gnu.org/software/gettext/manual/html_node/config_002eguess.html

echo "Updating config.sub"
if ${FETCH_CMD} config.sub.new \
   'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub' >/dev/null 2>&1; then

	# Solaris removes +w, can't overwrite
	chmod +w build-aux/config.sub
	mv config.sub.new build-aux/config.sub
	chmod +x build-aux/config.sub

	if [ "$IS_DARWIN" -ne 0 ] && [ command -v xattr >/dev/null 2>&1 ]; then
		echo "Removing config.sub quarantine"
		xattr -d "com.apple.quarantine" build-aux/config.sub >/dev/null 2>&1
	fi
fi

echo "Updating config.guess"
if ${FETCH_CMD} config.guess.new \
   'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess' >/dev/null 2>&1; then

	# Solaris removes +w, can't overwrite
	chmod +w build-aux/config.guess
	mv config.guess.new build-aux/config.guess
	chmod +x build-aux/config.guess

	if [ "$IS_DARWIN" -ne 0 ] && [ command -v xattr >/dev/null 2>&1 ]; then
		echo "Removing config.guess quarantine"
		xattr -d "com.apple.quarantine" build-aux/config.guess >/dev/null 2>&1
	fi
fi

#############################################################################

exit 0
