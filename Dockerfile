from ubuntu:20.04 as builder
MAINTAINER Trevor McKay <trmckay@calpoly.edu>

RUN mkdir -p /sources
COPY ./otter-devel /sources/
COPY ./riscv-uart-debugger /sources/
COPY ./riscv-gnu-toolchain /sources/
COPY ./bootstrap.sh /sources/

WORKDIR /sources
RUN ls

RUN ./bootstrap.sh
