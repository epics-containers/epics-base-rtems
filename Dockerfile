
##### shared environment stage #################################################

FROM ubuntu:20.04 AS environment
# 20.04 latest LTS: Canonical will support it with updates until April 2025
# with extended security updates until April 2030

# environment
ENV RTEMS_TOP=/rtems
ENV EPICS_TOP=/epics
ENV EPICS_BASE=${EPICS_TOP}/epics-base
ENV EPICS_HOST_ARCH=linux-x86_64
ENV PATH="${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}"
ENV LD_LIBRARY_PATH=${EPICS_BASE}/lib/${EPICS_HOST_ARCH}
ARG EPICS_VERSION=R7.0.6.1

RUN mkdir -p ${RTEMS_TOP} && \
    mkdir -p ${EPICS_TOP}

WORKDIR ${EPICS_TOP}

##### build stage ##############################################################

FROM environment AS developer

# install build tools and utilities
RUN apt-get update -y && apt-get upgrade -y && \
    export TERM=linux && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    busybox \
    python \
    python-dev \
    bison \
    flex \
    texinfo \
    git \
    diffutils \
    unzip \
    pax \
    && rm -rf /var/lib/apt/lists/*

COPY install-rtems.sh ${RTEMS_TOP}
COPY install-epics-base.sh ${EPICS_TOP}
COPY rtems-epics-base.patch ${EPICS_TOP}

RUN cd ${RTEMS_TOP} && bash install-rtems.sh ${RTEMS_TOP} && rm install-rtems.sh

RUN cd ${EPICS_TOP} && bash install-epics-base.sh \
    ${EPICS_TOP} ${RTEMS_TOP}/rtems ${RTEMS_TOP}/toolchain && \
    rm install-epics-base.sh


