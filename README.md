# Crypto++ Autotools

This repository contains Autotools files for Wei Dai's Crypto++ (https://github.com/weidai11/cryptopp). It supplies `configure.ac` and `makefile.am` for Crypto++ for those who want to use Autotools.

The purpose of Crypto++ Autotools is (1) better support Linux distributions, like Debain, Fedora and openSUSE, (2) supplement the GNUmakefile which is reaching its limits with repsect to make-based configuration, and (3) utilize compiler feature probes that produce better results on ARM, MIPS and Power8 architectures.

The initial `Makefile.am` and `configure.ac` were shamelessly ripped from Debian. Many thanks to László Böszörményi for his work on the files and allowing us to use them as a starting point.

The Autotools files are currently a work in progress. Please feel free to make pull requests to fix problems.

# Workflow
The general workflow is clone Wei Dai's crypto++, add Autotools as a submodule, and then copy the files of interest into the Crypto++ directory:

    git clone https://github.com/weidai11/cryptopp.git
    cd cryptopp
    git submodule add https://github.com/noloader/cryptopp-autotools.git autotools
    git submodule update --remote

    cp "$PWD/autotools/Makefile.am" "$PWD"
    cp "$PWD/autotools/configure.ac" "$PWD"

To update the library and the submodule perform the following.

    cd cryptopp
	git pull
	git submodule update --remote

    cp "$PWD/autotools/Makefile.am" "$PWD"
    cp "$PWD/autotools/configure.ac" "$PWD"

Once the submodule is added or updated, then run:

    autoreconf --force --install
	./configure <options>
	make
	make test
	sudo make install <options>

Despite our efforts we have not been able to add the submodule to Crypto++ for seamless integration. If anyone knows how to add the submodule directly to the Crypto++ directory, then please provide the instructions.

# Integration
The Autotools submodule integrates with the Crypto++ library. The submodule overwrites the library's `config.h`. The submodule also removes the library's `GNUmakefile` and `GNUmakefile-cross`.

The library's `GNUmakefile` and `GNUmakefile-cross` were modified to clean the artifacts produced by Autotools. To clean the directory after running Autotools perform a `git checkout GNUmakefile` followed by a `make -f GNUmakefile distclean`.

# Future
The Autotools project files are separate at the moment for several reason, like avoiding Git log pollution with Autotool branch experiments. We also need to keep a logical separation because GNUmake is the official build system, and not the Autotools project files.

Eventually we would like to do two things. First, we would like to move this project from Jeff Walton's GitHub to Wei Dai's GitHub to provide stronger assurances on provenance. Second, we would like to provide an `autotools.tar.gz` and place it in the Crypto++ `TestScripts/` directory to make it easier for folks to use Autotools.
