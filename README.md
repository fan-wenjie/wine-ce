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
|         Qemuloader executable         |                } emulate loader
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

Wine-CE Only Emulator Windows DLLS based on GUEST Instruction Arcitecture and qemuloader. and forward call of Unixlib to Host for executing. Based on the principle of non-essential non-emulation, it has faster performance.

Wine-CE 只模拟基于客端指令架构的Windows动态链接库和qemuloader，并将针对Unix库的调用转发到主端执行。基于非必要不模拟的原则，使它拥有更快的性能。

# Install 安装

NOTE:

If you want to run 32-bit windows app On 64-bit host platform, Vulkan-driver must supports VK_EXT_external_memory_host, Otherwise error "returned mapping * does not fit 32-bit pointer" may occur.

如果要在64位宿主机平台运行32位windows应用，Vulkan驱动必须支持VK_EXT_external_memory_host，否则可能出现错误"returned mapping * does not fit 32-bit pointer"

## Install dependent packages 安装依赖包



Install dependent packages

然后安装依赖包

```
sudo apt install fonts-liberation fonts-wine glib-networking libpulse0 gstreamer1.0-plugins-good gstreamer1.0-x libaa1 libaom3 libasound2-plugins  libcaca0 libcairo-gobject2 libcodec2-1.0 libdav1d6 libdv4 libgdk-pixbuf-2.0-0 libgomp1 libgpm2 libiec61883-0 libjack-jackd2-0 libmp3lame0 libncurses6 libncursesw6 libnuma1 libodbc2 libproxy1v5 libraw1394-11 librsvg2-2 librsvg2-common libsamplerate0 libshine3 libshout3 libslang2 libsnappy1v5 libsoup2.4-1 libsoxr0 libspeex1 libspeexdsp1 libtag1v5 libtag1v5-vanilla libtwolame0 libva-drm2 libva-x11-2 libva2 libvdpau1 libvkd3d-shader1 libvkd3d1 libvpx7 libwavpack1 libwebpmux3 libx265-199 libxdamage1 libxvidcore4 libzvbi-common libzvbi0 mesa-va-drivers mesa-vdpau-drivers va-driver-all vdpau-driver-all vkd3d-compiler
```


## Download Binary package 下载二进制包

Download wine-ce_dlls_{version}.all.tar.xz and wine-ce_core_{version}.{host_arch}.tar.xz from release, and decompress to /opt/

从release发行版下载wine-ce_dlls_{version}.all.tar.xz 和 wine-ce_core_{version}.{host_arch}.tar.xz并解压到/opt/

```
sudo tar -Jxvf wine-ce_core_{version}.{host_arch}.tar.xz -C /opt/
sudo tar -Jxvf wine-ce_dlls_{version}.all.tar.xz -C /opt/
sudo ln -sf /opt/wine-ce/bin/wine /usr/bin/wine
sudo ln -sf /opt/wine-ce/bin/winecfg /usr/bin/winecfg
```

Delete Old and Create New wine prefix directory.

WARNING: DO NOT run emulated program before create or update wine prefix directory. Recommend Running winecfg first for update wine prefix directory.

删除旧的并创建新的wine prefix文件夹.

警告：不要在创建或更新wine prefix文件夹前在模拟模式下运行程序，首次运行建议先打开winecfg触发更新操作。

```
rm -rf ~/.wine
winecfg
```

# Build From Source 从源码构建

## Download Source 下载源码
```
git clone https://gitee.com/fanwenjie/wine-ce.git
cd wine-ce
git submodule init
git submodule update
```

## Install Build Tools 安装构建工具
```
sudo apt install clang lld meson ninja-build gcc flex bison libc6-dev-amd64-cross libc6-dev-arm64-cross libasound2-dev libpulse-dev libdbus-1-dev libfontconfig-dev libfreetype6-dev libgnutls28-dev libtiff-dev libgl-dev libegl-dev libunwind-dev libxml2-dev libxslt1-dev libfaudio-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libmpg123-dev libosmesa6-dev libsdl2-dev libudev-dev libvkd3d-dev libvulkan-dev libcapi20-dev liblcms2-dev libcups2-dev libgphoto2-dev libsane-dev libgsm1-dev libkrb5-dev libldap2-dev samba-dev ocl-icd-opencl-dev libpcap-dev libusb-1.0-0-dev libv4l-dev libpcsclite-dev libxcomposite-dev libglib2.0-dev libnet1-dev python3-pip
```

Running build_all.sh or follow below steps to manually build

运行build_all.sh或者按照以下步骤手动构建

## Build WINE 构建WINE

```
cd wine

i386_CC="clang -fuse-ld=lld --target=i686-pc-windows" \
x86_64_CC="clang -fuse-ld=lld --target=x86_64-pc-windows" \
x86_64_UNIX_CC="clang -fuse-ld=lld --target=x86_64-pc-linux -I/usr/x86_64-linux-gnu/include" \
aarch64_CC="clang -fuse-ld=lld --target=aarch64-pc-windows" \
aarch64_UNIX_CC="clang -fuse-ld=lld --target=aarch64-pc-linux -I/usr/aarch64-linux-gnu/include -march=armv8+lse" \
./configure --prefix=/opt/wine-ce --disable-tests --enable-archs=i386,x86_64,aarch64

make -j$(nproc)

sudo make install

cd ..
```

NOTE: You can only build Core By below Command and Download and extract wine-ce_dlls_{version}.all.tar.xz

提示：如果只编译核心，可以运行以下命令， 然后下载并解压wine-ce_dlls_{version}.all.tar.xz

```./configure --prefix=/opt/wine-ce --disable-tests --enable-archs=```

## Build QEMU 构建QEMU
```
mkdir build.qemu

cd build.qemu

CC=gcc CC_FOR_BUILD="$CC" CXX="$CC" HOST_CC="$CC" LDFLAGS="-Wl,-Ttext-segment=0x100000000 -Wl,-z,max-page-size=0x1000 -Wl,-Bstatic,-lglib-2.0 -Wl,-Bdynamic,-ldl" ../qemu/configure --without-default-features --disable-fdt --disable-system --enable-ca11c0de --disable-rcu --target-list=x86_64-linux-user,aarch64-linux-user

ninja -j$(nproc)

cd ..
```

## Copy Files 复制文件
```
sudo strip build.qemu/qemu-x86_64 -o /opt/wine-ce/bin/qemu-x86_64
sudo strip build.qemu/qemu-aarch64 -o /opt/wine-ce/bin/qemu-aarch64
sudo sh generate_scripts.sh  /opt/wine-ce/bin/
sudo ln -sf /opt/wine-ce/bin/wine /usr/bin/wine
sudo ln -sf /opt/wine-ce/bin/winecfg /usr/bin/winecfg
```

## Install DXVK (Option) 可选安装DXVK

### Install Build Tools 安装构建工具

```
sudo apt install mingw-w64 glslang-tools
```

### Running Build Script 运行构建脚本

```
sudo sh build_dxvk.sh
```

# Demo 演示视频

## RISCV

Test Platform: VisionFive 2

Test Program:

Scar of Sky: https://www.bilibili.com/video/BV1gv4y1578t

## ARM

Test Platform: Raspberrypi 400

Test Program:

Sword and Fairy 3:  https://www.bilibili.com/video/BV1yc41157iS