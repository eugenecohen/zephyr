#!/bin/zsh

# prerequisites
#
# install brew
# brew install cmake ninja gperf ccache dfu-util qemu dtc python3
# pip3 install west
# west init / update
# pip3 install -r scripts/requirements.txt


export PATH=$PATH:~/Library/Python/3.7/bin

export ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb
export GNUARMEMB_TOOLCHAIN_PATH=/opt/gcc

echo sourcing zephyr-env.sh
source zephyr-env.sh
