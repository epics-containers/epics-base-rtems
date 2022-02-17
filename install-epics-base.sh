#!/usr/bin/env bash
EPICS_TOP="${1:-/epics}"
RTEMS_KERNEL="${2:-/rtems/rtems}"
RTEMS_TOOLCHAIN="${3:-/rtems/toolchain}"
EPICS_VERSION=R7.0.6.1
cd ${EPICS_TOP}
git config --global advice.detachedHead false
git clone --recursive --depth 1 -b ${EPICS_VERSION} \
    https://github.com/epics-base/epics-base.git
rm -fr ${EPICS_BASE}/.git

cd epics-base
patch -p1 < ${EPICS_TOP}/rtems-epics-base.patch
echo "RTEMS_KERNEL = ${RTEMS_KERNEL}" >> configure/CONFIG_SITE.local
echo "RTEMS_TOOLCHAIN = ${RTEMS_TOOLCHAIN}" >> configure/CONFIG_SITE.local
cat configure/CONFIG_SITE.local
make -j $(nproc)
