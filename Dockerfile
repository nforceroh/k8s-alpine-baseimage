FROM alpine:3.21

ARG \
  BUILD_DATE=now \
  VERSION=unknown \
  S6_OVERLAY_VERSION="3.2.0.2" \
  S6_OVERLAY_ARCH="x86_64"

LABEL \
  org.label-schema.maintainer="Sylvain Martin (sylvain@nforcer.com)" \
  org.label-schema.version=$VERSION \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-type=Git \
  org.label-schema.description="Alpine linux base image" \
  org.label-schema.vcs-url="https://github.com/nforceroh/k8s-alpine-baseimage"

ENV \
    S6_LOGGING=1 \
    S6_VERBOSITY=1 \
    S6_FIX_ATTRS_HIDDEN=1 \
    S6_KILL_FINISH_MAXTIME=300000 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    PUID=3001 \
    PGID=3000 \
    TZ=America/New_York

RUN \
  echo "**** Installing/Upgrading alpine packages ****" \
  && apk upgrade --quiet --no-cache \
  && apk add --quiet --no-cache tar xz alpine-release rxvt-unicode-terminfo shadow libc-utils apk-tools procps-ng \
     jq bind-tools openssl tzdata ca-certificates coreutils bash git wget curl findutils openssl busybox

RUN \
  echo "**** Adding S6 overlay ****" \
  && curl --location --silent https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz | tar -C / -Jxp \
  && curl --location --silent https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz | tar -C / -Jxp \
  && curl --location --silent https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz | tar -C / -Jxp \
  && curl --location --silent https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz | tar -C / -Jxp

RUN \
  echo "**** cleanup ****" \
  && apk del --quiet --no-cache --purge \
  && rm -rf /var/cache/apk/*  

COPY rootfs/ /

ENTRYPOINT [ "/init" ]
#CMD /bin/ash