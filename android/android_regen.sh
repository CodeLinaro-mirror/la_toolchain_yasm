#!/bin/bash -ex
#
# Copyright 2026 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Regenerate host configuration files for the current host

cd `dirname ${BASH_SOURCE[0]}`

ANDROID_BUILD_TOP=$(cd ../../..; pwd)

UNAME=$(uname | tr 'A-Z' 'a-z')
config_opts=()
case $UNAME in
    linux)
        NAME=linux
        config_opts+=("CFLAGS=-std=gnu11 --sysroot=$ANDROID_BUILD_TOP/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/sysroot")
        config_opts+=("LDFLAGS=--sysroot=$ANDROID_BUILD_TOP/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/sysroot -B$ANDROID_BUILD_TOP/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/lib/gcc/x86_64-linux/4.8.3 -L$ANDROID_BUILD_TOP/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/lib/gcc/x86_64-linux/4.8.3 -L$ANDROID_BUILD_TOP/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/x86_64-linux/lib64")
        config_opts+=("CC=$ANDROID_BUILD_TOP/prebuilts/clang/host/linux-x86/$(cd $ANDROID_BUILD_TOP; build/soong/scripts/get_clang_version.py)/bin/clang")
        ;;
    darwin)
        NAME=darwin
        ;;
    *)
        >&2 echo Unknown host $UNAME
        exit 1
        ;;
esac

mkdir -p $NAME
cd $NAME

rm -rf tmp
mkdir tmp
cd tmp
../../../configure --disable-nls "${config_opts[@]}"

mv config.h ../

cd ../
rm -rf tmp
