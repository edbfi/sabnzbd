# syntax=docker/dockerfile:1
# check=skip=InvalidDefaultArgInFrom
ARG UPSTREAM_IMAGE
ARG UPSTREAM_TAG_SHA
ARG UPSTREAM_DIGEST_ARM64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_ARM64} AS builder

ARG VERSION_PAR2TURBO
ARG PAR2_SHA256

RUN apk add --no-cache \
        curl \
        autoconf \
        automake \
        build-base && \
    mkdir /par2turbo && \
    curl -fsSL "https://github.com/animetosho/par2cmdline-turbo/archive/refs/tags/v${VERSION_PAR2TURBO}.tar.gz" -o /tmp/par2.tar.gz && \
    echo "${PAR2_SHA256}  /tmp/par2.tar.gz" | sha256sum -c - && \
    tar xzf /tmp/par2.tar.gz -C /par2turbo --strip-components=1 && \
    cd /par2turbo && \
    aclocal && \
    automake --add-missing && \
    autoconf && \
    ./configure && \
    make && \
    make install


FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_ARM64}
EXPOSE 8080
ARG IMAGE_STATS
ENV IMAGE_STATS=${IMAGE_STATS} WEBUI_PORTS="8080/tcp"

COPY --from=builder /usr/local/bin/par2* /usr/local/bin/

ARG VERSION
ARG SOURCE_SHA256
RUN curl -fsSL "https://github.com/sabnzbd/sabnzbd/archive/${VERSION}.tar.gz" -o /tmp/sabnzbd.tar.gz && \
    echo "${SOURCE_SHA256}  /tmp/sabnzbd.tar.gz" | sha256sum -c - && \
    tar xzf /tmp/sabnzbd.tar.gz -C "${APP_DIR}" --strip-components=1 && \
    rm /tmp/sabnzbd.tar.gz && \
    cd "${APP_DIR}" && python3 tools/make_mo.py && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

RUN apk add --no-cache py3-pip && \
    apk add --no-cache --virtual=build-dependencies \
        build-base \
        libffi-dev \
        openssl-dev \
        musl-dev \
        cargo \
        python3-dev \
        rust && \
    pip3 install --break-system-packages --upgrade pip && \
    pip3 install --break-system-packages -r "${APP_DIR}/requirements.txt" && \
    apk del --purge build-dependencies

RUN apk add --no-cache ffmpeg && \
    mkdir -p "${APP_DIR}/bin" && \
    cp /usr/bin/ffprobe "${APP_DIR}/bin/ffprobe"

COPY root/ /
RUN find /etc/s6-overlay/s6-rc.d -name "run*" -execdir chmod +x {} +
