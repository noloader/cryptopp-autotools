## Crypto++ Autotools

[![Build Status](https://travis-ci.org/noloader/cryptopp-autotools.svg?branch=master)](https://travis-ci.org/noloader/cryptopp-autotools)
[![Build status](https://ci.appveyor.com/api/projects/status/3de2dlmwv9fxeyp8?svg=true)](https://ci.appveyor.com/project/noloader/cryptopp-autotools)

This repository contains Autotools files for Wei Dai's Crypto++ (https://github.com/weidai11/cryptopp). It supplies `configure.ac`, `makefile.am` and `libcryptopp.pc.in`. Autotools is officialy unsupported, so use it at your own risk.

The purpose of Crypto++ Autotools is three-fold:

1. better support Linux distributions, like Debain, Fedora and openSUSE
2. supplement the GNUmakefile which is reaching its limits with repsect to GNUmake-based configuration
3. utilize compiler feature probes that produce better results on ARM, MIPS and Power8 architectures

The initial `Makefile.am` and `configure.ac` were shamelessly ripped from Debian. Many thanks to László Böszörményi for his work on the files and allowing us to use them as a starting point. Nick Bowler and Mathieu Lirzin from the Automake mailing list were extremely helpful in porting our requirements to Automake.

There is a wiki page available that discusses Autotools and the Crypto++ project files in more detail at [Autotools](https://www.cryptopp.com/wiki/Autotools).

## Testing

The Autotools files are officialy unsupported, so use them at your own risk. With that said, the Autotools source files are tested with Crypto++ on Linux and OS X using [Travis CI](https://github.com/weidai11/cryptopp/blob/master/.travis.yml).

In June 2018 the library added `cryptest-autotools.sh` to help test the Autotools gear. The script is located in Crypto++'s `TestScripts` directory. The script downloads the Autotools project files, builds the library and then runs the self tests.

If you want to use `cryptest-autotools.sh` to drive things then perform the following steps.

    cd cryptopp
    cp TestScripts/cryptest-autotools.sh .
    ./cryptest-autotools.sh

## Workflow

The general workflow is clone Wei Dai's Crypto++, fetch the Autotools files, and then `autoreconf`:

    git clone https://github.com/weidai11/cryptopp.git
    cd cryptopp

    wget -O configure.ac https://raw.githubusercontent.com/noloader/cryptopp-autotools/master/configure.ac
    wget -O Makefile.am https://raw.githubusercontent.com/noloader/cryptopp-autotools/master/Makefile.am
    wget -O libcryptopp.pc.in https://raw.githubusercontent.com/noloader/cryptopp-autotools/master/libcryptopp.pc.in

    mkdir -p "$PWD/m4/"

Once you have the files you can run `autoreconf` and friends. Our testing showed `autoupdate` produced bad results on some versions of Autotools, so it is hit or miss whether it should be run.

    autoupdate
    libtoolize --force --install
    autoreconf --force --install

    ./configure <options>

    make
    make test
    sudo make install <options>

Best performance is obtained with `-O3` because GCC (and other compiler) apply vectorization optimizations. If you are not forced to `-O2` by policy (like Debian or Fedora), then you should configure with a higher optimization enabled:

    CXXFLAGS="-DNDEBUG -g2 -O3" ./configure <other options>

Despite our efforts we have not been able to add the submodule to Crypto++ for seamless integration. If anyone knows how to add a submodule directly to the Crypto++ directory, then please provide the instructions.

## ZIP Files

If you are working from a Crypto++ release zip file, then you should download the same cryptopp-autotools release zip file. Both Crypto++ and this project use the same release tags, such as CRYPTOPP_8_0_0.

If you mix and match Master with a release zip file then things may not work as expected. You may find the build project files reference a source file that is not present in the Crypto++ release.

## Prerequisites

Before running the Autotools project please ensure you have the following installed:

1. autoupdate
2. autoconf
3. automake
4. libtool

You may also need `libltdl-dev` on Debian and Ubuntu; and may need `libtool-ltdl-devel` on Fedora. MinGW and family need the Autoconf and Automake *wrappers* in addition to the Autoconf and Automake binaries.

If working on the GCC Compile Farm then you may need exta steps for systems like AIX. AIX offers updated Autoconf and Automake in `/opt/freeware/bin/`; and offers Libtool in `/opt/cfarm/libtool-2.4.2/bin/`. Both `bin/` need to be on path. When running `autoreconf` you must `autoreconf --force --install --include=/opt/cfarm/libtool-2.4.2/share/aclocal/`.

## Integration
The Autotools submodule integrates with the Crypto++ library. The submodule removes the library's `GNUmakefile` and `GNUmakefile-cross`. In the future we plan to overwrite the library's `config.h` and produce an installation specific `config.h`.

The library's `GNUmakefile` and `GNUmakefile-cross` were modified to clean the artifacts produced by Autotools. To clean the directory after running Autotools perform a `git checkout GNUmakefile` followed by a `make -f GNUmakefile distclean`.

## Cross-compiles

Cross-compiles are mostly broken due to Autotools. The biggest problem seems to be Autotools inability to honor a C++ project settings. Using Android as an example:

* `configure.ac` sets `AC_PROG_CXX`
* `configure.ac` sets `AC_LANG([C++])`
* User sets `CXX=/opt/android-ndk-r19c/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++`
* User sets `LD=/opt/android-ndk-r19c/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++`
* User sets `CXXFLAGS="-target armv7-none-linux-androideabi21 ...`
* User sets `LDFLAGS="-Wl,-target=armv7-none-linux-androideabi21 ...`
* User invokes `./configure --host=$(config.guess) --build=armv7-none-linux-androideabi21`

Autotools will perform a test using the host's gcc and fail with:

```
configure:3481: checking whether the C compiler works
configure:3503: gcc -Wl,-target=armv7-none-linux-androideabi21 ... conftest.c  >&5
/usr/bin/ld: unrecognised emulation mode: thumb
Supported emulations: elf_x86_64 elf32_x86_64 elf_i386 elf_iamcu i386linux elf_l1om
                      elf_k1om i386pep i386pe
collect2: error: ld returned 1 exit status
```

Autotools absolutely sucks. The maintainers have had 30 years to get it right and their shit is still broken.

## Collaboration
We would like all distro maintainers to be collaborators on this repo. If you are a distro maintainer then please contact us so we can send you an invite.

If you are a collaborator then make changes as you see fit. You don't need to ask for permission to make a change. Noloader is not an Autotools expert so there are probably lots of opportunities for improvement.

Keep in mind other distros may be using the files, so try not to break things for the other guy. We have to be mindful of lesser-used platforms and compilers, like AIX, Solaris, IBM xlC and Oracle's SunCC.

## License

Everything in this repo is release under Public Domain code. If the license or terms is unpalatable for you, then don't feel obligated to use it or commit.
