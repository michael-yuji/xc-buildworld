#!/bin/sh

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

git clone --depth 1 -b ${BRANCH} ${REPO:="https://git.freebsd.org/src.git"} /usr/src
cd /usr/src

make buildworld -j ${NCPU}

