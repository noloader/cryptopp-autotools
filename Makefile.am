## Makefile.am - Autotools configuration file for Crypto++.
##               written and placed in public domain by Jeffrey Walton.
##               based on Debian Makefile.am by László Böszörményi.
##
##    The GNUmakefile can generate the list of lib headers, lib sources,
##    test headers and test sources. Generate the list of files with
##    'make sources'. Remove the SIMD files for libothers_la_SOURCES.
##    Thanks to steeldriver on U&L.SE for help with the sed.
##
##       make sources | sed 's|cryptlib.cpp cpu.cpp integer.cpp ||g' | \
##           sed -e 's|[[:alnum:]]*_simd.cpp ||g' | \
##           sed -e 's|[[:alnum:]]*_sse.cpp ||g' | \
##           sed -e 's|[[:alnum:]]*_avx.cpp ||g' | \
##           sed -e 's|[[:alnum:]]*_armv4.cpp ||g' | \
##           sed -e 's|[[:alnum:]]*_ppc.cpp ||g' | \
##           fold -s -w 72
##
##    The command `make sources | sed ... | fold` will create the source file
##    list that can be used with `libothers_la_SOURCES` below.
##
##    The list of header files can be built with 'make sources', too.
##
##       make sources | sed -e 's|[[:alnum:]]*_armv4.h ||g' \
##           fold -s -w 72
##
##    Note: configure.ac deletes GNUmakefile. You can get it back with:
##
##       git checkout GNUmakefile
##

##    Automake does not support "specific flags for certain source files"
##    natively, so we hack it. The hack include building 20 or so
##    libraries and then combining them into an archive or shared object.
##    Also see https://lists.gnu.org/archive/html/automake/2017-11/msg00000.html
##    https://www.gnu.org/software/automake/manual/html_node/Per_002dObject-Flags.html.
##
##    Visit the link below for the original Debian Autotools files
##    https://sources.debian.net/src/libcrypto++/5.6.4-8/debian/autotools/
##

## TODO:
##
##  - Figure out how to include TestPrograms/ in the dist tarball
##    TestPrograms/ is unique because it is included in dist tarball but not installed
##
##  - Figure out what's going on with DragonFly and dependencies
##

AUTOMAKE_OPTIONS = foreign
ACLOCAL_AMFLAGS = -I m4
AM_DEFAULT_SOURCE_EXT = .cpp

## libcryptopp.la is created from disjoint libraries due to object file
## ordering and per-object file flags requirements. libcryptopp.la is
## named as the primary library, and the object files with special needs
## are listed as EXTRA_LTLIBRARIES. Also see
## https://lists.gnu.org/archive/html/automake/2017-11/msg00000.html.

lib_LTLIBRARIES = \
   libcryptopp.la

EXTRA_LTLIBRARIES = \
   libcryptlib.la \
   libcpu.la \
   libinteger.la \
   libblake2s_simd.la \
   libblake2b_simd.la \
   libchacha_simd.la \
   libcham_simd.la \
   libcrc_simd.la \
   libgcm_simd.la \
   libgf2n_simd.la \
   libkeccak_simd.la \
   liblea_simd.la \
   librijndael_simd.la \
   libsha_simd.la \
   libshacal2_simd.la \
   libsimon128_simd.la \
   libspeck128_simd.la \
   libsm4_simd.la \
   libsse_simd.la

if CRYPTOPP_X86_SOURCES
   EXTRA_LTLIBRARIES += libchacha_avx.la
   EXTRA_LTLIBRARIES += libdonna_sse.la
   EXTRA_LTLIBRARIES += liblsh256_sse.la
   EXTRA_LTLIBRARIES += liblsh256_avx.la
   EXTRA_LTLIBRARIES += liblsh512_sse.la
   EXTRA_LTLIBRARIES += liblsh512_avx.la
endif

if CRYPTOPP_ARM32_SOURCES
   EXTRA_LTLIBRARIES += libneon_simd.la
endif

if CRYPTOPP_ARMV8_SOURCES
   EXTRA_LTLIBRARIES += libneon_simd.la
endif

if CRYPTOPP_PPC_SOURCES
   EXTRA_LTLIBRARIES += libppc_simd.la
   EXTRA_LTLIBRARIES += libpower7_ppc.la
   EXTRA_LTLIBRARIES += libpower8_ppc.la
   EXTRA_LTLIBRARIES += libpower9_ppc.la
endif

## ARMv7-a AES and SHA by Andy Polyakov
if CRYPTOGAMS_ARM_SOURCES
   EXTRA_LTLIBRARIES += libaes_armv4.la
   EXTRA_LTLIBRARIES += libsha1_armv4.la
   EXTRA_LTLIBRARIES += libsha256_armv4.la
   EXTRA_LTLIBRARIES += libsha512_armv4.la
endif

## The remainder of the source files
EXTRA_LTLIBRARIES += libothers.la

## libcryptopp_la_SOURCES is empty because we need to create the library
## artifact from disjoint libraries due to object file ordering and
## per-object file flags requriements. Actually, the adhoc.cpp file is
## due to an automake issue of assuming C sources when the list is empty.
## https://lists.gnu.org/archive/html/automake/2017-11/msg00000.html.

libcryptopp_la_SOURCES = \
   adhoc.cpp

## Don't use EXTRA_ prefix for libcryptopp_la_LIBADD. It breaks Solaris.

libcryptopp_la_LIBADD = \
   $(libcryptlib_la_OBJECTS) \
   $(libcpu_la_OBJECTS) \
   $(libinteger_la_OBJECTS) \
   $(libblake2s_simd_la_OBJECTS) \
   $(libblake2b_simd_la_OBJECTS) \
   $(libchacha_simd_la_OBJECTS) \
   $(libcham_simd_la_OBJECTS) \
   $(libcrc_simd_la_OBJECTS) \
   $(libgcm_simd_la_OBJECTS) \
   $(libgf2n_simd_la_OBJECTS) \
   $(libkeccak_simd_la_OBJECTS) \
   $(liblea_simd_la_OBJECTS) \
   $(librijndael_simd_la_OBJECTS) \
   $(libsha_simd_la_OBJECTS) \
   $(libshacal2_simd_la_OBJECTS) \
   $(libsimon128_simd_la_OBJECTS) \
   $(libspeck128_simd_la_OBJECTS) \
   $(libsm4_simd_la_OBJECTS) \
   $(libsse_simd_la_OBJECTS)

if CRYPTOPP_X86_SOURCES
   libcryptopp_la_LIBADD += $(libchacha_avx_la_OBJECTS)
   libcryptopp_la_LIBADD += $(libdonna_sse_la_OBJECTS)
   libcryptopp_la_LIBADD += $(liblsh256_sse_la_OBJECTS)
   libcryptopp_la_LIBADD += $(liblsh256_avx_la_OBJECTS)
   libcryptopp_la_LIBADD += $(liblsh512_sse_la_OBJECTS)
   libcryptopp_la_LIBADD += $(liblsh512_avx_la_OBJECTS)
endif

if CRYPTOPP_ARM32_SOURCES
   libcryptopp_la_LIBADD += $(libneon_simd_la_OBJECTS)
endif

if CRYPTOPP_ARMV8_SOURCES
   libcryptopp_la_LIBADD += $(libneon_simd_la_OBJECTS)
endif

if CRYPTOPP_PPC_SOURCES
   libcryptopp_la_LIBADD += $(libppc_simd_la_OBJECTS)
   libcryptopp_la_LIBADD += $(libpower7_ppc_la_OBJECTS)
   libcryptopp_la_LIBADD += $(libpower8_ppc_la_OBJECTS)
   libcryptopp_la_LIBADD += $(libpower9_ppc_la_OBJECTS)
endif

## ARMv7-a AES and SHA by Andy Polyakov
if CRYPTOGAMS_ARM_SOURCES
   libcryptopp_la_LIBADD += $(libaes_armv4_la_OBJECTS)
   libcryptopp_la_LIBADD += $(libsha1_armv4_la_OBJECTS)
   libcryptopp_la_LIBADD += $(libsha256_armv4_la_OBJECTS)
   libcryptopp_la_LIBADD += $(libsha512_armv4_la_OBJECTS)
endif

## cpufeatures library on Android
if ANDROID_CPUFEATURES_SOURCES
   libcryptopp_la_LIBADD += $(libcpufeatures_la_OBJECTS)
endif

## The remainder of the object files
libcryptopp_la_LIBADD += $(libothers_la_OBJECTS)

## Don't use EXTRA_ prefix for libcryptopp_la_DEPENDENCIES. It breaks Solaris.

libcryptopp_la_DEPENDENCIES = \
   $(libcryptlib_la_OBJECTS) \
   $(libcpu_la_OBJECTS) \
   $(libinteger_la_OBJECTS) \
   $(libblake2s_simd_la_OBJECTS) \
   $(libblake2b_simd_la_OBJECTS) \
   $(libchacha_simd_la_OBJECTS) \
   $(libcham_simd_la_OBJECTS) \
   $(libcrc_simd_la_OBJECTS) \
   $(libgcm_simd_la_OBJECTS) \
   $(libgf2n_simd_la_OBJECTS) \
   $(libkeccak_simd_la_OBJECTS) \
   $(liblea_simd_la_OBJECTS) \
   $(librijndael_simd_la_OBJECTS) \
   $(libsha_simd_la_OBJECTS) \
   $(libshacal2_simd_la_OBJECTS) \
   $(libsimon128_simd_la_OBJECTS) \
   $(libspeck128_simd_la_OBJECTS) \
   $(libsm4_simd_la_OBJECTS) \
   $(libsse_simd_la_OBJECTS)

if CRYPTOPP_X86_SOURCES
   libcryptopp_la_DEPENDENCIES += $(libchacha_avx_la_OBJECTS)
   libcryptopp_la_DEPENDENCIES += $(libdonna_sse_la_OBJECTS)
   libcryptopp_la_DEPENDENCIES += $(liblsh256_sse_la_OBJECTS)
   libcryptopp_la_DEPENDENCIES += $(liblsh512_sse_la_OBJECTS)
   libcryptopp_la_DEPENDENCIES += $(liblsh256_avx_la_OBJECTS)
   libcryptopp_la_DEPENDENCIES += $(liblsh512_avx_la_OBJECTS)
endif

if CRYPTOPP_ARM32_SOURCES
   libcryptopp_la_DEPENDENCIES += $(libneon_simd_la_OBJECTS)
endif

if CRYPTOPP_ARMV8_SOURCES
   libcryptopp_la_DEPENDENCIES += $(libneon_simd_la_OBJECTS)
endif

if CRYPTOPP_PPC_SOURCES
   libcryptopp_la_DEPENDENCIES += $(libppc_simd_la_OBJECTS)
   libcryptopp_la_DEPENDENCIES += $(libpower7_ppc_la_OBJECTS)
   libcryptopp_la_DEPENDENCIES += $(libpower8_ppc_la_OBJECTS)
   libcryptopp_la_DEPENDENCIES += $(libpower9_ppc_la_OBJECTS)
endif

## ARMv7-a AES and SHA by Andy Polyakov
if CRYPTOGAMS_ARM_SOURCES
   libcryptopp_la_DEPENDENCIES += $(libaes_armv4_la_OBJECTS)
   libcryptopp_la_DEPENDENCIES += $(libsha1_armv4_la_OBJECTS)
   libcryptopp_la_DEPENDENCIES += $(libsha256_armv4_la_OBJECTS)
   libcryptopp_la_DEPENDENCIES += $(libsha512_armv4_la_OBJECTS)
endif

## cpufeatures library on Android
if ANDROID_CPUFEATURES_SOURCES
   libcryptopp_la_DEPENDENCIES += $(libcpufeatures_la_OBJECTS)
endif

## The remainder of the object files
libcryptopp_la_DEPENDENCIES += $(libothers_la_OBJECTS)

## Man, did Autotools fuck this up royally...
## https://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html
libcryptopp_la_LDFLAGS = $(AM_LDFLAGS) -release 8.8.0 -version-info 8:8

## Source files with special needs
libcryptlib_la_SOURCES = cryptlib.cpp
libcryptlib_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS)

libcpu_la_SOURCES = cpu.cpp
libcpu_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS)

libinteger_la_SOURCES = integer.cpp
libinteger_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS)

libblake2s_simd_la_SOURCES = blake2s_simd.cpp
libblake2s_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_BLAKE2S_FLAG)

libblake2b_simd_la_SOURCES = blake2b_simd.cpp
libblake2b_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_BLAKE2B_FLAG)

libchacha_simd_la_SOURCES = chacha_simd.cpp
libchacha_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_CHACHA_FLAG)

libchacha_avx_la_SOURCES = chacha_avx.cpp
libchacha_avx_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_CHACHA_AVX2_FLAG)

libcham_simd_la_SOURCES = cham_simd.cpp
libcham_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_CHAM_FLAG)

libcrc_simd_la_SOURCES = crc_simd.cpp
libcrc_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_CRC_FLAG)

libdonna_sse_la_SOURCES = donna_sse.cpp
libdonna_sse_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_DONNA_FLAG)

libgcm_simd_la_SOURCES = gcm_simd.cpp
libgcm_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_GCM_FLAG)

libgf2n_simd_la_SOURCES = gf2n_simd.cpp
libgf2n_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_GF2N_FLAG)

libkeccak_simd_la_SOURCES = keccak_simd.cpp
libkeccak_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_KECCAK_FLAG)

liblea_simd_la_SOURCES = lea_simd.cpp
liblea_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_LEA_FLAG)

liblsh256_sse_la_SOURCES = lsh256_sse.cpp
liblsh256_sse_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_LSH256_FLAG)

liblsh256_avx_la_SOURCES = lsh256_avx.cpp
liblsh256_avx_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_LSH256_AVX2_FLAG)

liblsh512_sse_la_SOURCES = lsh512_sse.cpp
liblsh512_sse_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_LSH512_FLAG)

liblsh512_avx_la_SOURCES = lsh512_avx.cpp
liblsh512_avx_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_LSH512_AVX2_FLAG)

libneon_simd_la_SOURCES = neon_simd.cpp
libneon_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_NEON_FLAG)

libppc_simd_la_SOURCES = ppc_simd.cpp
libppc_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_ALTIVEC_FLAG)

libpower7_ppc_la_SOURCES = power7_ppc.cpp
libpower7_ppc_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_POWER7_FLAG)

libpower8_ppc_la_SOURCES = power8_ppc.cpp
libpower8_ppc_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_POWER8_FLAG)

libpower9_ppc_la_SOURCES = power9_ppc.cpp
libpower9_ppc_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_POWER9_FLAG)

librijndael_simd_la_SOURCES = rijndael_simd.cpp
librijndael_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_AES_FLAG)

libsha_simd_la_SOURCES = sha_simd.cpp
libsha_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_SHA_FLAG)

libshacal2_simd_la_SOURCES = shacal2_simd.cpp
libshacal2_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_SHA_FLAG)

libsimon128_simd_la_SOURCES = simon128_simd.cpp
libsimon128_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_SIMON128_FLAG)

libspeck128_simd_la_SOURCES = speck128_simd.cpp
libspeck128_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_SPECK128_FLAG)

libsm4_simd_la_SOURCES = sm4_simd.cpp
libsm4_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_SM4_FLAG)

libsse_simd_la_SOURCES = sse_simd.cpp
libsse_simd_la_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTOPP_SSE2_FLAG)

## ARMv7-a AES and SHA by Andy Polyakov
## Also see https://stackoverflow.com/q/51575580/608639
if CRYPTOGAMS_ARM_SOURCES
   libaes_armv4_la_SOURCES = aes_armv4.S
   libsha1_armv4_la_SOURCES = sha1_armv4.S
   libsha256_armv4_la_SOURCES = sha256_armv4.S
   libsha512_armv4_la_SOURCES = sha512_armv4.S
   libaes_armv4_la_CCASFLAGS = $(AM_CPPFLAGS) $(AM_ASFLAGS) $(AM_CXXFLAGS) $(CRYPTOGAMS_ARM_THUMB_FLAG)
   libsha1_armv4_la_CCASFLAGS = $(AM_CPPFLAGS) $(AM_ASFLAGS) $(AM_CXXFLAGS) $(CRYPTOGAMS_ARM_FLAG)
   libsha256_armv4_la_CCASFLAGS = $(AM_CPPFLAGS) $(AM_ASFLAGS) $(AM_CXXFLAGS) $(CRYPTOGAMS_ARM_FLAG)
   libsha512_armv4_la_CCASFLAGS = $(AM_CPPFLAGS) $(AM_ASFLAGS) $(AM_CXXFLAGS) $(CRYPTOGAMS_ARM_FLAG)
endif

## cpufeatures library on Android
if ANDROID_CPUFEATURES_SOURCES
   libcpufeatures_la_SOURCES = cpu-features.c
endif

# This is the list of remaining sources files that don't need special order
# and don't need special flags. It is formed by removing cryptlib.cpp,
# cpu.cpp, integer.cpp, *_avx.cpp and *_simd.cpp files. It is sorted in
# alphabetical order for deterministic builds.

# To build this list, see the head notes.
libothers_la_SOURCES = \
	3way.cpp adler32.cpp algebra.cpp algparam.cpp allocate.cpp arc4.cpp \
	aria.cpp ariatab.cpp asn.cpp authenc.cpp base32.cpp base64.cpp \
	basecode.cpp bfinit.cpp blake2.cpp blowfish.cpp blumshub.cpp \
	camellia.cpp cast.cpp casts.cpp cbcmac.cpp ccm.cpp chacha.cpp \
	chachapoly.cpp cham.cpp channels.cpp cmac.cpp crc.cpp darn.cpp \
	default.cpp des.cpp dessp.cpp dh.cpp dh2.cpp dll.cpp donna_32.cpp \
	donna_64.cpp dsa.cpp eax.cpp ec2n.cpp eccrypto.cpp ecp.cpp elgamal.cpp \
	emsa2.cpp eprecomp.cpp esign.cpp files.cpp filters.cpp fips140.cpp \
	fipstest.cpp gcm.cpp gf256.cpp gf2_32.cpp gf2n.cpp gfpcrypt.cpp \
	gost.cpp gzip.cpp hc128.cpp hc256.cpp hex.cpp hight.cpp hmac.cpp \
	hrtimer.cpp ida.cpp idea.cpp iterhash.cpp kalyna.cpp kalynatab.cpp \
	keccak.cpp keccak_core.cpp lea.cpp lsh256.cpp lsh512.cpp luc.cpp \
	mars.cpp marss.cpp md2.cpp md4.cpp md5.cpp misc.cpp modes.cpp \
	mqueue.cpp mqv.cpp nbtheory.cpp oaep.cpp osrng.cpp padlkrng.cpp \
	panama.cpp pkcspad.cpp poly1305.cpp polynomi.cpp primetab.cpp pssr.cpp \
	pubkey.cpp queue.cpp rabbit.cpp rabin.cpp randpool.cpp rc2.cpp rc5.cpp \
	rc6.cpp rdrand.cpp rdtables.cpp rijndael.cpp ripemd.cpp rng.cpp rsa.cpp \
	rw.cpp safer.cpp salsa.cpp scrypt.cpp seal.cpp seed.cpp serpent.cpp \
	sha.cpp sha3.cpp shacal2.cpp shake.cpp shark.cpp sharkbox.cpp \
	simeck.cpp simon.cpp skipjack.cpp sm3.cpp sm4.cpp sosemanuk.cpp \
	speck.cpp square.cpp squaretb.cpp strciphr.cpp tea.cpp tftables.cpp \
	threefish.cpp tiger.cpp tigertab.cpp ttmac.cpp tweetnacl.cpp \
	twofish.cpp vmac.cpp wake.cpp whrlpool.cpp xed25519.cpp xtr.cpp \
	xtrcrypt.cpp xts.cpp zdeflate.cpp zinflate.cpp zlib.cpp

# To build this list, see the head notes.
pkginclude_HEADERS = \
	3way.h adler32.h adv_simd.h aes.h aes_armv4.h algebra.h algparam.h \
	allocate.h arc4.h argnames.h aria.h arm_simd.h asn.h authenc.h base32.h \
	base64.h basecode.h blake2.h blowfish.h blumshub.h camellia.h cast.h \
	cbcmac.h ccm.h chacha.h chachapoly.h cham.h channels.h cmac.h config.h \
	config_align.h config_asm.h config_cpu.h config_cxx.h config_dll.h \
	config_int.h config_misc.h config_ns.h config_os.h config_ver.h cpu.h \
	crc.h cryptlib.h darn.h default.h des.h dh.h dh2.h dll.h dmac.h donna.h \
	donna_32.h donna_64.h donna_sse.h drbg.h dsa.h eax.h ec2n.h eccrypto.h \
	ecp.h ecpoint.h elgamal.h emsa2.h eprecomp.h esign.h fhmqv.h files.h \
	filters.h fips140.h fltrimpl.h gcm.h gf256.h gf2_32.h gf2n.h gfpcrypt.h \
	gost.h gzip.h hashfwd.h hc128.h hc256.h hex.h hight.h hkdf.h hmac.h \
	hmqv.h hrtimer.h ida.h idea.h integer.h iterhash.h kalyna.h keccak.h \
	lea.h lsh.h lubyrack.h luc.h mars.h md2.h md4.h md5.h mdc.h mersenne.h \
	misc.h modarith.h modes.h modexppc.h mqueue.h mqv.h naclite.h \
	nbtheory.h nr.h oaep.h oids.h osrng.h ossig.h padlkrng.h panama.h pch.h \
	pkcspad.h poly1305.h polynomi.h ppc_simd.h pssr.h pubkey.h pwdbased.h \
	queue.h rabbit.h rabin.h randpool.h rc2.h rc5.h rc6.h rdrand.h \
	rijndael.h ripemd.h rng.h rsa.h rw.h safer.h salsa.h scrypt.h seal.h \
	secblock.h secblockfwd.h seckey.h seed.h serpent.h serpentp.h sha.h \
	sha1_armv4.h sha256_armv4.h sha3.h sha512_armv4.h shacal2.h shake.h \
	shark.h simeck.h simon.h simple.h siphash.h skipjack.h sm3.h sm4.h \
	smartptr.h sosemanuk.h speck.h square.h stdcpp.h strciphr.h tea.h \
	threefish.h tiger.h trap.h trunhash.h ttmac.h tweetnacl.h twofish.h \
	vmac.h wake.h whrlpool.h words.h xed25519.h xtr.h xtrcrypt.h xts.h \
	zdeflate.h zinflate.h zlib.h

noinst_HEADERS = \
    local.h \
    bench.h \
    factory.h \
    resource.h \
    validate.h \
    aes_armv4.h \
    sha1_armv4.h \
    sha256_armv4.h \
    sha512_armv4.h

bin_PROGRAMS = cryptest$(EXEEXT)

cryptest_CXXFLAGS = $(AM_CPPFLAGS) $(AM_CXXFLAGS) $(CRYPTEST_CXXFLAGS) -DCRYPTOPP_DATA_DIR='"${pkgdatadir}/"'
cryptest_SOURCES = \
    test.cpp bench1.cpp bench2.cpp bench3.cpp datatest.cpp \
    dlltest.cpp fipsalgt.cpp validat0.cpp validat1.cpp validat2.cpp \
    validat3.cpp validat4.cpp validat5.cpp validat6.cpp validat7.cpp \
    validat8.cpp validat9.cpp validat10.cpp regtest1.cpp regtest2.cpp \
    regtest3.cpp regtest4.cpp

nodist_cryptest_SOURCES = adhoc.cpp
cryptest_LDADD = $(lib_LTLIBRARIES)

CLEANFILES = adhoc.cpp

## Copy the TestVectors/ and TestData/ to ${pkgdatadir}.
## TestPrograms/ is included in the tarball but not installed.
## https://www.gnu.org/software/automake/manual/html_node/Data.html

# Create with 'ls TestData/*.dat'. These files get installed.
testdata_FILES = \
	TestData/3desval.dat     TestData/fhmqv384.dat  TestData/rc6val.dat \
	TestData/3wayval.dat     TestData/fhmqv512.dat  TestData/rijndael.dat \
	TestData/aria.dat        TestData/gostval.dat   TestData/rsa1024.dat \
	TestData/camellia.dat    TestData/hmqv160.dat   TestData/rsa2048a.dat \
	TestData/cast128v.dat    TestData/hmqv256.dat   TestData/rsa2048.dat \
	TestData/cast256v.dat    TestData/hmqv384.dat   TestData/rsa400pb.dat \
	TestData/descert.dat     TestData/hmqv512.dat   TestData/rsa400pv.dat \
	TestData/dh1024.dat      TestData/ideaval.dat   TestData/rsa512a.dat \
	TestData/dh2048.dat      TestData/luc1024.dat   TestData/rw1024.dat \
	TestData/dlie1024.dat    TestData/luc2048.dat   TestData/rw2048.dat \
	TestData/dlie2048.dat    TestData/lucc1024.dat  TestData/saferval.dat \
	TestData/dsa1024b.dat    TestData/lucc512.dat   TestData/serpentv.dat \
	TestData/dsa1024.dat     TestData/lucd1024.dat  TestData/shacal2v.dat \
	TestData/dsa512.dat      TestData/lucd512.dat   TestData/sharkval.dat \
	TestData/ecies_p160.dat  TestData/lucs1024.dat  TestData/skipjack.dat \
	TestData/ecies_t163.dat  TestData/lucs512.dat   TestData/squareva.dat \
	TestData/ed25519.dat     TestData/marsval.dat   TestData/twofishv.dat \
	TestData/ed25519v0.dat   TestData/mqv1024.dat   TestData/usage.dat \
	TestData/ed25519v1.dat   TestData/mqv2048.dat   TestData/x25519.dat \
	TestData/elgc1024.dat    TestData/nr1024.dat    TestData/x25519v0.dat \
	TestData/esig1023.dat    TestData/nr2048.dat    TestData/x25519v1.dat \
	TestData/esig1536.dat    TestData/rabi1024.dat  TestData/xtrdh171.dat \
	TestData/esig2046.dat    TestData/rabi2048.dat  TestData/xtrdh342.dat \
	TestData/fhmqv160.dat    TestData/rc2val.dat \
	TestData/fhmqv256.dat    TestData/rc5val.dat

# Create with 'ls TestVectors/*.txt'. These files get installed.
# OCB mode is not part of the release tarball, so manually remove it.
testvector_FILES = \
	TestVectors/aead.txt              TestVectors/rsa_oaep.txt \
	TestVectors/aes.txt               TestVectors/rsa_pkcs1_1_5.txt \
	TestVectors/all.txt               TestVectors/rsa_pss.txt \
	TestVectors/aria.txt              TestVectors/rw.txt \
	TestVectors/blake2b.txt           TestVectors/salsa.txt \
	TestVectors/blake2s.txt           TestVectors/seal.txt \
	TestVectors/blake2.txt            TestVectors/seed.txt \
	TestVectors/camellia.txt          TestVectors/sha1_160_fips_180.txt \
	TestVectors/ccm.txt               TestVectors/sha1_fips_180.txt \
	TestVectors/chacha20poly1305.txt  TestVectors/sha2_224_fips_180.txt \
	TestVectors/chacha_tls.txt        TestVectors/sha2_256_fips_180.txt \
	TestVectors/chacha.txt            TestVectors/sha2_384_fips_180.txt \
	TestVectors/cham.txt              TestVectors/sha2_512_fips_180.txt \
	TestVectors/cmac.txt              TestVectors/sha2_fips_180.txt \
	TestVectors/dlies.txt             TestVectors/sha2.txt \
	TestVectors/dsa_1363.txt          TestVectors/sha3_224_fips_202.txt \
	TestVectors/dsa_rfc6979.txt       TestVectors/sha3_256_fips_202.txt \
	TestVectors/dsa.txt               TestVectors/sha3_384_fips_202.txt \
	TestVectors/eax.txt               TestVectors/sha3_512_fips_202.txt \
	TestVectors/esign.txt             TestVectors/sha3_fips_202.txt \
	TestVectors/gcm.txt               TestVectors/sha3.txt \
	TestVectors/hc128.txt             TestVectors/shacal2.txt \
	TestVectors/hc256.txt             TestVectors/shake.txt \
	TestVectors/hight.txt             TestVectors/sha.txt \
	TestVectors/hkdf.txt              TestVectors/simeck.txt \
	TestVectors/hmac.txt              TestVectors/simon.txt \
	TestVectors/kalyna.txt            TestVectors/siphash.txt \
	TestVectors/keccak.txt            TestVectors/skipjack.txt \
	TestVectors/lea.txt               TestVectors/sm3.txt \
	TestVectors/lsh256.txt            TestVectors/sm4.txt \
	TestVectors/lsh512_256.txt        TestVectors/sosemanuk.txt \
	TestVectors/lsh512.txt            TestVectors/speck.txt \
	TestVectors/lsh.txt               TestVectors/tea.txt \
	TestVectors/mars.txt              TestVectors/threefish.txt \
	TestVectors/nr.txt                TestVectors/ttmac.txt \
	                                  TestVectors/vmac.txt \
	TestVectors/panama.txt            TestVectors/wake.txt \
	TestVectors/poly1305aes.txt       TestVectors/whrlpool.txt \
	TestVectors/poly1305_tls.txt      TestVectors/xchacha.txt \
	TestVectors/rabbit.txt            TestVectors/xts.txt \
	TestVectors/Readme.txt

# Create with 'ls TestPrograms/test_*.cpp'. These files do not get installed.
# They exist so the feature tests can be run from the configure directory.
testprogs_FILES= \
	TestPrograms/test_32bit.cpp \
	TestPrograms/test_64bit.cpp \
	TestPrograms/test_arm_acle_header.cpp \
	TestPrograms/test_arm_aes.cpp \
	TestPrograms/test_arm_armv7.cpp \
	TestPrograms/test_arm_asimd.cpp \
	TestPrograms/test_arm_crc.cpp \
	TestPrograms/test_arm_neon.cpp \
	TestPrograms/test_arm_neon_header.cpp \
	TestPrograms/test_arm_pmull.cpp \
	TestPrograms/test_arm_sha1.cpp \
	TestPrograms/test_arm_sha256.cpp \
	TestPrograms/test_arm_sha3.cpp \
	TestPrograms/test_arm_sha512.cpp \
	TestPrograms/test_arm_sm3.cpp \
	TestPrograms/test_arm_sm4.cpp \
	TestPrograms/test_asm_mixed.cpp \
	TestPrograms/test_cxx11_alignas.cpp \
	TestPrograms/test_cxx11_alignof.cpp \
	TestPrograms/test_cxx11_assert.cpp \
	TestPrograms/test_cxx11_atomic.cpp \
	TestPrograms/test_cxx11_auto.cpp \
	TestPrograms/test_cxx11_constexpr.cpp \
	TestPrograms/test_cxx11.cpp \
	TestPrograms/test_cxx11_deletefn.cpp \
	TestPrograms/test_cxx11_enumtype.cpp \
	TestPrograms/test_cxx11_initializer.cpp \
	TestPrograms/test_cxx11_lambda.cpp \
	TestPrograms/test_cxx11_noexcept.cpp \
	TestPrograms/test_cxx11_nullptr.cpp \
	TestPrograms/test_cxx11_staticinit.cpp \
	TestPrograms/test_cxx11_sync.cpp \
	TestPrograms/test_cxx11_vartemplates.cpp \
	TestPrograms/test_cxx14.cpp \
	TestPrograms/test_cxx17_assert.cpp \
	TestPrograms/test_cxx17.cpp \
	TestPrograms/test_cxx17_exceptions.cpp \
	TestPrograms/test_cxx98_exception.cpp \
	TestPrograms/test_cxx.cpp \
	TestPrograms/test_glibc.cpp \
	TestPrograms/test_newlib.cpp \
	TestPrograms/test_nodevirtualize.cpp \
	TestPrograms/test_ppc_aes.cpp \
	TestPrograms/test_ppc_altivec.cpp \
	TestPrograms/test_ppc_power7.cpp \
	TestPrograms/test_ppc_power8.cpp \
	TestPrograms/test_ppc_power9.cpp \
	TestPrograms/test_ppc_sha.cpp \
	TestPrograms/test_ppc_vmull.cpp \
	TestPrograms/test_pthreads.cpp \
	TestPrograms/test_x86_aes.cpp \
	TestPrograms/test_x86_avx2.cpp \
	TestPrograms/test_x86_avx512.cpp \
	TestPrograms/test_x86_avx.cpp \
	TestPrograms/test_x86_clmul.cpp \
	TestPrograms/test_x86_cpuid.cpp \
	TestPrograms/test_x86_rdrand.cpp \
	TestPrograms/test_x86_rdseed.cpp \
	TestPrograms/test_x86_sha.cpp \
	TestPrograms/test_x86_sse2.cpp \
	TestPrograms/test_x86_sse3.cpp \
	TestPrograms/test_x86_sse41.cpp \
	TestPrograms/test_x86_sse42.cpp \
	TestPrograms/test_x86_ssse3.cpp \
	TestPrograms/test_x86_via_aes.cpp \
	TestPrograms/test_x86_via_rng.cpp \
	TestPrograms/test_x86_via_sha.cpp

nobase_dist_pkgdata_DATA = \
    $(testdata_FILES) \
    $(testvector_FILES)

# Can't seem to get this to work, despite the fiddling attempts.
# https://www.gnu.org/software/automake/manual/html_node/Uniform.html and
# https://www.gnu.org/software/automake/manual/html_node/Program-and-Library-Variables.html
#nobase_noinst_data_DATA = \
#    $(testprogs_FILES)

# Workaround Automake bug. We can't seem to include the TestProgram/ data
# in the tarball without installation using their Uniform Naming Scheme
# https://www.gnu.org/software/automake/manual/html_node/Uniform.html and
# https://www.gnu.org/software/automake/manual/html_node/Program-and-Library-Variables.html
dist-hook:
	chmod -R u+w $(distdir)
	cp -r TestPrograms/ $(distdir)
	rm -f $(distdir)/TestPrograms/dump2def.cpp

## Automake bug workaround. If libcryptopp_la_SOURCES is an empty list, Automake assumes
## C source files and drives link through the C compiler. We provide the empty adhoc.cpp
## to get things back on course, so adhoc.cpp must always be copied.

adhoc.cpp:
	cp adhoc.cpp.proto adhoc.cpp
	touch adhoc.cpp

## Remove doc directory if present
distclean-local:
	-rm -rf html-docs doxyfile.stamp

## Automake does not properly uninstall the library test data and vectors
uninstall-hook:
	-rm -rf ${pkgdatadir}
	-rm -rf ${pkghtmldir}

## Doxygen is available but not built by default
## TODO: copy docs to ${pkghtmldir} if built
if CRYPTOPP_DOXYGEN_AVAILABLE

## PHONY targets. Automake can only handle one of them...
.PHONY: doc docs html htmldoc checkout reset

doc docs html htmldoc:
	$(DOXYGEN) Doxyfile -d CRYPTOPP_DOXYGEN_PROCESSING

endif

# Restore GNUmakefile
checkout:
	git checkout master -f

# Restore GNUmakefile
reset:
	git reset --hard HEAD
