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
cat ./DEPS.txt

# SET VERBOSE; ABORT ON NON-ZERO EXIT CODE
set -x
set -e

# DOWNLOAD/VERIFY SOURCES
SOURCES="."
TOPLVL="$(pwd)"

# DEBUGGER
cd "$SOURCES"/riscv-uart-debugger
./bootstrap.sh
mkdir -p build
cd build
../configure
make
make install
cd $TOPLVL

# RISC-V TOOLCHAIN
cd "$SOURCES"/riscv-gnu-toolchain
./configure --with-arch=rv32i --with-abi=ilp32 --prefix="$PREFIX"
make
cd $TOPLVL

# OTTER-GCC SCRIPT
install -Dm 755 ./otter-devel/otter-gcc $PREFIX/bin/otter-gcc

set +x
set +e

# CLEAN UP
if [ $(confirm "Remove sources?")]; then
    cd "$TOPLVL"
    rm -rf "$SOURCES"
fi
