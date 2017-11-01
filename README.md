# Crypto++ Autotools

This repository contains Autotools files for Wei Dai's Crypto++ (https://github.com/weidai11/cryptopp). It supplies `configure.ac` and `makefile.am` for Crypto++ for those who want to use Autotools.

The purpose of Crypto++ Autotools is (1) better support Linux distributions, like Debain, Fedora and openSUSE, (2) supplement the GNUmakefile which is reaching its limits with repsect to configuration, and (3) utilize compiler feature probes that produces better results on ARM and Power8 architectures.

# Workflow
The general workflow is clone Wei Dai's crypto++, and then add Autotools as a submodule:

    git clone https://github.com/weidai11/cryptopp.git
    cd cryptopp
    git submodule add https://github.com/noloader/cryptopp-autotools.git

Once the submodule is added, then run:

    XXX
