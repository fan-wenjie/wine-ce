#!/bin/sh
install_dir=/opt/wine-ce/
if [ $# -gt 0 ] ; then
    install_dir=$1
fi

echo "install directory: $install_dir"

cd dxvk
rm -rf dxvk-1.10.x
./package-release.sh 1.10.x `pwd` --no-package
cp -f dxvk-1.10.x/x32/* "$install_dir"/lib/wine/i386-windows/
cp -f dxvk-1.10.x/x64/* "$install_dir"/lib/wine/x86_64-windows/
cd ..
