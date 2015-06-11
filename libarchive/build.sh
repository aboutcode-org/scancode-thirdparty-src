#!/bin/bash
#
# Copyright (c) 2015 nexB Inc. http://www.nexb.com/ - All rights reserved.

lib_name=libarchive-3.1.2
lib_archive=$lib_name.tar.gz
download_url=http://libarchive.org/downloads/$lib_archive


function build_lib {
    # build proper
    wget $download_url
    tar -xf $lib_archive
    cd $lib_name
    ./configure --disable-bsdcpio --disable-bsdtar \
                --disable-xattr --disable-acl \
                --without-lzo2  \
                --without-nettle --without-openssl \
                --without-xml2 --without-expat \
                --disable-rpath
    make
}


# OS-specific setup and build
os_name=$(uname -s)
if [[ "$os_name" =~ "Linux" ]]; then
    # assuming Debian/Ubuntu Linux
    sudo apt-get install -y wget build-essential zlib1g-dev liblzma-dev libbz2-dev
    build_lib
    mkdir -p .build/bin
    cp .libs/libarchive.so.13.1.2 .build/bin/libarchive.so
    strip .build/bin/*
    echo "Build complete: .build contains extra sources for redist and binaries"

elif [[ "$os_name" =~ "Darwin" ]]; then
    # assuming that brew is installed
    brew install git
    brew tap homebrew/homebrew-dupes
    brew install zlib xz bzip2 wget libiconv
    build_lib
    mkdir -p .build/bin
    cp .libs/libarchive.13.dylib .build/bin/libarchive.dylib
    strip .build/bin/*
    echo "Build complete: build contains extra sources for redist and binaries"

elif [[ "$os_name" =~ "MINGW32" ]]; then
    # assuming that mingw-get is installed
    mingw-get install msys-wget liblzma-dev bzip2-dev zlib libiconv-dev 
    build_lib
    mkdir -p .build/bin
    cp .libs/libarchive-13.dll build/bin/libarchive.dll
    cp  /c/MinGW/bin/libbz2-2.dll \
        /c/MinGW/bin/libgcc_s_dw2-1.dll \
        /c/MinGW/bin/libiconv-2.dll \
        /c/MinGW/bin/liblzma-5.dll \
        /c/MinGW/bin/zlib1.dll \
        .build/bin/
    strip .build/bin/*

    echo "Fetching the MinGW sources for redistribution..."
    mkdir -p .build/src
    cd .build/src
    wget http://prdownloads.sourceforge.net/mingw/libiconv-1.14-3-mingw32-src.tar.lzma?download
    wget http://prdownloads.sourceforge.net/mingw/gcc-core-4.8.1-4-mingw32-src.tar.lzma?download
    wget http://prdownloads.sourceforge.net/mingw/bzip2-1.0.6-4-mingw32-src.tar.lzma?download
    wget http://prdownloads.sourceforge.net/mingw/expat-2.1.0-1-mingw32-src.tar.lzma?download
    wget http://prdownloads.sourceforge.net/mingw/xz-5.0.3-2-mingw32-src.tar.lzma?download
    wget http://prdownloads.sourceforge.net/mingw/zlib-1.2.8-1-mingw32-src.tar.lzma?download

    echo "Build complete: build contains extra sources for redist and binaries"

else
    echo "ERROR: Unsupported build OS '$os_name'"
    exit 1
fi
