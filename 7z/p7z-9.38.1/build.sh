#!/bin/sh
#
# Copyright (c) 2017 nexB Inc. http://www.nexb.com/ - All rights reserved.

set -e

lib_name=p7zip_9.38.1
lib_archive=p7zip_9.38.1_src_all.tar.bz2
download_url=http://master.dl.sourceforge.net/project/p7zip/p7zip/9.38.1/p7zip_9.38.1_src_all.tar.bz2


function build_linux64_lib {
    # build proper
    # wget $download_url
    tar -xf $lib_archive
    cd $lib_name
    cp makefile.linux_amd64_asm  makefile.linux
    make all_test
}

function build_macosx_lib {
    # build proper
    # wget $download_url
    tar -xf $lib_archive
    cd $lib_name
    make -c makefile.macosx_64bits all_test
}


# OS-specific setup and build
os_name=$(uname -s)

if [ "$(os_name)" == "Darwin" ]; then
    # macOS
    build_macosx_lib

    plugin_base=../../../../scancode-toolkit-master/plugins/extractcode-7z-macosx_10_9_intel/src/extractcode_7z/bin
    cp bin/7z bin/7z.so $plugin_base
    mkdir -p $plugin_base/Codecs
    cp bin/Codecs/Rar29.so $plugin_base/Codecs
    echo "Build complete: extractcode-7z-macosx_10_9_intel updated with binaries"

elif [ "$(os_name)" == "Linux" ]; then
    # assuming Debian/Ubuntu Linux
    # sudo apt-get install -y wget build-essential

    build_linux64_lib

    plugin_base=../../../../scancode-toolkit-master/plugins/extractcode-7z-manylinux1_x86_64/src/extractcode_7z/bin
    cp bin/7z bin/7z.so $plugin_base
    mkdir -p $plugin_base/Codecs
    cp bin/Codecs/Rar29.so $plugin_base/Codecs
    echo "Build complete: extractcode-7z-manylinux1_x86_64 updated with binaries"

else
    echo "ERROR: Unsupported build OS '$os_name'"
    exit 1
fi
