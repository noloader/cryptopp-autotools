#!/usr/bin/env bash

# Written and placed in public domain by Jeffrey Walton

if ! command -v aclocal &>/dev/null; then
    echo "aclocal not found. Bootstrap will probably fail"
fi

if ! command -v automake &>/dev/null; then
    echo "automake not found. Bootstrap will probably fail"
fi

if ! command -v autoconf &>/dev/null; then
    echo "autoconf not found. Bootstrap will probably fail"
fi

if ! command -v curl &>/dev/null; then
    echo "curl not found. Updates will probably fail"
fi

#############################################################################

# Default tools
GREP=grep
SED=sed
AWK=awk

# Fixup, Solaris and friends
if [[ -d /usr/xpg4/bin ]]; then
	SED=/usr/xpg4/bin/sed
	AWK=/usr/xpg4/bin/awk
	GREP=/usr/xpg4/bin/grep
elif [[ -d /usr/bin/posix ]]; then
	SED=/usr/bin/posix/sed
	AWK=/usr/bin/posix/awk
	GREP=/usr/bin/posix/grep
fi

# Fixup for sed and "illegal byte sequence"
IS_DARWIN=$(uname -s 2>/dev/null | "$GREP" -i -c darwin)
if [[ "$IS_DARWIN" -ne 0 ]]; then
	LC_ALL=C; export LC_ALL
fi

#############################################################################

# https://www.gnu.org/software/automake/faq/autotools-faq.html#What-does-_002e_002fbootstrap-or-_002e_002fautogen_002esh-do_003f and
# http://www.fifi.org/doc/autobook/html/autobook_43.html

# For some reason build-aux is now missing. Autotools really sucks.
mkdir -p m4 build-aux

echo "Bootstrapping Autotools"
if ! aclocal && automake --gnu --add-missing && \
	autoconf && autoreconf --force --install; then
    echo "Bootstrap failed"
    exit 1
fi

#############################################################################

# Update config.sub config.guess. GNU recommends using the latest for all projects.
# https://www.gnu.org/software/gettext/manual/html_node/config_002eguess.html
echo "Updating config.sub"
curl -L -s -o config.sub.new 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub'

# Solaris removes +w, can't overwrite
chmod +w build-aux/config.sub
mv config.sub.new build-aux/config.sub
chmod +x build-aux/config.sub

if [[ "$IS_DARWIN" -ne 0 ]] && [[ -n $(command -v xattr 2>/dev/null) ]]; then
	echo "Removing config.sub quarantine"
	xattr -d "com.apple.quarantine" build-aux/config.sub &>/dev/null
fi

echo "Updating config.guess"
curl -L -s -o config.guess.new 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess'

# Solaris removes +w, can't overwrite
chmod +w build-aux/config.guess
mv config.guess.new build-aux/config.guess
chmod +x build-aux/config.guess

if [[ "$IS_DARWIN" -ne 0 ]] && [[ -n $(command -v xattr 2>/dev/null) ]]; then
	echo "Removing config.guess quarantine"
	xattr -d "com.apple.quarantine" build-aux/config.guess &>/dev/null
fi

#############################################################################

exit 0
