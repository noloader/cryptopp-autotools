# Crypto++ Autotools

This repository contains Autotools files for Wei Dai's Crypto++ (https://github.com/weidai11/cryptopp). It supplies `configure.ac` and `makefile.am` for Crypto++ for those who want to use Autotools.

The purpose of Crypto++ Autotools is (1) better support Linux distributions, like Debain, Fedora and openSUSE, (2) supplement the GNUmakefile which is reaching its limits with repsect to make-based configuration, and (3) utilize compiler feature probes that produce better results on ARM and Power8 architectures.

# Workflow
The general workflow is clone Wei Dai's crypto++, and then add Autotools as a submodule:

    git clone https://github.com/weidai11/cryptopp.git
    cd cryptopp
    git submodule add https://github.com/noloader/cryptopp-autotools.git

Once the submodule is added, then run:

    autoreconf
	./configure <options>
	make
	make test
	sudo make install <options>

# Integration
The Autotools submodule integrates with the Crypto++ library. The submodule overwrites the library's `config.h`. The submodule also removes the library's `GNUmakefile` and `GNUmakefile-cross`.

The library's `GNUmakefile` and `GNUmakefile-cross` were modified to clean the artifacts produced by Autotools. To clean the directory perform a `git checkout GNUmakefile` followed by a `make -f GNUmakefile distclean`.

# Disposition
Eventually we would like to do two things. First, we would like to move this project from Jeff Walton's GitHub to Wei Dai's GitHub to provide stronger assurances on provenance. Second, we would like to provide an `autotools.tar.gz` and place it in the Crypto++ `TestScripts/` directory to make it easier for folks to use Autotools.