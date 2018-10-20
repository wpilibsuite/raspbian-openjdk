# The hg revision
HG_REV=8513ac27b651
# The full version, e.g. "11u28-1"
VER=11.0.1
# The Java major version only, e.g. "11"
JAVA_MAJOR=11
# The Java major+minor version, e.g. "11.0.0"
JAVA_MAJORMINOR=11.0.1
# The Java patch, e.g. "28" for "11u28"
JAVA_PATCH=13
DOCKER_IMAGE=wpilib/raspbian-openjdk:${JAVA_MAJOR}u

JVM_VARIANT=server
JVM_FEATURES=

.PHONY: all clean

all:
	$(MAKE) clean
	$(MAKE) jdk_${VER}.tar.gz

clean:
	rm -f jdk_${VER}.tar.gz
	rm -f jdk_${VER}-strip.tar.gz
	rm -rf jdk

jdk_${VER}.tar.gz:
	wget -nc http://hg.openjdk.java.net/jdk-updates/jdk11u/archive/${HG_REV}.tar.bz2
	docker run --rm -v ${PWD}:/artifacts ${DOCKER_IMAGE} bash -c "\
		tar xjf /artifacts/${HG_REV}.tar.bz2 \
		&& cd jdk11u-${HG_REV} \
		&& patch -p1 < /artifacts/g1OopClosures.hpp.patch \
		&& bash configure \
			--openjdk-target=arm-raspbian9-linux-gnueabihf \
			--with-abi-profile=arm-vfp-hflt \
			--with-jvm-variants=${JVM_VARIANT} \
			--with-jvm-features=${JVM_FEATURES} \
			--with-native-debug-symbols=zipped \
			--enable-unlimited-crypto \
			--with-sysroot=/usr/local/arm-raspbian9-linux-gnueabihf \
			--with-version-patch=${JAVA_PATCH} \
			--disable-warnings-as-errors \
		&& make CONF=linux-arm-normal-${JVM_VARIANT}-release jdk-image \
		&& cd build/linux-arm-normal-${JVM_VARIANT}-release/images \
		&& tar czf jdk_${VER}.tar.gz jdk \
		&& chown -R $(shell id -u):$(shell id -g) jdk_${VER}.tar.gz \
		&& cp -a jdk_${VER}.tar.gz /artifacts \
		&& find jdk -name \*.so -type f | xargs arm-raspbian9-linux-gnueabihf-strip \
		&& arm-raspbian9-linux-gnueabihf-strip jdk/bin/* jdk/lib/jexec \
		&& tar czf jdk_${VER}-strip.tar.gz jdk \
		&& chown -R $(shell id -u):$(shell id -g) jdk_${VER}-strip.tar.gz \
		&& cp -a jdk_${VER}-strip.tar.gz /artifacts"
