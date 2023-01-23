#!/bin/sh
script_txt=" #!/bin/sh                                                                          \n
script_path=\$0                                                                                 \n
script_path=\$(realpath \$script_path)                                                          \n
if [ \$# -lt 1 ] || [ \"\$1\" = \"--help\" ]  ; then                                            \n
    echo \"Usage: \$script_path PROGRAM [ARGUMENTS...]   Run the specified program\"            \n
    echo \"       \$script_path --help                   Display this help and exit\"           \n
    echo \"       \$script_path --version                Output version information and exit\"  \n
    exit 1;                                                                                     \n
fi                                                                                              \n
if [ \$# -lt 1 ] || [ \"\$1\" = \"--version\" ]  ; then                                         \n
    echo \`\$(dirname \$script_path)/wine --version\`                                           \n
    exit 1;                                                                                     \n
fi                                                                                              \n
current_path=\`pwd\`                                                                            \n
wine_dir=\$(cd \$(dirname \$(dirname \$script_path));pwd)                                       \n
wine_unix_path=\$(cd \$wine_dir/lib/wine/*-unix;pwd)                                            \n
host_arch=\`echo \$(basename \$wine_unix_path) | cut -d - -f 1\`                                \n
guest_arch=\`echo \$(basename \$script_path) | cut -d - -f 2\`                                  \n
wine_pe_path=\$wine_dir/lib/wine/\$guest_arch-windows                                           \n
cd \"\$current_path\"                                                                           \n
export LD_PRELOAD=\$wine_unix_path/ntdll.so:\$wine_unix_path/win32u.so                          \n
exec \"\$wine_dir/bin/qemu-\$guest_arch\" \"\$wine_pe_path/qemuloader\" \$@ "

script_path=$0
if [ -h $script_path ]
then
    script_path=$(readlink $script_path)
fi

if [ $# -lt 1 ] || [ "$1" = "--help" ] || [ ! -d $1 ]; then
    echo "Usage: $script_path wine_install_dir/bin"
    exit 1;
fi

script_dir=$(cd $(dirname $script_path);pwd)
install_dir=$(cd $1;pwd)

guest_arch="i386"
if [ -e $install_dir/qemu-i386 ] ; then
    echo $script_txt>$install_dir/wine-$guest_arch
    chmod +x $install_dir/wine-$guest_arch
fi

guest_arch="x86_64"
if [ -e $install_dir/qemu-$guest_arch ] ; then
    echo $script_txt>$install_dir/wine-$guest_arch
    chmod +x $install_dir/wine-$guest_arch
    current_dir=`pwd`
    cd "$install_dir"
    ln -sf wine-$guest_arch wine-i386
    cd "$current_dir"
fi

guest_arch="arm"
if [ -e $install_dir/qemu-$guest_arch ] ; then
    echo $script_txt>$install_dir/wine-$guest_arch
    chmod +x $install_dir/wine-$guest_arch
fi

guest_arch="aarch64"
if [ -e $install_dir/qemu-$guest_arch ] ; then
    echo $script_txt>$install_dir/wine-$guest_arch
    chmod +x $install_dir/wine-$guest_arch
fi