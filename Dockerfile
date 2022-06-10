FROM ubuntu:18.04
MAINTAINER guzelfey
RUN apt-get update -y && \
    apt-get install -y \
        autoconf \
        automake \
        make \
        gcc \
        perl \
        wget \
        zlib1g-dev \
        libbz2-dev \
        liblzma-dev \
        libcurl4-gnutls-dev \
        libssl-dev \
        libncurses5-dev

#samtools 1.15.1 released 2022-04-07
WORKDIR /soft/samtools_1.15.1
RUN wget https://github.com/samtools/samtools/releases/download/1.15.1/samtools-1.15.1.tar.bz2 && \
    tar -vxjf samtools-1.15.1.tar.bz2 && \
    rm -f samtools-1.15.1.tar.bz2 && \
    ./configure && \
    make && \
    make install
ENV PATH=${PATH}:/soft/samtools_1.15.1/bin

#htslib 1.15.1 released 2022-04-07
WORKDIR /soft/htslib_1.15.1
RUN wget https://github.com/samtools/htslib/releases/download/1.15.1/htslib-1.15.1.tar.bz2 && \
    tar -vxjf htslib-1.15.1.tar.bz2 && \
    rm -f htslib-1.15.1.tar.bz2 && \
    ./configure && \
    make && \
    make install

#libdeflate 1.11 relesed 2022-05-24
WORKDIR /soft/libdeflate_1.11
RUN wget https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.11.tar.gz && \
    tar -vxjf v1.11.tar.gz && \
    rm -f v1.11.tar.gz && \
    make && \
    make install

#libmouse2 2.0.810-release-20220216151520 for biobambam2
WORKDIR /soft/libmouse2_2.0.810
RUN wget https://gitlab.com/german.tischler/libmaus2/-/archive/2.0.810-release-20220216151520/libmaus2-2.0.810-release-20220216151520.tar.bz2 && \
    tar -vxjf libmaus2-2.0.810-release-20220216151520.tar.bz2 && \
    rm -f libmaus2-2.0.810-release-20220216151520.tar.bz2 && \
    autoreconf -if && \
    ./configure && \
    make && \
    make install

#biobambam2 2.0.183-release-20210802180148
WORKDIR /soft/biobambam2_2.0.183
RUN wget https://gitlab.com/german.tischler/biobambam2/-/archive/2.0.183-release-20210802180148/biobambam2-2.0.183-release-20210802180148.tar.bz2 && \
    tar -vxjf biobambam2-2.0.183-release-20210802180148.tar.bz2 && \
    rm -f biobambam2-2.0.183-release-20210802180148.tar.bz2 && \
    autoreconf -if && \
    ./configure --with-libmaus2=/soft/libmouse2_2.0.810 && \
    make install
