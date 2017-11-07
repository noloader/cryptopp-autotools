## Makefile.am - Autotools configuration file for Crypto++.
##               written and placed in public domain by Jeffrey Walton.
##               based on Debian Makefile.am by László Böszörményi.
##
##    The GNUmakefile can generate the list of lib headers, lib sources,
##    test headers and test sources. Generate the list of files with the
##    following Awk. Thanks to igal for help with the Awk expression.
##
##        make sources | awk '{printf $0 " "} NR%6==0 {print "\\"}' RS=' '
##
##    Once "library sources" list is created, remove cryptlib.cpp, cpu.cpp,
##    integer.cpp; and remove all of the *-simd.cpp files. The remaining
##    list should be used for `libothers_la_SOURCES` below.
##
##    Note: configure.ac deletes GNUmakefile. You can get it back with:
##
##        git checkout GNUmakefile
##

## TODO:
##
##  - Add architecture specific flags to certain source files. This is partially implemented for most
##    Linux, but we still need Altivec and Power8. We also need IBM's xlC on AIX and Sun's CC on Solaris.
##
##    Automake does not support "specific flags for certain source files" natively, so we have to hack it.
##    https://www.gnu.org/software/automake/manual/html_node/Per_002dObject-Flags.html and
##    https://lists.gnu.org/archive/html/automake/2017-11/msg00000.html.
##
##  - Add -ffunction-sections, -fdata-sections, -Wl,--gc-sections, and -Wl,-dead_strip for IoT gadgets
##

AUTOMAKE_OPTIONS = foreign
ACLOCAL_AMFLAGS = -I m4
AM_DEFAULT_SOURCE_EXT = .cpp

## libcryptopp.la is created from disjoint libraries due to object file ordering and
## per-object file flags requirements. libcryptopp.la is named as the primary library,
## and the object files with special needs are listed as EXTRA_LTLIBRARIES. Also see
## https://lists.gnu.org/archive/html/automake/2017-11/msg00000.html.

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

## libcryptopp_la_SOURCES is empty because we need to create the library artifact from disjoint
## libraries due to object file ordering and per-object file flags requriements. Actually, the
## adhoc.cpp file is due to an automake issue of assuming C sources when the list is empty. Also
## https://lists.gnu.org/archive/html/automake/2017-11/msg00000.html.

libcryptopp_la_SOURCES = \
   adhoc.cpp

## Don't use EXTRA_ prefix for libcryptopp_la_LIBADD. It breaks Solaris.

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

## Don't use EXTRA_ prefix for libcryptopp_la_DEPENDENCIES. It breaks Solaris.

libcryptopp_la_DEPENDENCIES = \
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

## Very important... Version number of the library
libcryptopp_la_LDFLAGS = -version-info 6:0:0

## CRYPTOPP_CRYPTLIB_FLAG set in configure.ac
libcryptlib_la_SOURCES = cryptlib.cpp
libcryptlib_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_CRYPTLIB_FLAG)

## CRYPTOPP_CPU_FLAG set in configure.ac
libcpu_la_SOURCES = cpu.cpp
libcpu_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_CPU_FLAG)

## CRYPTOPP_INTEGER_FLAG set in configure.ac
libinteger_la_SOURCES = integer.cpp
libinteger_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_INTEGER_FLAG)

## CRYPTOPP_ARIA_FLAG set in configure.ac
libaria_simd_la_SOURCES = aria-simd.cpp
libaria_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_ARIA_FLAG)

## CRYPTOPP_BLAKE2_FLAG set in configure.ac
libblake2_simd_la_SOURCES = blake2-simd.cpp
libblake2_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_BLAKE2_FLAG)

## CRYPTOPP_CRC_FLAG set in configure.ac
libcrc_simd_la_SOURCES = crc-simd.cpp
libcrc_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_CRC_FLAG)

## CRYPTOPP_GCM_FLAG set in configure.ac
libgcm_simd_la_SOURCES = gcm-simd.cpp
libgcm_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_GCM_FLAG)

## CRYPTOPP_NEON_FLAG set in configure.ac
libneon_simd_la_SOURCES = neon-simd.cpp
libneon_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_NEON_FLAG)

## CRYPTOPP_PPC_FLAG set in configure.ac
libppc_simd_la_SOURCES = ppc-simd.cpp
libppc_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_PPC_FLAG)

## CRYPTOPP_AES_FLAG set in configure.ac
librijndael_simd_la_SOURCES = rijndael-simd.cpp
librijndael_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_AES_FLAG)

## CRYPTOPP_SHA_FLAG set in configure.ac
libsha_simd_la_SOURCES = sha-simd.cpp
libsha_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_SHA_FLAG)

## CRYPTOPP_SHA_FLAG set in configure.ac
libshacal2_simd_la_SOURCES = shacal2-simd.cpp
libshacal2_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_SHA_FLAG)

# This is the list of remaining sources files that don't need special order and don't need
# special flags. It is formed by removing cryptlib.cpp, cpu.cpp, integer.cpp and other
# source files with architectural specific flags. It is sorted in alphabetical order for
# deterministic builds.

libothers_la_SOURCES = \
   3way.cpp adler32.cpp algebra.cpp algparam.cpp arc4.cpp aria.cpp \
   ariatab.cpp asn.cpp authenc.cpp base32.cpp base64.cpp basecode.cpp \
   bfinit.cpp blake2.cpp blowfish.cpp blumshub.cpp camellia.cpp \
   cast.cpp casts.cpp cbcmac.cpp ccm.cpp chacha.cpp channels.cpp \
   cmac.cpp crc.cpp default.cpp des.cpp dessp.cpp \
   dh.cpp dh2.cpp dll.cpp dsa.cpp eax.cpp ec2n.cpp \
   eccrypto.cpp ecp.cpp elgamal.cpp emsa2.cpp eprecomp.cpp esign.cpp \
   files.cpp filters.cpp fips140.cpp fipstest.cpp gcm.cpp \
   gf256.cpp gf2_32.cpp gf2n.cpp gfpcrypt.cpp gost.cpp gzip.cpp \
   hex.cpp hmac.cpp hrtimer.cpp ida.cpp idea.cpp iterhash.cpp \
   kalyna.cpp kalynatab.cpp keccak.cpp luc.cpp mars.cpp marss.cpp \
   md2.cpp md4.cpp md5.cpp misc.cpp modes.cpp mqueue.cpp \
   mqv.cpp nbtheory.cpp network.cpp oaep.cpp osrng.cpp \
   padlkrng.cpp panama.cpp pkcspad.cpp poly1305.cpp polynomi.cpp \
   pssr.cpp pubkey.cpp queue.cpp rabin.cpp randpool.cpp rc2.cpp \
   rc5.cpp rc6.cpp rdrand.cpp rdtables.cpp rijndael.cpp \
   ripemd.cpp rng.cpp rsa.cpp rw.cpp safer.cpp salsa.cpp \
   seal.cpp seed.cpp serpent.cpp sha.cpp sha3.cpp \
   shacal2.cpp shark.cpp sharkbox.cpp skipjack.cpp socketft.cpp \
   sosemanuk.cpp square.cpp squaretb.cpp strciphr.cpp tea.cpp tftables.cpp \
   threefish.cpp tiger.cpp tigertab.cpp trdlocal.cpp ttmac.cpp twofish.cpp \
   vmac.cpp wait.cpp wake.cpp whrlpool.cpp xtr.cpp xtrcrypt.cpp \
   zdeflate.cpp zinflate.cpp zlib.cpp


#noinst_LIBRARIES = \
#   libcryptlib.la \
#   libcpu.la \
#   libinteger.la \
#   libaria_simd.la \
#   libblake2_simd.la \
#   libcrc_simd.la \
#   libgcm_simd.la \
#   libneon_simd.la \
#   libppc_simd.la \
#   librijndael_simd.la \
#   libsha_simd.la \
#   libshacal2_simd.la \
#   libothers.la

include_HEADERS = \
   3way.h adler32.h aes.h algebra.h algparam.h arc4.h argnames.h \
   aria.h asn.h authenc.h base32.h base64.h basecode.h blake2.h \
   blowfish.h blumshub.h camellia.h cast.h cbcmac.h ccm.h \
   chacha.h channels.h cmac.h config.h cpu.h crc.h \
   cryptlib.h default.h des.h dh.h dh2.h dll.h \
   dmac.h drbg.h dsa.h eax.h ec2n.h eccrypto.h \
   ecp.h ecpoint.h elgamal.h emsa2.h eprecomp.h esign.h \
   fhmqv.h files.h filters.h fips140.h fltrimpl.h gcm.h \
   gf256.h gf2_32.h gf2n.h gfpcrypt.h gost.h gzip.h \
   hex.h hkdf.h hmac.h hmqv.h hrtimer.h ida.h \
   idea.h integer.h iterhash.h kalyna.h keccak.h local.h \
   lubyrack.h luc.h mars.h md2.h md4.h md5.h \
   mdc.h mersenne.h misc.h modarith.h modes.h modexppc.h \
   mqueue.h mqv.h nbtheory.h network.h nr.h oaep.h \
   oids.h osrng.h ossig.h padlkrng.h panama.h pch.h \
   pkcspad.h poly1305.h polynomi.h ppc-crypto.h pssr.h pubkey.h \
   pwdbased.h queue.h rabin.h randpool.h rc2.h rc5.h \
   rc6.h rdrand.h rijndael.h ripemd.h rng.h rsa.h \
   rw.h safer.h salsa.h seal.h secblock.h seckey.h \
   seed.h serpent.h serpentp.h sha.h sha3.h shacal2.h \
   shark.h simple.h siphash.h skipjack.h smartptr.h socketft.h \
   sosemanuk.h square.h stdcpp.h strciphr.h tea.h threefish.h \
   tiger.h trap.h trdlocal.h trunhash.h ttmac.h twofish.h \
   vmac.h wait.h wake.h whrlpool.h winpipes.h words.h \
   xtr.h xtrcrypt.h zdeflate.h zinflate.h zlib.h

noinst_HEADERS = \
	local.h \
	bench.h \
	factory.h \
	resource.h \
	validate.h

bin_PROGRAMS = cryptest
noinst_PROGRAMS = cryptestcwd

cryptest_CXXFLAGS = $(AM_CXXFLAGS) -DCRYPTOPP_DATA_DIR='"@datadir@/@PACKAGE_TARNAME@/"'
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

cryptestcwd_CXXFLAGS = $(AM_CXXFLAGS)
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
cryptestcwd_LDADD = $(lib_LTLIBRARIES)

CLEANFILES = adhoc.cpp

## We need to copy the TestVectors/ and TestData/ to %{datadir}
## https://xaizek.github.io/2014-09-28/how-to-install-data-directory-with-automake/

testdata_DIR = @datadir@/@PACKAGE_TARNAME@/TestData
testvector_DIR = @datadir@/@PACKAGE_TARNAME@/TestVectors

## Automake bug workaround. If libcryptopp_la_SOURCES is an empty list, Automake assumes
## C source files and drives link through the C compiler. We provide the empty adhoc.cpp
## to get things back on course, so adhoc.cpp must always be copied.

adhoc.cpp:
	cp adhoc.cpp.proto adhoc.cpp
