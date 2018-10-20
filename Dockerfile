FROM ubuntu:18.04

RUN apt-get update && apt-get install -y tzdata && apt-get install -y \
    autoconf \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    file \
    g++ --no-install-recommends \
    gcc \
    gdb \
    java-common \
    libc6-dev \
    libcups2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libisl15 \
    libpython2.7 \
    libx11-dev \
    libxext-dev \
    libxrender-dev \
    libxtst-dev \
    libxt-dev \
    make \
    mercurial \
    unzip \
    wget \
    zip \
  && rm -rf /var/lib/apt/lists/*

# Install OpenJDK 10 (required to build OpenJDK 11)
WORKDIR /usr/lib/jvm
RUN curl -SL https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz | tar xzf -
COPY jdk-10.jinfo .jdk-10.0.2.jinfo
RUN bash -c "grep /usr/lib/jvm .jdk-10.0.2.jinfo | awk '{ print \"update-alternatives --install /usr/bin/\" \$2 \" \" \$2 \" \" \$3 \" 2\"; }' | bash " \
  && update-java-alternatives -s jdk-10.0.2

# Install toolchain
RUN curl -SL https://github.com/wpilibsuite/raspbian-toolchain/releases/download/v1.0.0/Raspbian9-Linux-Toolchain-6.3.0.tar.gz | sh -c 'mkdir -p /usr/local && cd /usr/local && tar xzf - --strip-components=1'

WORKDIR /tmp

RUN wget http://archive.raspbian.org/raspbian/pool/main/a/alsa-lib/libasound2_1.1.3-5_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/a/alsa-lib/libasound2-dev_1.1.3-5_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/c/cups/libcups2_2.2.1-8+deb9u2_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/c/cups/libcups2-dev_2.2.1-8+deb9u2_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/c/cups/libcupsimage2_2.2.1-8+deb9u2_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/c/cups/libcupsimage2-dev_2.2.1-8+deb9u2_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/f/fontconfig/libfontconfig1_2.11.0-6.7_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/f/fontconfig/libfontconfig1-dev_2.11.0-6.7_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/f/freetype/libfreetype6_2.6.3-3.2_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/f/freetype/libfreetype6-dev_2.6.3-3.2_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/z/zlib/zlib1g_1.2.8.dfsg-5_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/z/zlib/zlib1g-dev_1.2.8.dfsg-5_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/x/x11proto-core/x11proto-core-dev_7.0.31-1_all.deb \
    http://archive.raspbian.org/raspbian/pool/main/x/x11proto-input/x11proto-input-dev_2.3.2-1_all.deb \
    http://archive.raspbian.org/raspbian/pool/main/x/x11proto-gl/x11proto-gl-dev_1.4.17-1_all.deb \
    http://archive.raspbian.org/raspbian/pool/main/x/x11proto-kb/x11proto-kb-dev_1.0.7-1_all.deb \
    http://archive.raspbian.org/raspbian/pool/main/x/x11proto-randr/x11proto-randr-dev_1.5.0-1_all.deb \
    http://archive.raspbian.org/raspbian/pool/main/x/x11proto-record/x11proto-record-dev_1.14.2-1_all.deb \
    http://archive.raspbian.org/raspbian/pool/main/x/x11proto-render/x11proto-render-dev_0.11.1-2_all.deb \
    http://archive.raspbian.org/raspbian/pool/main/x/x11proto-resource/x11proto-resource-dev_1.2.0-3_all.deb \
    http://archive.raspbian.org/raspbian/pool/main/x/x11proto-video/x11proto-video-dev_2.3.3-1_all.deb \
    http://archive.raspbian.org/raspbian/pool/main/x/x11proto-xext/x11proto-xext-dev_7.3.0-1_all.deb \
    http://archive.raspbian.org/raspbian/pool/main/x/x11proto-xinerama/x11proto-xinerama-dev_1.2.1-2_all.deb \
    http://archive.raspbian.org/raspbian/pool/main/libb/libbsd/libbsd0_0.8.3-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libb/libbsd/libbsd-dev_0.8.3-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libx11/libx11-6_1.6.4-3_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libx11/libx11-dev_1.6.4-3_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxau/libxau6_1.0.8-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxau/libxau-dev_1.0.8-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxcb/libxcb1_1.12-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxcb/libxcb1-dev_1.12-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxdmcp/libxdmcp6_1.1.2-3_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxdmcp/libxdmcp-dev_1.1.2-3_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxext/libxext6_1.3.3-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxext/libxext-dev_1.3.3-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxfixes/libxfixes3_5.0.3-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxfixes/libxfixes-dev_5.0.3-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxi/libxi6_1.7.9-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxi/libxi-dev_1.7.9-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxrender/libxrender1_0.9.10-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxrender/libxrender-dev_0.9.10-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxt/libxt6_1.1.5-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxt/libxt-dev_1.1.5-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/i/iptables/libxtables12_1.6.0+snapshot20161117-6_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/i/iptables/libxtables-dev_1.6.0+snapshot20161117-6_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxtst/libxtst6_1.2.3-1_armhf.deb \
    http://archive.raspbian.org/raspbian/pool/main/libx/libxtst/libxtst-dev_1.2.3-1_armhf.deb \
  && for f in *.deb; do \
    ar p $f data.tar.xz | sh -c 'cd /usr/local/arm-raspbian9-linux-gnueabihf && tar xJf -; exit 0'; \
    ar p $f data.tar.gz | sh -c 'cd /usr/local/arm-raspbian9-linux-gnueabihf && tar xzf -; exit 0'; \
  done \
  && sh -c 'cd /usr/local/arm-raspbian9-linux-gnueabihf/lib && mv arm-linux-gnueabihf/* .' \
  && sh -c 'cd /usr/local/arm-raspbian9-linux-gnueabihf/usr/lib && mv arm-linux-gnueabihf/* . && rm libbsd.so libz.so && ln -s ../../lib/libbsd.so.0.8.3 libbsd.so && ln -s ../../lib/libz.so.1.2.8 libz.so' \
  && rm *.deb

WORKDIR /build
