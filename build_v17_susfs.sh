#!/bin/bash
set -e
cd ~/work/k13
export ARCH=arm64
export CROSS_COMPILE=$HOME/xbin/aarch64-linux-gnu-
S=scripts/config
$S --file ~/work/k13out/.config --set-str LOCALVERSION "-perf-gg529b93d3e14"
rm -f ~/work/k13out/include/generated/compile.h
rm -f ~/work/k13out/init/version.o
export KBUILD_BUILD_VERSION=1
export KBUILD_BUILD_TIMESTAMP="Sat Jun 20 23:16:42 UTC 2026"
export KBUILD_BUILD_USER=android-build
export KBUILD_BUILD_HOST=abfarm662
export KBUILD_COMPILER_STRING='Android (7284624, based on r416183b) clang version 12.0.5 (https://android.googlesource.com/toolchain/llvm-project c935d99d7cf2016289302412d708641d52d2f7ee)'
make O=$HOME/work/k13out HOSTCC="gcc -fcommon" olddefconfig > /dev/null 2>&1
make -j12 O=$HOME/work/k13out HOSTCC="gcc -fcommon" Image.gz > ~/work/v17build.log 2>&1
echo "BUILD_EXIT=$?"
tail -n 10 ~/work/v17build.log

cd ~/work/stock
mkbootimg --header_version 1 --os_version 13.0.0 --os_patch_level 2026-02 \
  --kernel ~/work/k13out/arch/arm64/boot/Image.gz --ramdisk out/ramdisk \
  --pagesize 0x00000800 --base 0x00000000 --kernel_offset 0x00080000 --ramdisk_offset 0x07c78000 \
  --second_offset 0x00f00000 --tags_offset 0x07a78000 --board '' \
  --cmdline 'loglevel=4 initcall_debug=n page_tracker=on slub_min_objects=16 unmovable_isolate1=2:192M,3:224M,4:256M printktimer=0xfff0a000,0x534,0x538 androidboot.selinux=permissive androidboot.init_fatal_reboot_target=recovery androidboot.super_partition=system buildvariant=userdebug' \
  -o boot-susfs-v17.img
STOCK_SIZE=$(stat -c%s boot.img)
cp boot-susfs-v17.img boot-susfs-v17-padded.img
truncate -s $STOCK_SIZE boot-susfs-v17-padded.img
rm -rf chk17 && unpack_bootimg --boot_img boot-susfs-v17-padded.img --out chk17 >/dev/null
python3 - <<'EOF'
import zlib, re
o = zlib.decompressobj(31).decompress(open('chk17/kernel', 'rb').read())
print(re.search(rb'Linux version [^\n\0]+', o).group(0).decode())
EOF
cp boot-susfs-v17-padded.img /mnt/e/Projects/MediapadM5BakaSU/boot-susfs-v17-padded.img
ls -la /mnt/e/Projects/MediapadM5BakaSU/boot-susfs-v17-padded.img
