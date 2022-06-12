FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y \
        autoconf \
        automake \
        make \
        gcc \
        perl \
        zlib1g-dev \
        libbz2-dev \
        liblzma-dev \
        libcurl4-gnutls-dev \
        libssl-dev \
        libncurses5-dev \
        libtool \
        libboost-dev \
        pkg-config \
        wget

WORKDIR /soft

#htslib 1.15.1 released 2022-04-07
RUN wget https://github.com/samtools/htslib/releases/download/1.15.1/htslib-1.15.1.tar.bz2 && \
    tar -vxjf htslib-1.15.1.tar.bz2 && \
    rm -f htslib-1.15.1.tar.bz2 && \
    cd htslib-1.15.1 && \
    ./configure --prefix=/soft/htslib-1.15.1 && \
    make && \
    make install

#libdeflate 1.11 relesed 2022-05-24
RUN wget https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.11.tar.gz && \
    tar -vxf v1.11.tar.gz && \
    rm -f v1.11.tar.gz && \
    cd libdeflate-1.11 && \
    make && \
    make install PREFIX=/soft/libdeflate-1.11

#samtools 1.15.1 released 2022-04-07
RUN wget https://github.com/samtools/samtools/releases/download/1.15.1/samtools-1.15.1.tar.bz2 && \
    tar -vxjf samtools-1.15.1.tar.bz2 && \
    rm -f samtools-1.15.1.tar.bz2 && \
    cd samtools-1.15.1 && \
    ./configure --with-libdeflate=/soft/libdeflate-1.11 --with-htslib=/soft/htslib-1.15.1 --prefix=/soft/samtools-1.15.1 && \
    make && \
    make install
ENV PATH=${PATH}:/soft/samtools_1.15.1/bin

#gcc update for libmaus2 to work
RUN apt-get update && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get install gcc-11 g++-11 -y && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100 \
    --slave /usr/bin/g++ g++ /usr/bin/g++-11 --slave /usr/bin/gcov gcov /usr/bin/gcov-11

#libmouse2 2.0.810-release-20220216151520 for biobambam2
RUN wget https://gitlab.com/german.tischler/libmaus2/-/archive/2.0.810-release-20220216151520/libmaus2-2.0.810-release-20220216151520.tar.bz2 && \
    tar -vxjf libmaus2-2.0.810-release-20220216151520.tar.bz2 && \
    rm -f libmaus2-2.0.810-release-20220216151520.tar.bz2 && \
    cd libmaus2-2.0.810-release-20220216151520 && \
    libtoolize && \
    aclocal && \
    autoreconf -i -f && \
    ./configure --prefix=/soft/libmaus2-2.0.810-release-20220216151520 && \
    make -j2 && \
    make -j2 install

#biobambam2 2.0.183-release-20210802180148
RUN wget https://gitlab.com/german.tischler/biobambam2/-/archive/2.0.183-release-20210802180148/biobambam2-2.0.183-release-20210802180148.tar.bz2 && \
    tar -vxjf biobambam2-2.0.183-release-20210802180148.tar.bz2 && \
    rm -f biobambam2-2.0.183-release-20210802180148.tar.bz2 && \
    cd biobambam2-2.0.183-release-20210802180148 && \
    autoreconf -if && \
    export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/soft/libmaus2-2.0.810-release-20220216151520/lib/pkgconfig && \
    ./configure --with-libmaus2=/soft/libmaus2-2.0.810-release-20220216151520 --prefix=/soft/biobambam2-2.0.183-release-20210802180148 && \
    make -j2 install
