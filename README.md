# Introduction 简介 
Wine-CE (Chimera Edition, Cross-architecture Emulator) is a compatibility layer capable of running Windows applications on  Cross-architecture paltform of Linux. It is base on Wine Project and Qemu Project.

Wine-CE (奇美拉架构, 跨指令架构模拟器) 是在不同指令集架构Linux系统上运行Windows程序的兼容层，它基于Wine项目和Qemu项目。

# Architecture 架构

```
+---------------------+                                  \
|     Windows EXE     |                                   } application
+---------------------+                                  /

+---------+ +---------+                                  \
| Windows | | Windows |                                   \ application & system DLLs
|   DLL   | |   DLL   |                                   /
+---------+ +---------+                                  /

+---------+ +---------+     +-----------+  +--------+  \
|  GDI32  | |  USER32 |     |           |  |        |   \
|   DLL   | |   DLL   |     |           |  |  Wine  |    \
+---------+ +---------+     |           |  | Server |     \ core system DLLs
+---------------------+     |           |  |        |     / (on the left side)
|    Kernel32 DLL     |     | Subsystem |  | NT-like|    /
|  (Win32 subsystem)  |     |Posix, OS/2|  | Kernel |   /
+---------------------+     +-----------+  |        |  / 
                                           |        |
+---------------------------------------+  |        |
|                 NTDLL                 |  |        |
+---------------------------------------+  +--------+
+---------------------------------------+               \
|            Qemuloader executable      |                } emulate loader
+---------------------------------------+               /
+---------------------------------------+               \
|                 QEMU                  |                } special QEMU
+---------------------------------------+               /
+---------------------------------------------------+   \
|                   Wine drivers                    |    } Wine specific DLLs
+---------------------------------------------------+   /

+------------+    +------------+     +--------------+   \
|    libc    |    |   libX11   |     |  other libs  |    } unix shared libraries
+------------+    +------------+     +--------------+   /  (user space)

+---------------------------------------------------+   \
|         Unix kernel (Linux,*BSD,Solaris,OS/X)     |    } (Unix) kernel space
+---------------------------------------------------+   /
+---------------------------------------------------+   \
|                 Unix device drivers               |    } Unix drivers (kernel space)
+---------------------------------------------------+   /
```

Wine-CE Only Emulator Windows DLLS based on GUEST Instruction Arcitecture and qemuloader. and forward call of Unixlib to Host for executing. Based on the principle of unnecessary simulation, it has faster performance.

Wine-CE 只模拟基于客端指令架构的Windows动态链接库和qemuloader，并将针对Unix库的调用转发到主端执行。基于非必要不模拟的原则，使它拥有更快的性能。

# Install 安装

## Install dependent packages 安装依赖包

If you use ARM64 Linux, you should run

如果你使用ARM64 Linux，你需要先执行

```
sudo dpkg --add-architecture armhf
sudo apt update
```

Install dependent packages

然后安装依赖包

```
sudo apt install fonts-liberation fonts-wine glib-networking:armhf gstreamer1.0-plugins-good:armhf gstreamer1.0-x:armhf
  i965-va-driver:armhf intel-media-va-driver:armhf libaa1:armhf libaom3:armhf libasound2-plugins:armhf libavc1394-0:armhf
  libavcodec59:armhf libavutil57:armhf libcaca0:armhf libcairo-gobject2:armhf libcodec2-1.0:armhf libdav1d6:armhf
  libdv4:armhf libgdk-pixbuf-2.0-0:armhf libgomp1:armhf libgpm2:armhf libgstreamer-plugins-good1.0-0:armhf
  libiec61883-0:armhf libigdgmm12:armhf libjack-jackd2-0:armhf libmp3lame0:armhf libncurses6:armhf libncursesw6:armhf
  libnuma1:armhf libodbc2:armhf libproxy1v5:armhf libraw1394-11:armhf librsvg2-2:armhf librsvg2-common:armhf
  libsamplerate0:armhf libshine3:armhf libshout3:armhf libslang2:armhf libsnappy1v5:armhf libsoup2.4-1:armhf libsoxr0:armhf
  libspeex1:armhf libspeexdsp1:armhf libsvtav1enc1:armhf libswresample4:armhf libtag1v5:armhf libtag1v5-vanilla:armhf
  libtwolame0:armhf libva-drm2:armhf libva-x11-2:armhf libva2:armhf libvdpau1:armhf libvkd3d-shader1:armhf libvkd3d1:armhf
  libvpx7:armhf libwavpack1:armhf libwebpmux3:armhf libwine:armhf libx264-164:armhf libx265-199:armhf libxdamage1:armhf
  libxvidcore4:armhf libz-mingw-w64 libzvbi-common libzvbi0:armhf mesa-va-drivers:armhf mesa-vdpau-drivers:armhf
  va-driver-all:armhf vdpau-driver-all:armhf vkd3d-compiler:armhf p7zip-full
```

## Download Binary package 下载二进制包

Download wine-ce.7z from release, and decompress to /opt/

从release发行版下载wine-ce.7z并解压到/opt/

```
7z x wine-ce.7z -r -o /opt/
sudo ln -s /opt/bin/wine-i386 /usr/bin/wine-i386
```

# Usage 使用方法
```
wine-i386 app_name arg1, arg2, ...
```

# Build From Source 从源码构建

Note: The operating system used in this tutorial is Ubuntu 22.10 AARCH64

注意：此教程所用的操作系统为 Ubuntu 22.10 AARCH64 （64位ARM指令架构计算机）

## Install Build Tools 安装构建工具
```
sudo apt install gcc-12-arm-linux-gnueabihf clang lld meson ninja-build gcc-multilib libc6-dev-i386-cross libgcc-12-dev-i386-cross

sudo apt install libasound2-dev libpulse-dev libdbus-1-dev libfontconfig-dev libfreetype6-dev libgnutls28-dev libtiff-dev libgl-dev libunwind-dev libxml2-dev libxslt1-dev libfaudio-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libmpg123-dev libosmesa6-dev libsdl2-dev libudev-dev libvkd3d-dev libvulkan-dev libcapi20-dev liblcms2-dev libcups2-dev libgphoto2-dev libsane-dev libgsm1-dev libldap2-dev samba-dev ocl-icd-opencl-dev libpcap-dev libusb-1.0-0-dev libv4l-dev libopenal-dev libxcomposite-dev libglib2.0-dev libnet1-dev

sudo apt install libasound2-dev:armhf libgcc-11-dev:armhf libpulse-dev:armhf libdbus-1-dev:armhf libfontconfig-dev:armhf libfreetype6-dev:armhf libgnutls28-dev:armhf libjpeg62-turbo-dev:armhf libtiff-dev:armhf libgl-dev:armhf libunwind-dev:armhf libxml2-dev:armhf libxslt1-dev:armhf libfaudio-dev:armhf libgstreamer1.0-dev:armhf libmpg123-dev:armhf libosmesa6-dev:armhf libsdl2-dev:armhf libudev-dev:armhf libvulkan-dev:armhf libcapi20-dev:armhf liblcms2-dev:armhf libcups2-dev:armhf libgphoto2-dev:armhf libsane-dev:armhf libgsm1-dev:armhf libldap2-dev:armhf samba-dev:armhf ocl-icd-opencl-dev:armhf libpcap-dev:armhf libusb-1.0-0-dev:armhf libv4l-dev:armhf libopenal-dev:armhf libxcomposite-dev:armhf libgstreamer1.0-dev:armhf libglib2.0-dev:armhf
```

## Dowload Source 下载源码
```
git clone https://gitee.com/fanwenjie/wine-ce.git
cd wine-ce
git submodule init
git submodule update
```

## Build WINE 构建WINE
```
cd wine

PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig \
i386_CC="clang -fuse-ld=lld --target=i686-pc-windows" \
i386_UNIX_CC="clang -fuse-ld=lld --target=i686-pc-linux --sysroot=/usr/i686-linux-gnu -L/usr/lib/gcc-cross/i686-linux-gnu/12/" \
arm_CC="clang -fuse-ld=lld -mllvm -arm-assume-misaligned-load-store -munaligned-access -mfloat-abi=hard -mfpu=fp-armv8 -mcpu=cortex-a72 --target=armv7-pc-windows" \
arm_UNIX_CC="clang -fuse-ld=lld -mllvm -arm-assume-misaligned-load-store -munaligned-access -mfloat-abi=hard -mfpu=fp-armv8 -mcpu=cortex-a72 -mthumb --target=armv7-pc-linux-gnueabihf" \
CC="arm-linux-gnueabihf-gcc-12 -mfloat-abi=hard -mfpu=neon-fp-armv8 -mthumb -mcpu=cortex-a72" \
TARGETFLAGS="-b arm-linux-gnueabihf" \
./configure --prefix=/opt/wine-ce/ --disable-tests --build=arm-linux-gnueabihf --host=arm-linux-gnueabihf --enable-archs=arm,i386

make -j6

sudo make install

cd ..
```

## Build QEMU 构建QEMU
```
mkdir build.qemu

cd build.qemu

PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig \
CC="arm-linux-gnueabihf-gcc-12 -mcpu=cortex-a72 -mfpu=neon-fp-armv8 -mthumb" \
CXX="$CC" HOST_CC="$CC" CC_FOR_BUILD="$CC" LDFLAGS="-Wl,--export-dynamic -Wl,-Ttext-segment=0x80000000 -Wl,-z,max-page-size=0x1000 -Wl,-Bdynamic,-lm -Wl,-Bdynamic,-lc -Wl,-Bstatic -static-libgcc" ../qemu/configure --without-default-features --without-default-devices --disable-fdt --target-list=i386-linux-user --cpu=armv7l --meson=meson --enable-ca11c0de --disable-rcu

ninja -j6

cd ..
```

## Copy Files 复制文件
```
sudo cp build.qemu/qemu-i386 /opt/wine-ce/bin/
chmod +x bin/wine-i386
sudo cp bin/wine-i386 /opt/wine-ce/bin/
sudo ln -s /opt/wine-ce/bin/wine-i386 /usr/bin/wine-i386
```

## Install DXVK (Option) 可选安装DXVK
For specific steps, please refer to dxvk/README.md

具体步骤可参考dxvk/README.md

# TODO 待做事项
Optimize Video Audio

优化视频和音频

# Demo 演示视频
Test Platform: Raspberrypi 400

Test Program:

Warcraft III:       https://www.bilibili.com/video/BV1qK411k7mu

Sword and Fairy 3:  https://www.bilibili.com/video/BV1Kd4y157Lm