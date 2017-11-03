## Makefile.am - Autotools configuration file for Crypto++.
##               written and placed in public domain by Jeffrey Walton.
##               based on Debian Makefile.am by László Böszörményi.
##
##    The GNUmakefile can generate the list of lib headers, lib sources,
##    test headers and test sources. Generate the list of files with:
##
##        make sources | awk '{print "    " $0 " \\"}' RS=' '
##
##    Note: configure.ac deletes GNUmakefile. You can get it back with:
##
##        git checkout GNUmakefile
##

## TODO:
##
##  - Add architecture specific flags to certain source files. This is partially implemented, but
##    ordering of the object files and linking appears broken. For example, sha-simd.cpp needs
#     "-msse4.2 -msha" on IA-32, it needs "-march=armv8-a+crypto" on Aarch64, and it needs
##    "-mcpu=power8 -maltivec" on PowerPC. And we have not gotten into IBM's xlC and Sun's CC
##    compilers, which get similar (but different) flags. In our GNUmakefile the flags looks like:
##
##      # SSE4.2/SHA-NI or ARMv8a available
##      sha-simd.o : sha-simd.cpp
##          $(CXX) $(CXXFLAGS) $(SHA_FLAG) -c $<
##
##    Unfortunately, Automake does not support the pattern natively, so we have to hack it. Also see
##    https://www.gnu.org/software/automake/manual/html_node/Per_002dObject-Flags.html and
##    https://lists.gnu.org/archive/html/automake/2017-11/msg00000.html.
##
##  - Stop Automake from alphabetizing our object files when building libcryptopp_LTLIBRARIES. The source
##    files and object files are listed in a specific order due to Static Initialization Order Fiasco.
##
##  - Fix hard-coded path for PREFIX and CRYPTOPP_DATA_DIR.
##

AUTOMAKE_OPTIONS = foreign
ACLOCAL_AMFLAGS = -I m4
AM_DEFAULT_SOURCE_EXT = .cpp

## libcryptopp_la_LIBADD = -lpthread
## libcryptopp_la_LDFLAGS = -version-info 6:0:0

# libcryptopp.la is created from disjoint libraries due to object file ordering and
# per-object file flags requirements. libcryptopp.la is named as the primarly library,
# and the object files with special needs are listed as EXTRA_LTLIBRARIES. Also see
# https://lists.gnu.org/archive/html/automake/2017-11/msg00000.html.

lib_LTLIBRARIES = \
   libcryptopp.la

EXTRA_LTLIBRARIES = \
   libcryptlib.la \
   libcpu.la \
   libinteger.la \
   libaria_simd.la \
   libblake2_simd.la \
   libcrc_simd.la \
   libgcm_simd.la \
   libneon_simd.la \
   libppc_simd.la \
   librijndael_simd.la \
   libsha_simd.la \
   libshacal2_simd.la \
   libothers.la

# libcryptopp_la_SOURCES is empty because we need to create the library artifacts from disjoint
# libraries due to object file ordering and per-object file flags requriements. Also see
# https://lists.gnu.org/archive/html/automake/2017-11/msg00000.html.

libcryptopp_la_SOURCES =
libcryptopp_la_LIBADD = \
   $(libcryptlib_la_OBJECTS) \
   $(libcpu_la_OBJECTS) \
   $(libinteger_la_OBJECTS) \
   $(libaria_simd_la_OBJECTS) \
   $(libblake2_simd_la_OBJECTS) \
   $(libcrc_simd_la_OBJECTS) \
   $(libgcm_simd_la_OBJECTS) \
   $(libneon_simd_la_OBJECTS) \
   $(libppc_simd_la_OBJECTS) \
   $(librijndael_simd_la_OBJECTS) \
   $(libsha_simd_la_OBJECTS) \
   $(libshacal2_simd_la_OBJECTS) \
   $(libothers_la_OBJECTS)

CRYPTLIBFLAG =
libcryptlib_la_SOURCES = cryptlib.cpp
libcryptlib_la_CXXFLAGS = $(CRYPTLIBFLAG)

CPUFLAG = -msse2
libcpu_la_SOURCES = cpu.cpp
libcpu_la_CXXFLAGS = $(CPUFLAG)

INTEGER_FLAG =
libinteger_la_SOURCES = integer.cpp
libinteger_la_CXXFLAGS = $(INTEGERFLAG)

ARIAFLAG = -mssse3
libaria_simd_la_SOURCES = aria-simd.cpp
libaria_simd_la_CXXFLAGS = $(ARIAFLAG)

BLAKE2_FLAG = -msse4.2
libblake2_simd_la_SOURCES = blake2-simd.cpp
libblake2_simd_la_CXXFLAGS = $(BLAKE2_FLAG)

CRC_FLAG = -msse4.2
libcrc_simd_la_SOURCES = crc-simd.cpp
libcrc_simd_la_CXXFLAGS = $(CRC_FLAG)

GCM_FLAG = -mssse3 -mpclmul
libgcm_simd_la_SOURCES = gcm-simd.cpp
libgcm_simd_la_CXXFLAGS = $(GCM_FLAG)

NEON_FLAG =
libneon_simd_la_SOURCES = neon-simd.cpp
libneon_simd_la_CXXFLAGS = $(NEON_FLAG)

PPC_FLAG =
libppc_simd_la_SOURCES = ppc-simd.cpp
libppc_simd_la_CXXFLAGS = $(PPC_FLAG)

AES_FLAG = -msse4.1 -maes
librijndael_simd_la_SOURCES = rijndael-simd.cpp
librijndael_simd_la_CXXFLAGS = $(AES_FLAG)

SHA_FLAG = -msse4.2 -msha
libsha_simd_la_SOURCES = sha-simd.cpp
libsha_simd_la_CXXFLAGS = $(SHA_FLAG)

libshacal2_simd_la_SOURCES = shacal2-simd.cpp
libshacal2_simd_la_CXXFLAGS = $(SHA_FLAG)

# This is the list remaining sources files that don't need special order and don't need
# special flags. It is formed by removing cryptlib.cpp, cpu.cpp, integer.cpp and other
# source files with special architectural flags. Its is sorted in alphabetical order for
# deterministic builds.
libothers_la_SOURCES = \
   3way.cpp \
   adler32.cpp \
   algebra.cpp \
   algparam.cpp \
   arc4.cpp \
   aria.cpp \
   ariatab.cpp \
   asn.cpp \
   authenc.cpp \
   base32.cpp \
   base64.cpp \
   basecode.cpp \
   bfinit.cpp \
   blake2.cpp \
   blowfish.cpp \
   blumshub.cpp \
   camellia.cpp \
   cast.cpp \
   casts.cpp \
   cbcmac.cpp \
   ccm.cpp \
   chacha.cpp \
   channels.cpp \
   cmac.cpp \
   crc.cpp \
   default.cpp \
   des.cpp \
   dessp.cpp \
   dh.cpp \
   dh2.cpp \
   dll.cpp \
   dsa.cpp \
   eax.cpp \
   ec2n.cpp \
   eccrypto.cpp \
   ecp.cpp \
   elgamal.cpp \
   emsa2.cpp \
   eprecomp.cpp \
   esign.cpp \
   files.cpp \
   filters.cpp \
   fips140.cpp \
   fipstest.cpp \
   gcm.cpp \
   gf256.cpp \
   gf2_32.cpp \
   gf2n.cpp \
   gfpcrypt.cpp \
   gost.cpp \
   gzip.cpp \
   hex.cpp \
   hmac.cpp \
   hrtimer.cpp \
   ida.cpp \
   idea.cpp \
   iterhash.cpp \
   kalyna.cpp \
   kalynatab.cpp \
   keccak.cpp \
   luc.cpp \
   mars.cpp \
   marss.cpp \
   md2.cpp \
   md4.cpp \
   md5.cpp \
   misc.cpp \
   modes.cpp \
   mqueue.cpp \
   mqv.cpp \
   nbtheory.cpp \
   network.cpp \
   oaep.cpp \
   osrng.cpp \
   padlkrng.cpp \
   panama.cpp \
   pkcspad.cpp \
   poly1305.cpp \
   polynomi.cpp \
   pssr.cpp \
   pubkey.cpp \
   queue.cpp \
   rabin.cpp \
   randpool.cpp \
   rc2.cpp \
   rc5.cpp \
   rc6.cpp \
   rdrand.cpp \
   rdtables.cpp \
   rijndael.cpp \
   ripemd.cpp \
   rng.cpp \
   rsa.cpp \
   rw.cpp \
   safer.cpp \
   salsa.cpp \
   seal.cpp \
   seed.cpp \
   serpent.cpp \
   sha.cpp \
   sha3.cpp \
   shacal2.cpp \
   shark.cpp \
   sharkbox.cpp \
   skipjack.cpp \
   socketft.cpp \
   sosemanuk.cpp \
   square.cpp \
   squaretb.cpp \
   strciphr.cpp \
   tea.cpp \
   tftables.cpp \
   threefish.cpp \
   tiger.cpp \
   tigertab.cpp \
   trdlocal.cpp \
   ttmac.cpp \
   twofish.cpp \
   vmac.cpp \
   wait.cpp \
   wake.cpp \
   whrlpool.cpp \
   xtr.cpp \
   xtrcrypt.cpp \
   zdeflate.cpp \
   zinflate.cpp \
   zlib.cpp

#noinst_LIBRARIES = \
#   libcryptlib.a \
#   libcpu.a \
#   libinteger.a \
#   libaria_simd.a \
#   libblake2_simd.a \
#   libcrc_simd.a \
#   libgcm_simd.a \
#   libneon_simd.a \
#   libppc_simd.a \
#   librijndael_simd.a \
#   libsha_simd.a \
#   libshacal2_simd.a \
#   libothers_la.a

include_HEADERS = \
   3way.h \
   adler32.h \
   aes.h \
   algebra.h \
   algparam.h \
   arc4.h \
   argnames.h \
   aria.h \
   asn.h \
   authenc.h \
   base32.h \
   base64.h \
   basecode.h \
   blake2.h \
   blowfish.h \
   blumshub.h \
   camellia.h \
   cast.h \
   cbcmac.h \
   ccm.h \
   chacha.h \
   channels.h \
   cmac.h \
   config.h \
   cpu.h \
   crc.h \
   cryptlib.h \
   default.h \
   des.h \
   dh.h \
   dh2.h \
   dll.h \
   dmac.h \
   drbg.h \
   dsa.h \
   eax.h \
   ec2n.h \
   eccrypto.h \
   ecp.h \
   ecpoint.h \
   elgamal.h \
   emsa2.h \
   eprecomp.h \
   esign.h \
   fhmqv.h \
   files.h \
   filters.h \
   fips140.h \
   fltrimpl.h \
   gcm.h \
   gf256.h \
   gf2_32.h \
   gf2n.h \
   gfpcrypt.h \
   gost.h \
   gzip.h \
   hex.h \
   hkdf.h \
   hmac.h \
   hmqv.h \
   hrtimer.h \
   ida.h \
   idea.h \
   integer.h \
   iterhash.h \
   kalyna.h \
   keccak.h \
   local.h \
   lubyrack.h \
   luc.h \
   mars.h \
   md2.h \
   md4.h \
   md5.h \
   mdc.h \
   mersenne.h \
   misc.h \
   modarith.h \
   modes.h \
   modexppc.h \
   mqueue.h \
   mqv.h \
   nbtheory.h \
   network.h \
   nr.h \
   oaep.h \
   oids.h \
   osrng.h \
   ossig.h \
   padlkrng.h \
   panama.h \
   pch.h \
   pkcspad.h \
   poly1305.h \
   polynomi.h \
   ppc-crypto.h \
   pssr.h \
   pubkey.h \
   pwdbased.h \
   queue.h \
   rabin.h \
   randpool.h \
   rc2.h \
   rc5.h \
   rc6.h \
   rdrand.h \
   resource.h \
   rijndael.h \
   ripemd.h \
   rng.h \
   rsa.h \
   rw.h \
   safer.h \
   salsa.h \
   seal.h \
   secblock.h \
   seckey.h \
   seed.h \
   serpent.h \
   serpentp.h \
   sha.h \
   sha3.h \
   shacal2.h \
   shark.h \
   simple.h \
   siphash.h \
   skipjack.h \
   smartptr.h \
   socketft.h \
   sosemanuk.h \
   square.h \
   stdcpp.h \
   strciphr.h \
   tea.h \
   threefish.h \
   tiger.h \
   trap.h \
   trdlocal.h \
   trunhash.h \
   ttmac.h \
   twofish.h \
   vmac.h \
   wait.h \
   wake.h \
   whrlpool.h \
   winpipes.h \
   words.h \
   xtr.h \
   xtrcrypt.h \
   zdeflate.h \
   zinflate.h \
   zlib.h

noinst_HEADERS = \
	local.h \
	bench.h \
	factory.h \
	resource.h \
	validate.h

bin_PROGRAMS = cryptest cryptestcwd
## bin_PROGRAMS = cryptest
## noinst_bin_PROGRAMS = cryptestcwd

cryptest_CXXFLAGS = -DCRYPTOPP_DATA_DIR='"/usr/share/cryptopp/"'
cryptest_SOURCES = \
   test.cpp \
   bench1.cpp \
   bench2.cpp \
   validat0.cpp \
   validat1.cpp \
   validat2.cpp \
   validat3.cpp \
   datatest.cpp \
   regtest1.cpp \
   regtest2.cpp \
   regtest3.cpp \
   dlltest.cpp \
   fipsalgt.cpp

nodist_cryptest_SOURCES = adhoc.cpp
cryptest_LDADD = $(libcryptopp_LTLIBRARIES)
cryptestcwd_CXXFLAGS = $(CXXFLAGS)
cryptestcwd_SOURCES = \
   test.cpp \
   bench1.cpp \
   bench2.cpp \
   validat0.cpp \
   validat1.cpp \
   validat2.cpp \
   validat3.cpp \
   datatest.cpp \
   regtest1.cpp \
   regtest2.cpp \
   regtest3.cpp \
   dlltest.cpp \
   fipsalgt.cpp

nodist_cryptestcwd_SOURCES = adhoc.cpp

CLEANFILES = adhoc.cpp
cryptestcwd_LDADD = $(libcryptopp_LTLIBRARIES)

adhoc.cpp: Makefile
	if test -f adhoc.cpp; then      \
	  touch adhoc.cpp;              \
	else                            \
	  cp adhoc.cpp.proto adhoc.cpp; \
	fi
