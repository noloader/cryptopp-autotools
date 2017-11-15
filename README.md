# Crypto++ Autotools

This repository contains Autotools files for Wei Dai's Crypto++ (https://github.com/weidai11/cryptopp). It supplies `configure.ac` and `makefile.am` for Crypto++ for those who want to use Autotools. Autotools is officialy unsupported, so use it at your own risk.

The purpose of Crypto++ Autotools is three-fold:

1. better support Linux distributions, like Debain, Fedora and openSUSE
2. supplement the GNUmakefile which is reaching its limits with repsect to GNUmake-based configuration
3. utilize compiler feature probes that produce better results on ARM, MIPS and Power8 architectures

The initial `Makefile.am` and `configure.ac` were shamelessly ripped from Debian. Many thanks to László Böszörményi for his work on the files and allowing us to use them as a starting point. Nick Bowler and Mathieu Lirzin from the Automake mailing list were extremely helpful in porting our requirements to Automake.

The Autotools files are a work in progress, so use it at your own risk. The head notes in `configure.ac` and `makefile.am` list some outstanding items. Please feel free to make pull requests to fix problems.

# Workflow
The general workflow is clone Wei Dai's crypto++, add Autotools as a submodule, and then copy the files of interest into the Crypto++ directory:

    git clone https://github.com/weidai11/cryptopp.git
    cd cryptopp
    git submodule add https://github.com/noloader/cryptopp-autotools.git autotools
    git submodule update --remote

    cp "$PWD/autotools/Makefile.am" "$PWD"
    cp "$PWD/autotools/configure.ac" "$PWD"
    cp "$PWD/autotools/libcryptopp.pc.in" "$PWD"
    mkdir -p "$PWD/m4/"

Once the submodule is added or updated, then run the following. Our testing showed `autoupdate` produced bad results on some versions of Autotools, so be careful of running it before `autoreconf`.

    autoreconf --force --install --warnings=all
    ./configure <options>

    make
    make test
    sudo make install <options>

Best performance is obtained with `-O3` because GCC (and other compiler) apply vectorization optimizations. If you are not forced to `-O2` by policy (like Debian or Fedora), then you should configure with a higher optimization enabled:

    CXXFLAGS="-DNDEBUG -g2 -O3" ./configure <other options>

To update the library and the submodule perform the following. The `make clean` is needed because reconfigure'ing does not invalidate the previously built objects or artifacts.

    cd cryptopp
    git pull
    git submodule update --remote

    cp "$PWD/autotools/Makefile.am" "$PWD"
    cp "$PWD/autotools/configure.ac" "$PWD"
    cp "$PWD/autotools/libcryptopp.pc.in" "$PWD"

    make clean

Despite our efforts we have not been able to add the submodule to Crypto++ for seamless integration. If anyone knows how to add the submodule directly to the Crypto++ directory, then please provide the instructions.

# Prerequisites

Before running the Autotools project please ensure you have the following installed:

1. autoconf
2. automake
3. libtool

You may also need `libltdl-dev` on Debian and Ubuntu; and may need `libtool-ltdl-devel` on Fedora. MinGW and family need the Autoconf and Automake *wrappers* in addition to the Autoconf and Automake binaries.

If working on the GCC Compile Farm then you may need exta steps for systems like AIX. AIX offers updated Autoconf and Automake in `/opt/freeware/bin/`; and offers Libtool in `/opt/cfarm/libtool-2.4.2/bin/`. Both `bin/` need to be on path. When running `autoreconf` you must `autoreconf --force --install --include=/opt/cfarm/libtool-2.4.2/share/aclocal/`.

# Integration
The Autotools submodule integrates with the Crypto++ library. The submodule removes the library's `GNUmakefile` and `GNUmakefile-cross`. In the future we plan to overwrite the library's `config.h` and produce a n installation specific `config.h`.

The library's `GNUmakefile` and `GNUmakefile-cross` were modified to clean the artifacts produced by Autotools. To clean the directory after running Autotools perform a `git checkout GNUmakefile` followed by a `make -f GNUmakefile distclean`.

# Collaboration
We would like all distro maintainers to be collaborators on this repo. If you are a distro maintainer then please contact us so we can send you an invite.

If you are a collaborator then make changes as you see fit. You don't need to ask for permission to make a change. Noloader is not an Autotools expert so there are probably lots of opportunities for improvement.

Keep in mind other distros may be using the files, so try not to break things for the other guy. We have to be mindful of lesser-used platforms and compilers, like AIX, Solaris, IBM xlC and Oracle's SunCC.

Everything in this repo is release under Public Domain code. If the license or terms is unpalatable for you, then don't feel obligated to commit.

# Future
The Autotools project files are separate at the moment for several reason, like avoiding Git log pollution with Autotool branch experiments. We also need to keep a logical separation because GNUmake is the official build system, and not the Autotools project files.

Eventually we would like to do two things. First, we would like to move this project from Jeff Walton's GitHub to Wei Dai's GitHub to provide stronger assurances on provenance. Second, we would like to provide an `autotools.tar.gz` and place it in the Crypto++ `TestScripts/` directory to make it easier for folks to use Autotools.
