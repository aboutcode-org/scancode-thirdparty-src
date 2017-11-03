#!/bin/bash
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
if [[ "$os_name" =~ "Linux" ]]; then
    # assuming Debian/Ubuntu Linux
    # sudo apt-get install -y wget build-essential
    build_lib
    cp src/.libs/libmagic.so.1.0.0 ../../../../scancode-toolkit/src/typecode/bin/linux-64/lib/libmagic.so
    cp magic/magic.mgc ../../../../scancode-toolkit/src/typecode/data/magic/noarch/magic.mgc
    echo "Build complete: ScanCode linux-64 updated with binaries"

else
    echo "ERROR: Unsupported build OS '$os_name'"
    exit 1
fi
