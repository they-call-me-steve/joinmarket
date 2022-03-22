FROM alpine:3.13.5
LABEL MAINTAINER "Stephen Hunter" <steve@the-steve.com>
# Change VERSION any branch in git repo. Defaults to master branch.
ARG VERSION=master
# Default is 4, but change this to whatever works for your system
ARG BUILDCORES=4
RUN apk --update upgrade && \
    apk add autoconf automake build-base git libffi-dev libressl-dev libsodium-dev libtool pkgconfig py3-pip python3-dev && \
    git clone https://github.com/Joinmarket-Org/joinmarket-clientserver && \
    cd /joinmarket-clientserver && \
    mkdir data && \
    ln -s /joinmarket-clientserver/data /root/.joinmarket && \
    mkdir deps && cd deps && \
    git clone https://github.com/bitcoin-core/secp256k1 && \
    cd secp256k1 && \
    ./autogen.sh && \
    ./configure --enable-module-recovery --disable-jni --enable-experimental --enable-module-ecdh --enable-benchmark=no && \
    make -j ${BUILDCORES} && \
    make check && \
    make install && \
    cd ../.. && \
    pip install -r requirements/base.txt
VOLUME ["/joinmarket-clientserver/data"]
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/joinmarket-clientserver/scripts
#CMD ["wallet-tool.py"]
