#!/bin/bash
export NDK=~/Android/Sdk/ndk/21.4.7075529
export MINSDKVERSION=23 # Marshmellow - NEON enabled
ABIS="armeabi-v7a arm64-v8a x86 x86_64"

mkdir -p out
mkdir -p out/bin
mkdir -p out/include
cp -r ./include out/include/soloud
cd out

for ABI in ${ABIS}
do
mkdir -p build
cd build
# ToDo: how to create a release build?
cmake \
	-DCMAKE_TOOLCHAIN_FILE=$NDK/build/cmake/android.toolchain.cmake \
	-DANDROID_ABI=$ABI \
	-DANDROID_NATIVE_API_LEVEL=$MINSDKVERSION \
	-DSOLOUD_BACKEND_SDL2=OFF -DSOLOUD_BACKEND_NOSOUND=ON \
	-DSOLOUD_DYNAMIC=OFF -DSOLOUD_STATIC=ON \
	-DSOLOUD_BACKEND_OPENSLES=ON \
	../../contrib
make -j 20
cd ..
mkdir -p bin/${ABI}
cp build/libsoloud.a bin/${ABI}
rm -rf build
done
