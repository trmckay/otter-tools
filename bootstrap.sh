#!/bin/bash

# YES OR NO PROMPT
function confirm() {
    read -p "$1 [y/n]: " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        return 1
    fi
    return 0
}

# CONFIGURE PREFIX
if [ $1 ]; then
    PREFIX="$1"
else
    PREFIX='/usr'
fi

echo "Installing to: $PREFIX"

echo "Verify all dependencies have been installed:"
cat ./DEPS_deb.txt

# SET VERBOSE; ABORT ON NON-ZERO EXIT CODE
set -x
set -e

# DOWNLOAD/VERIFY SOURCES
TOPLVL="$(pwd)"

# DEBUGGER
git clone https://github.com/trmckay/riscv-uart-debugger
cd riscv-uart-debugger
./bootstrap.sh
mkdir -p build
cd build
../configure --prefix="$PREFIX"
make
make install
cd $TOPLVL
rm -rf riscv-uart-debugger

# RISC-V TOOLCHAIN
git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
cd riscv-gnu-toolchain
./configure --with-arch=rv32i --with-abi=ilp32 --prefix="$PREFIX"
make
cd $TOPLVL
rm -rf riscv-gnu-toolchain

# OTTER-GCC SCRIPT
install -m 0555 otter-gcc/otter-gcc $PREFIX/bin/otter-gcc
