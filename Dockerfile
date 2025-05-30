FROM alpine:3.21

ARG \
  BUILD_DATE=now \
  VERSION=unknown \
  S6_OVERLAY_VERSION="3.2.0.2" \
  S6_OVERLAY_ARCH="x86_64"

LABEL \
  org.label-schema.maintainer="Sylvain Martin (sylvain@nforcer.com)" 
  
ENV \
    S6_LOGGING=1 \
    S6_VERBOSITY=1 \
    S6_FIX_ATTRS_HIDDEN=1 \
    S6_KILL_FINISH_MAXTIME=300000 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    TZ=America/New_York \
    ENABLE_CRON=false

RUN \
  echo "**** Installing/Upgrading alpine packages ****" \
  && apk upgrade --quiet --no-cache \
  && apk add --quiet --no-cache tar xz alpine-release rxvt-unicode-terminfo shadow libc-utils apk-tools procps-ng \
     jq bind-tools openssl tzdata ca-certificates coreutils bash git wget curl findutils busybox

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

COPY --chmod=755 /content/etc/s6-overlay /etc/s6-overlay

ENTRYPOINT [ "/init" ]
#CMD /bin/ash