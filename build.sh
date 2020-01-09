#!/usr/bin/env bash

set -o errexit
set -o xtrace


pushd libcommon > /dev/null
gcc -g -c -fPIC -Wall common.c
gcc -g -shared -Wl,-soname,libcommon.so.1 -o libcommon.so common.o
popd

ln -sf libcommon/libcommon.so libcommon.so.1
ln -sf libcommon.so.1 libcommon.so
readelf -d libcommon.so.1 | grep NEEDED

pushd libsvc > /dev/null
gcc -g -c -fPIC -Wall svc.c
gcc -g -shared -Wl,-soname,libsvc.so.1 -o libsvc.so svc.o -L .. -lcommon
#gcc -g -shared -Wl,-soname,libsvc.so.1 -o libsvc.so svc.o
popd

ln -sf libsvc/libsvc.so libsvc.so.1
ln -sf libsvc.so.1 libsvc.so
readelf -d libsvc.so.1 | grep NEEDED

gcc -g -Wall main.c -o main -L. -lsvc -lcommon -ldl
#gcc -g -Wall main.c -o main -L. -lsvc -ldl
readelf -d main | grep NEEDED
