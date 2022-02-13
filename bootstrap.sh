#! /usr/bin/env/bash

# https://www.gnu.org/software/automake/faq/autotools-faq.html#What-does-_002e_002fbootstrap-or-_002e_002fautogen_002esh-do_003f and
# http://www.fifi.org/doc/autobook/html/autobook_43.html

if ! command -v aclocal 2>/dev/null; then
    echo "aclocal not found. Things will probably fail"
fi

if ! command -v automake 2>/dev/null; then
    echo "aclocal not found. Things will probably fail"
fi

if ! command -v autoconf 2>/dev/null; then
    echo "aclocal not found. Things will probably fail"
fi

if ! aclocal && \
	automake --gnu --add-missing && \
	autoconf; then
    echo "Bootstrap failed"
    exit 1
fi

exit 0
