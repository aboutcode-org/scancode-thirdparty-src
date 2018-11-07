#!/bin/sh
#
# Copyright (c) 2017 nexB Inc. http://www.nexb.com/ - All rights reserved.

# NOTE : linux 64 build ONLY for now

set -e

lib_name=file-5.23
lib_archive=$lib_name.tar.gz
download_url=ftp://ftp.astron.com/pub/file/$lib_archive


function build_lib {
    # build proper
    # wget $download_url
    tar -xf $lib_archive
    cd $lib_name
    ./configure
    make
}


# OS-specific setup and build
os_name=$(uname -s)
if echo "$os_name" | grep -q "Linux"; then
    # assuming Debian/Ubuntu Linux
    # sudo apt-get install -y wget build-essential
    build_lib

    target_dir=scancode-toolkit/plugins/typecode-libmagic-manylinux1_x86_64/src/typecode_libmagic/lib/
    mkdir -p $target_dir
    cp src/.libs/libmagic.so.1.0.0 $target_dir/libmagic.so

    target_dir=scancode-toolkit/plugins/typecode-libmagic-manylinux1_x86_64/src/typecode_libmagic/data/
    mkdir -p $target_dir
    cp magic/magic.mgc $target_dir

    echo "Build complete: ScanCode linux-64 updated with binaries"

else
    echo "ERROR: Unsupported build OS '$os_name'"
    exit 1
fi
