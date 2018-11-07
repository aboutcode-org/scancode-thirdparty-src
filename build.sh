#!/bin/sh
#
# Copyright (c) 2017 nexB Inc. http://www.nexb.com/ - All rights reserved.
#
# A simple re/build script for ScanCode thirdparty native deps on Linux
# Requirements:
# - a Linux 64bits installation
# - the scancode requirements in development versions and a toolchain
#   on RH/Fedora/Centos likely something like:
#      yum install -y libxslt-devel python-devel
#   on Deb/Ubuntu likely something like:
#      for libarchive: apt-get install build-essential zlib1g-dev liblzma-dev libbz2-dev
#
# This script assume that you have a checkout of scancode-toolkit
# side-by-side with this directory


set -e

echo "Building libarchive ..."
(cd libarchive && ./build.sh)

echo "Building 7zip ..."
(cd 7z/p7z-9.38.1 && ./build.sh)

echo "Building libmagic ..."
(cd file/5.23 && ./build.sh)
