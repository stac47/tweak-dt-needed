#!/usr/bin/env bash

set -o errexit
set -o xtrace


#find . -type f -not \( -name "*.c" -and -name "*.sh" \) -exec rm {} \;

pushd libcommon > /dev/null
gcc -g -c -fPIC -Wall common.c
gcc -g -shared -Wl,-soname,libcommon.so.1 -o libcommon.so common.o
popd

ln -s libcommon/libcommon.so libcommon.so.1
ln -s libcommon.so.1 libcommon.so
readelf -d libcommon.so.1 | grep NEEDED

pushd libsvc > /dev/null
gcc -g -c -fPIC -Wall svc.c
gcc -g -shared -Wl,-soname,libsvc.so.1 -o libsvc.so svc.o
popd

ln -s libsvc/libsvc.so libsvc.so.1
ln -s libsvc.so.1 libsvc.so
readelf -d libsvc.so.1 | grep NEEDED

gcc -g -Wall main.c -o main -L. -lsvc -lcommon -ldl
readelf -d main | grep NEEDED
