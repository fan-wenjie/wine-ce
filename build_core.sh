#!/bin/sh
install_dir=/opt/wine-ce/
if [ $# -gt 0 ] ; then
    install_dir=$1
fi

echo "install directory: $install_dir"

target_list=""
if [ $(arch) != "aarch64" ] && [ $(arch) != "arm64" ]; then
    target_list="aarch64-linux-user,$target_list"
fi
if [ $(arch) != "x86_64" ] && [ $(arch) != "amd64" ]; then
    target_list="x86_64-linux-user,$target_list"
fi
echo "target-list: $target_list"

cd wine
./configure --prefix="$install_dir" --disable-tests --enable-archs=
make -j$(nproc)
rm -rf $install_dir
make install
cd ..

rm -rf build.qemu
mkdir build.qemu && cd build.qemu
CC=gcc CC_FOR_BUILD="$CC" CXX="$CC" HOST_CC="$CC" \
LDFLAGS="-Wl,-Ttext-segment=0x100000000 -Wl,-z,max-page-size=0x1000 -Wl,-Bstatic,-lglib-2.0 -Wl,-Bdynamic,-ldl" \
../qemu/configure --without-default-features --disable-fdt --disable-system --enable-ca11c0de --disable-rcu --target-list=$target_list
ninja -j$(nproc)
if [ -e qemu-x86_64 ] ; then
    strip qemu-x86_64 -o "$install_dir"/bin/qemu-x86_64
fi
if [ -e qemu-aarch64 ] ; then
    strip qemu-aarch64 -o "$install_dir"/bin/qemu-aarch64
fi
cd ..

sh generate_scripts.sh "$install_dir"/bin