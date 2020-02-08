#!/bin/zsh

#west build -p auto -b <your-board-name> samples/basic/blinky
#west build -p auto -b nucleo_g431rb samples/basic/blinky
west build -b qemu_cortex_m3 --build-dir build_qemu_m3 samples/synchronization
