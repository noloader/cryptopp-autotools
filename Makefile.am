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
##           sed -e 's|ppc_power[[:alnum:]]*.cpp ||g' | fold -w73 -s
##
##    Once "library sources" list is created, remove cryptlib.cpp, cpu.cpp,
##    integer.cpp; and remove all of the *_simd.cpp files. The remaining
##    list should be used for `libothers_la_SOURCES` below.
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
   libaria_simd.la \
   libblake2s_simd.la \
   libblake2b_simd.la \
   libchacha_simd.la \
   libchacha_avx.la \
   libcham_simd.la \
   libcrc_simd.la \
   libgcm_simd.la \
   liblea_simd.la \
   libneon_simd.la \
   libppc_simd.la \
   libppc_power7.la \
   libppc_power8.la \
   libppc_power9.la \
   librijndael_simd.la \
   libsha_simd.la \
   libshacal2_simd.la \
   libsimeck_simd.la \
   libsimon64_simd.la \
   libsimon128_simd.la \
   libspeck64_simd.la \
   libspeck128_simd.la \
   libsm4_simd.la \
   libsse_simd.la

## ARMv7-a AES by Andy Polyakov
if CRYPTOGAMS_AES
   EXTRA_LTLIBRARIES += libaes_armv4.la
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
   $(libaria_simd_la_OBJECTS) \
   $(libblake2s_simd_la_OBJECTS) \
   $(libblake2b_simd_la_OBJECTS) \
   $(libchacha_simd_la_OBJECTS) \
   $(libchacha_avx_la_OBJECTS) \
   $(libcham_simd_la_OBJECTS) \
   $(libcrc_simd_la_OBJECTS) \
   $(libgcm_simd_la_OBJECTS) \
   $(liblea_simd_la_OBJECTS) \
   $(libneon_simd_la_OBJECTS) \
   $(libppc_simd_la_OBJECTS) \
   $(libppc_power7_la_OBJECTS) \
   $(libppc_power8_la_OBJECTS) \
   $(libppc_power9_la_OBJECTS) \
   $(librijndael_simd_la_OBJECTS) \
   $(libsha_simd_la_OBJECTS) \
   $(libshacal2_simd_la_OBJECTS) \
   $(libsimeck_simd_la_OBJECTS) \
   $(libsimon64_simd_la_OBJECTS) \
   $(libsimon128_simd_la_OBJECTS) \
   $(libspeck64_simd_la_OBJECTS) \
   $(libspeck128_simd_la_OBJECTS) \
   $(libsm4_simd_la_OBJECTS) \
   $(libsse_simd_la_OBJECTS)

## ARMv7-a AES by Andy Polyakov
if CRYPTOGAMS_AES
   libcryptopp_la_LIBADD += $(libaes_armv4_la_OBJECTS)
endif

## cpufeatures library on Android
if ANDROID_CPU_FEATURES
   libcryptopp_la_LIBADD += $(libcpu_features_la_OBJECTS)
endif

## The remainder of the object files
libcryptopp_la_LIBADD += $(libothers_la_OBJECTS)

## Don't use EXTRA_ prefix for libcryptopp_la_DEPENDENCIES. It breaks Solaris.

libcryptopp_la_DEPENDENCIES = \
   $(libcryptlib_la_OBJECTS) \
   $(libcpu_la_OBJECTS) \
   $(libinteger_la_OBJECTS) \
   $(libaria_simd_la_OBJECTS) \
   $(libblake2s_simd_la_OBJECTS) \
   $(libblake2b_simd_la_OBJECTS) \
   $(libchacha_simd_la_OBJECTS) \
   $(libchacha_avx_la_OBJECTS) \
   $(libcham_simd_la_OBJECTS) \
   $(libcrc_simd_la_OBJECTS) \
   $(liblea_simd_la_OBJECTS) \
   $(libgcm_simd_la_OBJECTS) \
   $(libneon_simd_la_OBJECTS) \
   $(libppc_simd_la_OBJECTS) \
   $(libppc_power7_la_OBJECTS) \
   $(libppc_power8_la_OBJECTS) \
   $(libppc_power9_la_OBJECTS) \
   $(librijndael_simd_la_OBJECTS) \
   $(libsha_simd_la_OBJECTS) \
   $(libshacal2_simd_la_OBJECTS) \
   $(libsimeck_simd_la_OBJECTS) \
   $(libsimon64_simd_la_OBJECTS) \
   $(libsimon128_simd_la_OBJECTS) \
   $(libspeck64_simd_la_OBJECTS) \
   $(libspeck128_simd_la_OBJECTS) \
   $(libsm4_simd_la_OBJECTS) \
   $(libsse_simd_la_OBJECTS)

## ARMv7-a AES by Andy Polyakov
if CRYPTOGAMS_AES
   libcryptopp_la_DEPENDENCIES += $(libaes_armv4_la_OBJECTS)
endif

## cpufeatures library on Android
if ANDROID_CPU_FEATURES
   libcryptopp_la_DEPENDENCIES += $(libcpu_features_la_OBJECTS)
endif

## The remainder of the object files
libcryptopp_la_DEPENDENCIES += $(libothers_la_OBJECTS)

## Very important... Version number of the library
libcryptopp_la_LDFLAGS = $(AM_LDFLAGS) -version-info 7:1:0

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
libaria_simd_la_SOURCES = aria_simd.cpp
libaria_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_ARIA_FLAG)

## CRYPTOPP_BLAKE2_FLAG set in configure.ac
libblake2s_simd_la_SOURCES = blake2s_simd.cpp
libblake2s_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_BLAKE2S_FLAG)

## CRYPTOPP_BLAKE2_FLAG set in configure.ac
libblake2b_simd_la_SOURCES = blake2b_simd.cpp
libblake2b_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_BLAKE2B_FLAG)

## CRYPTOPP_CHACHA_FLAG set in configure.ac
libchacha_simd_la_SOURCES = chacha_simd.cpp
libchacha_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_CHACHA_FLAG)

## CRYPTOPP_CHACHA_AVX2_FLAG set in configure.ac
libchacha_avx_la_SOURCES = chacha_avx.cpp
libchacha_avx_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_CHACHA_AVX2_FLAG)

## CRYPTOPP_CHAM_FLAG set in configure.ac
libcham_simd_la_SOURCES = cham_simd.cpp
libcham_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_CHAM_FLAG)

## CRYPTOPP_CRC_FLAG set in configure.ac
libcrc_simd_la_SOURCES = crc_simd.cpp
libcrc_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_CRC_FLAG)

## CRYPTOPP_GCM_FLAG set in configure.ac
libgcm_simd_la_SOURCES = gcm_simd.cpp
libgcm_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_GCM_FLAG)

## CRYPTOPP_LEA_FLAG set in configure.ac
liblea_simd_la_SOURCES = lea_simd.cpp
liblea_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_LEA_FLAG)

## CRYPTOPP_NEON_FLAG set in configure.ac
libneon_simd_la_SOURCES = neon_simd.cpp
libneon_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_NEON_FLAG)

## CRYPTOPP_PPC_FLAG set in configure.ac
libppc_simd_la_SOURCES = ppc_simd.cpp
libppc_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_ALTIVEC_FLAG)

## CRYPTOPP_PPC_FLAG set in configure.ac
libppc_power7_la_SOURCES = ppc_power7.cpp
libppc_power7_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_POWER7_FLAG)

## CRYPTOPP_PPC_FLAG set in configure.ac
libppc_power8_la_SOURCES = ppc_power8.cpp
libppc_power8_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_POWER8_FLAG)

## CRYPTOPP_PPC_FLAG set in configure.ac
libppc_power9_la_SOURCES = ppc_power9.cpp
libppc_power9_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_POWER9_FLAG)

## CRYPTOPP_AES_FLAG set in configure.ac
librijndael_simd_la_SOURCES = rijndael_simd.cpp
librijndael_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_AES_FLAG)

## CRYPTOPP_SHA_FLAG set in configure.ac
libsha_simd_la_SOURCES = sha_simd.cpp
libsha_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_SHA_FLAG)

## CRYPTOPP_SHA_FLAG set in configure.ac
libshacal2_simd_la_SOURCES = shacal2_simd.cpp
libshacal2_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_SHA_FLAG)

## CRYPTOPP_SIMECK_FLAG set in configure.ac
libsimeck_simd_la_SOURCES = simeck_simd.cpp
libsimeck_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_SIMECK_FLAG)

## CRYPTOPP_SIMON64_FLAG set in configure.ac
libsimon64_simd_la_SOURCES = simon64_simd.cpp
libsimon64_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_SIMON64_FLAG)

## CRYPTOPP_SIMON128_FLAG set in configure.ac
libsimon128_simd_la_SOURCES = simon128_simd.cpp
libsimon128_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_SIMON128_FLAG)

## CRYPTOPP_SPECK64_FLAG set in configure.ac
libspeck64_simd_la_SOURCES = speck64_simd.cpp
libspeck64_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_SPECK64_FLAG)

## CRYPTOPP_SPECK_FLAG set in configure.ac
libspeck128_simd_la_SOURCES = speck128_simd.cpp
libspeck128_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_SPECK128_FLAG)

## CRYPTOPP_SM4_FLAG set in configure.ac
libsm4_simd_la_SOURCES = sm4_simd.cpp
libsm4_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_SM4_FLAG)

## CRYPTOPP_SSE_FLAG set in configure.ac
libsse_simd_la_SOURCES = sse_simd.cpp
libsse_simd_la_CXXFLAGS = $(AM_CXXFLAGS) $(CRYPTOPP_SSE_FLAG)

## ARMv7-a AES by Andy Polyakov
## Also see https://stackoverflow.com/q/51575580/608639
if CRYPTOGAMS_AES
libaes_armv4_la_SOURCES = aes_armv4.S
libaes_armv4_la_CCASFLAGS = $(AM_CXXFLAGS) $(CRYPTOPGAMS_FLAGS)
endif

## cpufeatures library on Android
if ANDROID_CPU_FEATURES
libcpu_features_la_SOURCES = cpu-features.c
endif

# This is the list of remaining sources files that don't need special order
# and don't need special flags. It is formed by removing cryptlib.cpp,
# cpu.cpp, integer.cpp, *_avx.cpp and *_simd.cpp files. It is sorted in
# alphabetical order for deterministic builds.

libothers_la_SOURCES = \
    3way.cpp adler32.cpp algebra.cpp algparam.cpp arc4.cpp aria.cpp \
    ariatab.cpp asn.cpp authenc.cpp base32.cpp base64.cpp basecode.cpp \
    bfinit.cpp blake2.cpp blowfish.cpp blumshub.cpp camellia.cpp cast.cpp \
    casts.cpp cbcmac.cpp ccm.cpp chacha.cpp cham.cpp \
    channels.cpp cmac.cpp crc.cpp darn.cpp default.cpp des.cpp dessp.cpp \
    dh.cpp dh2.cpp dll.cpp donna_32.cpp donna_64.cpp dsa.cpp eax.cpp \
    ec2n.cpp eccrypto.cpp ecp.cpp elgamal.cpp emsa2.cpp eprecomp.cpp \
    esign.cpp files.cpp filters.cpp fips140.cpp fipstest.cpp gcm.cpp \
    gf256.cpp gf2_32.cpp gf2n.cpp gfpcrypt.cpp gost.cpp gzip.cpp hc128.cpp \
    hc256.cpp hex.cpp hight.cpp hmac.cpp hrtimer.cpp ida.cpp idea.cpp \
    iterhash.cpp kalyna.cpp kalynatab.cpp keccak.cpp keccakc.cpp lea.cpp \
    luc.cpp mars.cpp marss.cpp md2.cpp md4.cpp md5.cpp misc.cpp modes.cpp \
    mqueue.cpp mqv.cpp nbtheory.cpp oaep.cpp osrng.cpp padlkrng.cpp \
    panama.cpp pkcspad.cpp poly1305.cpp polynomi.cpp pssr.cpp pubkey.cpp \
    queue.cpp rabbit.cpp rabin.cpp randpool.cpp rc2.cpp rc5.cpp rc6.cpp \
    rdrand.cpp rdtables.cpp rijndael.cpp ripemd.cpp rng.cpp rsa.cpp rw.cpp \
    safer.cpp salsa.cpp scrypt.cpp seal.cpp seed.cpp serpent.cpp sha.cpp \
    sha3.cpp shacal2.cpp shark.cpp sharkbox.cpp simeck.cpp simon.cpp \
    skipjack.cpp sm3.cpp sm4.cpp sosemanuk.cpp speck.cpp square.cpp \
    squaretb.cpp strciphr.cpp tea.cpp tftables.cpp threefish.cpp tiger.cpp \
    tigertab.cpp ttmac.cpp tweetnacl.cpp twofish.cpp vmac.cpp wake.cpp \
    whrlpool.cpp xed25519.cpp xtr.cpp xtrcrypt.cpp zdeflate.cpp zinflate.cpp \
    zlib.cpp

# Don't include aes_armv4.h here
pkginclude_HEADERS = \
    3way.h adler32.h adv_simd.h aes.h algebra.h algparam.h \
    arc4.h argnames.h aria.h asn.h authenc.h base32.h base64.h basecode.h \
    blake2.h blowfish.h blumshub.h camellia.h cast.h cbcmac.h ccm.h chacha.h \
    cham.h channels.h cmac.h config.h cpu.h crc.h cryptlib.h darn.h \
    default.h des.h dh.h dh2.h dll.h dmac.h donna.h drbg.h dsa.h eax.h \
    ec2n.h eccrypto.h ecp.h ecpoint.h elgamal.h emsa2.h eprecomp.h esign.h \
    fhmqv.h files.h filters.h fips140.h fltrimpl.h gcm.h gf256.h gf2_32.h \
    gf2n.h gfpcrypt.h gost.h gzip.h hashfwd.h hc128.h hc256.h hex.h hight.h \
    hkdf.h hmac.h hmqv.h hrtimer.h ida.h idea.h integer.h iterhash.h \
    kalyna.h keccak.h keccakc.h lea.h lubyrack.h luc.h mars.h md2.h md4.h \
    md5.h mdc.h mersenne.h misc.h modarith.h modes.h modexppc.h mqueue.h \
    mqv.h naclite.h nbtheory.h nr.h oaep.h oids.h osrng.h ossig.h padlkrng.h \
    panama.h pch.h pkcspad.h poly1305.h polynomi.h ppc_simd.h pssr.h \
    pubkey.h pwdbased.h queue.h rabbit.h rabin.h randpool.h rc2.h rc5.h \
    rc6.h rdrand.h rijndael.h ripemd.h rng.h rsa.h rw.h safer.h salsa.h \
    scrypt.h seal.h secblock.h seckey.h seed.h serpent.h serpentp.h sha.h \
    sha3.h shacal2.h shark.h simeck.h simon.h simple.h siphash.h skipjack.h \
    sm3.h sm4.h smartptr.h sosemanuk.h speck.h square.h stdcpp.h strciphr.h \
    tea.h threefish.h tiger.h trap.h trunhash.h ttmac.h tweetnacl.h \
    twofish.h vmac.h wake.h whrlpool.h words.h xed25519.h xtr.h xtrcrypt.h \
    zdeflate.h zinflate.h zlib.h

noinst_HEADERS = \
    local.h \
    bench.h \
    factory.h \
    resource.h \
    validate.h \
    aes_armv4.h

bin_PROGRAMS = cryptest
noinst_PROGRAMS = cryptestcwd

cryptest_CXXFLAGS = $(AM_CXXFLAGS) -DCRYPTOPP_DATA_DIR='"${pkgdatadir}/"'
cryptest_SOURCES = \
    test.cpp bench1.cpp bench2.cpp bench3.cpp datatest.cpp \
    dlltest.cpp fipsalgt.cpp validat0.cpp validat1.cpp validat2.cpp \
    validat3.cpp validat4.cpp validat5.cpp validat6.cpp validat7.cpp \
    validat8.cpp validat9.cpp validat10.cpp regtest1.cpp regtest2.cpp \
    regtest3.cpp regtest4.cpp

nodist_cryptest_SOURCES = adhoc.cpp
cryptest_LDADD = $(lib_LTLIBRARIES)

cryptestcwd_CXXFLAGS = $(AM_CXXFLAGS)
cryptestcwd_SOURCES = \
    test.cpp bench1.cpp bench2.cpp bench3.cpp datatest.cpp \
    dlltest.cpp fipsalgt.cpp validat0.cpp validat1.cpp validat2.cpp \
    validat3.cpp validat4.cpp validat5.cpp validat6.cpp validat7.cpp \
    validat8.cpp validat9.cpp validat10.cpp regtest1.cpp regtest2.cpp \
    regtest3.cpp regtest4.cpp

nodist_cryptestcwd_SOURCES = adhoc.cpp
cryptestcwd_LDADD = $(lib_LTLIBRARIES)

CLEANFILES = adhoc.cpp

## Copy the TestVectors/ and TestData/ to ${pkgdatadir}
## https://www.gnu.org/software/automake/manual/html_node/Data.html

testdata_FILES = \
    TestData/3desval.dat   TestData/fhmqv512.dat  TestData/rc5val.dat \
    TestData/3wayval.dat   TestData/gostval.dat   TestData/rc6val.dat \
    TestData/aria.dat      TestData/hmqv160.dat   TestData/rijndael.dat \
    TestData/camellia.dat  TestData/hmqv256.dat   TestData/rsa1024.dat \
    TestData/cast128v.dat  TestData/hmqv384.dat   TestData/rsa2048a.dat \
    TestData/cast256v.dat  TestData/hmqv512.dat   TestData/rsa2048.dat \
    TestData/defdmac1.bin  TestData/ideaval.dat   TestData/rsa400pb.dat \
    TestData/defdmac2.bin  TestData/luc1024.dat   TestData/rsa400pv.dat \
    TestData/descert.dat   TestData/luc2048.dat   TestData/rsa512a.dat \
    TestData/dh1024.dat    TestData/lucc1024.dat  TestData/rw1024.dat \
    TestData/dh2048.dat    TestData/lucc512.dat   TestData/rw2048.dat \
    TestData/dlie1024.dat  TestData/lucd1024.dat  TestData/saferval.dat \
    TestData/dlie2048.dat  TestData/lucd512.dat   TestData/serpentv.dat \
    TestData/dsa1024b.dat  TestData/lucs1024.dat  TestData/shacal2v.dat \
    TestData/dsa1024.dat   TestData/lucs512.dat   TestData/sharkval.dat \
    TestData/dsa512.dat    TestData/marsval.dat   TestData/skipjack.dat \
    TestData/elgc1024.dat  TestData/mqv1024.dat   TestData/squareva.dat \
    TestData/esig1023.dat  TestData/mqv2048.dat   TestData/twofishv.dat \
    TestData/esig1536.dat  TestData/nr1024.dat    TestData/usage.dat \
    TestData/esig2046.dat  TestData/nr2048.dat    TestData/x25519.dat \
    TestData/fhmqv160.dat  TestData/rabi1024.dat  TestData/xtrdh171.dat \
    TestData/fhmqv256.dat  TestData/rabi2048.dat  TestData/xtrdh342.dat
    TestData/fhmqv384.dat  TestData/rc2val.dat

testvector_FILES = \
    TestVectors/aes.txt            TestVectors/rw.txt \
    TestVectors/all.txt            TestVectors/salsa.txt \
    TestVectors/aria.txt           TestVectors/seal.txt \
    TestVectors/blake2b.txt        TestVectors/seed.txt \
    TestVectors/blake2s.txt        TestVectors/sha1_160_fips_180.txt \
    TestVectors/blake2.txt         TestVectors/sha1_fips_180.txt \
    TestVectors/camellia.txt       TestVectors/sha2_224_fips_180.txt \
    TestVectors/ccm.txt            TestVectors/sha2_256_fips_180.txt \
    TestVectors/chacha.txt         TestVectors/sha2_384_fips_180.txt \
    TestVectors/cham.txt           TestVectors/sha2_512_fips_180.txt \
    TestVectors/cmac.txt           TestVectors/sha2_fips_180.txt \
    TestVectors/dlies.txt          TestVectors/sha2.txt \
    TestVectors/dsa_1363.txt       TestVectors/sha3_224_fips_202.txt \
    TestVectors/dsa_rfc6979.txt    TestVectors/sha3_256_fips_202.txt \
    TestVectors/dsa.txt            TestVectors/sha3_384_fips_202.txt \
    TestVectors/eax.txt            TestVectors/sha3_512_fips_202.txt \
    TestVectors/esign.txt          TestVectors/sha3_fips_202.txt \
    TestVectors/gcm.txt            TestVectors/sha3.txt \
    TestVectors/hc128.txt          TestVectors/shacal2.txt \
    TestVectors/hc256.txt          TestVectors/sha.txt \
    TestVectors/hight.txt          TestVectors/simeck.txt \
    TestVectors/hkdf.txt           TestVectors/simon.txt \
    TestVectors/hmac.txt           TestVectors/siphash.txt \
    TestVectors/kalyna.txt         TestVectors/sm3.txt \
    TestVectors/keccak.txt         TestVectors/sm4.txt \
    TestVectors/lea.txt            TestVectors/sosemanuk.txt \
    TestVectors/mars.txt           TestVectors/speck.txt \
    TestVectors/nr.txt             TestVectors/tea.txt \
    TestVectors/ocb.txt            TestVectors/threefish.txt \
    TestVectors/panama.txt         TestVectors/tls_chacha.txt \
    TestVectors/rabbit.txt         TestVectors/ttmac.txt \
    TestVectors/Readme.txt         TestVectors/vmac.txt \
    TestVectors/rsa_oaep.txt       TestVectors/wake.txt \
    TestVectors/rsa_pkcs1_1_5.txt  TestVectors/whrlpool.txt \
    TestVectors/rsa_pss.txt

nobase_dist_pkgdata_DATA = \
    $(testdata_FILES) \
    $(testvector_FILES)

## Automake bug workaround. If libcryptopp_la_SOURCES is an empty list, Automake assumes
## C source files and drives link through the C compiler. We provide the empty adhoc.cpp
## to get things back on course, so adhoc.cpp must always be copied.

adhoc.cpp:
	cp adhoc.cpp.proto adhoc.cpp
	touch adhoc.cpp

## Remove doc directpry if present
distclean-local:
	-rm -rf html-docs doxyfile.stamp

## Automake does not properly uninstall the library test data and vectors
uninstall-hook:
	-rm -rf ${pkgdatadir}
	-rm -rf ${pkghtmldir}

## Doxygen is available but not built by default
## TODO: copy docs to ${pkghtmldir} if built
if CRYPTOPP_DOXYGEN_AVAILABLE

.PHONY: doc docs html htmldoc
doc docs html htmldoc:
	$(DOXYGEN) Doxyfile -d CRYPTOPP_DOXYGEN_PROCESSING

endif

# Restore GNUmakefile
.PHONY: checkout
checkout:
	git checkout master -f

# Restore GNUmakefile
.PHONY: reset
reset:
	git reset --hard HEAD
