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

# SET VERBOSE; ABORT ON NON-ZERO EXIT CODE
set -x
set -e

# DEBIAN/UBUNTU Dependencies
sudo apt update
sudo apt install -y \
    python3 \
    make \
    git \
    cargo \
    build-essential \
    gcc \
    curl \
    libreadline-dev \
    autoconf \
    automake \
    autotools-dev \
    curl \
    python3 \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    gawk \
    build-essential \
    bison \
    flex \
    texinfo \
    gperf \
    libtool \
    patchutils \
    bc \
    zlib1g-dev \
    libexpat-dev

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
sudo -E make install
cd $TOPLVL

# RISC-V TOOLCHAIN
cd "$SOURCES"/riscv-gnu-toolchain
mkdir -p build
cd build
../configure --with-arch=rv32i --with-abi=ilp32 --prefix="$PREFIX"
sudo -E make
cd $TOPLVL

# OTTER-GCC SCRIPT
sudo install -Dm 755 ./otter-devel/otter-gcc $PREFIX/bin/otter-gcc

set +x
set +e

# CLEAN UP
if [ $(confirm "Remove sources?")]; then
    cd "$TOPLVL"
    rm -rf "$SOURCES"
fi
