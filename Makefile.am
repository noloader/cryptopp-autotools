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
##  - Add architecture specific flags to certain source files
##    E.g., sha-simd.cpp needs "-msse4.2 -msha" on IA-32, it needs "-march=armv8-a+crypto" on Aarch64,
##    and it needs "-mcpu=power8 -maltivec" on PowerPC. And we have not gotten into IBM's xlC and
##    Sun's CC compilers, which get similar (but different) flags. In our GNUmakefile it looks like:
##
##      # SSE4.2/SHA-NI or ARMv8a available
##      sha-simd.o : sha-simd.cpp
##          $(CXX) $(CXXFLAGS) $(SHA_FLAG) -c $<
##
##    Unfortunately, Automake does not support the pattern natively, so we have to hack it. Also see
##    https://www.gnu.org/software/automake/manual/html_node/Per_002dObject-Flags.html
##
##  - Fix hard-coded path for PREFIX and CRYPTOPP_DATA_DIR.
##
##  - Stop Automake from alphabetizing our object files when building lib_LTLIBRARIES. The source
##    files and object files are listed in a specific order due to Static Initialization Order Fiasco.
##

AUTOMAKE_OPTIONS = foreign
ACLOCAL_AMFLAGS = -I m4
AM_DEFAULT_SOURCE_EXT = .cpp

# Automake has officially made it to the list of fucked up programs. We have to jump
# through hoops so we can add -mssse3 to aria-simd.cpp, -msse4.2 to blake2-simd.cpp,
# etc. Adding architectural flags is a basic operation in makefiles. It seems a lot
# like forgetting to provide the addition operation in mathematics.
noinst_LIBRARIES = \
   libcryptlib.a \
   libcpu.a \
   libinteger.a \
   libaria-simd.a \
   libblake2-simd.a \
   libcrc-simd.a \
   libgcm-simd.a \
   libneon-simd.a \
   libppc-simd.a \
   librijndael-simd.a \
   libsha-simd.a \
   libshacal2-simd.a

libcryptlib_a_SOURCES = cryptlib.cpp
libcryptlib_a_CXXFLAGS = $(CXXFLAGS)

CPU_FLAG = -msse2
libcpu_a_SOURCES = cpu.cpp
libcpu_a_CXXFLAGS = $(CXXFLAGS) $(CPU_FLAG)

libinteger_a_SOURCES = integer.cpp
libinteger_a_CXXFLAGS = $(CXXFLAGS)

ARIA_FLAG = -mssse3
libaria_simd_a_SOURCES = aria-simd.cpp
libaria_simd_a_CXXFLAGS = $(CXXFLAGS) $(ARIA_FLAG)

BLAKE2_FLAG = -msse4.2
libblake2_simd_a_SOURCES = blake2-simd.cpp
libblake2_simd_a_CXXFLAGS = $(CXXFLAGS) $(BLAKE2_FLAG)

CRC_FLAG = -msse4.2
libcrc_simd_a_SOURCES = crc-simd.cpp
libcrc_simd_a_CXXFLAGS = $(CXXFLAGS) $(CRC_FLAG)

GCM_FLAG = -mssse3 -mpclmul
libgcm_simd_a_SOURCES = gcm-simd.cpp
libgcm_simd_a_CXXFLAGS = $(CXXFLAGS) $(GCM_FLAG)

NEON_FLAG =
libneon_simd_a_SOURCES = neon-simd.cpp
libneon_simd_a_CXXFLAGS = $(CXXFLAGS) $(NEON_FLAG)

PPC_FLAG =
libppc_simd_a_SOURCES = ppc-simd.cpp
libppc_simd_a_CXXFLAGS = $(CXXFLAGS) $(PPC_FLAG)

AES_FLAG = -msse4.1 -maes
librijndael_simd_a_SOURCES = rijndael-simd.cpp
librijndael_simd_a_CXXFLAGS = $(CXXFLAGS) $(AES_FLAG)

SHA_FLAG = -msse4.2 -msha
libsha_simd_a_SOURCES = sha-simd.cpp
libsha_simd_a_CXXFLAGS = $(CXXFLAGS) $(SHA_FLAG)

libshacal2_simd_a_SOURCES = shacal2-simd.cpp
libshacal2_simd_a_CXXFLAGS = $(CXXFLAGS) $(SHA_FLAG)

## libcryptopp_la_LIBADD = -lpthread
## libcryptopp_la_LDFLAGS = -version-info 6:0:0

# lib_LTLIBRARIES = \
#   libcryptlib.a \
#   libcpu.a \
#   libinteger.a \
#   libaria-simd.a \
#   libblake2-simd.a \
#   libcrc-simd.a \
#   libgcm-simd.a \
#   libneon-simd.a \
#   libppc-simd.a \
#   librijndael-simd.a \
#   libsha-simd.a \
#   libshacal2-simd.a \
#   libcryptopp.la

lib_LTLIBRARIES = libcryptopp.la

libcryptopp_la_SOURCES = \
   `# cryptlib.cpp` \
   `# cpu.cpp` \
   `# integer.cpp` \
   3way.cpp \
   adler32.cpp \
   algebra.cpp \
   algparam.cpp \
   arc4.cpp \
   `# aria-simd.cpp` \
   aria.cpp \
   ariatab.cpp \
   asn.cpp \
   authenc.cpp \
   base32.cpp \
   base64.cpp \
   basecode.cpp \
   bfinit.cpp \
   `# blake2-simd.cpp` \
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
   `# crc-simd.cpp` \
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
   `# gcm-simd.cpp` \
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
   `# neon-simd.cpp` \
   network.cpp \
   oaep.cpp \
   osrng.cpp \
   padlkrng.cpp \
   panama.cpp \
   pkcspad.cpp \
   poly1305.cpp \
   polynomi.cpp \
   `# ppc-simd.cpp` \
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
   `# rijndael-simd.cpp` \
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
   `# sha-simd.cpp` \
   sha.cpp \
   sha3.cpp \
   `# shacal2-simd.cpp` \
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

cryptest_CXXFLAGS = $(CXXFLAGS) -DCRYPTOPP_DATA_DIR='"/usr/share/cryptopp/"'
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
cryptest_LDADD = $(lib_LTLIBRARIES)
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
cryptestcwd_LDADD = $(lib_LTLIBRARIES)

adhoc.cpp: Makefile
	if test -f adhoc.cpp; then      \
	  touch adhoc.cpp;              \
	else                            \
	  cp adhoc.cpp.proto adhoc.cpp; \
	fi
