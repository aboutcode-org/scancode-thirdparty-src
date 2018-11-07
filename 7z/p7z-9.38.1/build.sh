#!/bin/sh
#
# Copyright (c) 2017 nexB Inc. http://www.nexb.com/ - All rights reserved.

# NOTE : linux 64 build ONLY for now

set -e

lib_name=p7zip_9.38.1
lib_archive=p7zip_9.38.1_src_all.tar.bz2
download_url=http://master.dl.sourceforge.net/project/p7zip/p7zip/9.38.1/p7zip_9.38.1_src_all.tar.bz2


function build_lib {
    # build proper
    # wget $download_url
    tar -xf $lib_archive
    cd $lib_name
    cp makefile.linux_amd64_asm  makefile.linux
    make all_test
}


# OS-specific setup and build
os_name=$(uname -s)
if echo "$os_name" | grep -q "Linux"; then
    # assuming Debian/Ubuntu Linux
    # sudo apt-get install -y wget build-essential
    build_lib
    cp bin/7z bin/7z.so ../../../../scancode-toolkit/src/extractcode/bin/linux-64/bin/
    mkdir -p ../../../../scancode-toolkit/src/extractcode/bin/linux-64/bin/Codecs
    cp bin/Codecs/Rar29.so ../../../../scancode-toolkit/src/extractcode/bin/linux-64/bin/Codecs
    echo "Build complete: ScanCode linux-64 updated with binaries"

else
    echo "ERROR: Unsupported build OS '$os_name'"
    exit 1
fi
