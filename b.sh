#!/bin/bash

SCRIPTDIR=$(dirname $(realpath ${BASH_SOURCE[0]}))
cd $SCRIPTDIR

export ZEPHYR_TOOLCHAIN_VARIANT=host

#west build -p auto -b <your-board-name> samples/basic/blinky
#west build -p auto -b nucleo_g431rb samples/basic/blinky
#west build -p auto -b qemu_cortex_m3 --build-dir build_qemu_m3 samples/synchronization
#west build -p auto -b native_posix --build-dir build_posix samples/synchronization
west build -p auto -b native_posix_64 --build-dir build_posix_64 samples/synchronization
cp subsys/debug/tracing/ctf/tsdl/metadata build_posix_64/ZEPHYR_TOOLCHAIN_VARIANT
