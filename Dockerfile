FROM debian as builder
MAINTAINER Trevor McKay <trmckay@calpoly.edu>

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ./DEPS_deb.txt /DEPS.txt
COPY ./otter-devel/otter-gcc /usr/bin
COPY ./bootstrap.sh /bootstrap.sh

RUN apt update -y && apt install -y $(cat DEPS.txt)
RUN rm DEPS.txt

RUN ./bootstrap.sh
RUN rm ./bootstrap.sh
