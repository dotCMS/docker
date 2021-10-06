# OpenJDK distributed under GPLv2+Oracle Classpath Exception license (http://openjdk.java.net/legal/gplv2+ce.html)
# Alpine Linux packages distributed under various licenses including GPL-3.0+ (https://pkgs.alpinelinux.org/packages)
FROM dotcms/dotcms-seed:5.3.8.5-count as build-cms

LABEL com.dotcms.contact "support@dotcms.com"
LABEL com.dotcms.vendor "dotCMS LLC"
LABEL com.dotcms.description "dotCMS Content Management System"

#  One of ["TARBALL_URL", "RELEASE", "NIGHTLY", "COMMIT", "TAG" ]
ARG BUILD_FROM=COMMIT

#  Value resolved in the context of $BUILD_FROM
ARG BUILD_ID=HEAD

WORKDIR /srv

# dotCMS core distributed under GPLv3 license (https://github.com/dotCMS/core/blob/master/license.txt)
COPY build-src/ /build/
RUN chmod 500 /build/build_dotcms.sh && /build/build_dotcms.sh ${BUILD_FROM} ${BUILD_ID}

RUN mkdir -p /srv/utils /srv/templates /srv/config /srv/home
RUN chmod -R 666 /srv && find /srv/ -type d -exec chmod a+x {} \;

##
## Begin target image build
##

# OpenJDK distributed under GPLv2+Oracle Classpath Exception license (http://openjdk.java.net/legal/gplv2+ce.html)
# Alpine Linux packages distributed under various licenses including GPL-3.0+ (https://pkgs.alpinelinux.org/packages)
#ARG ARCH=arm64v8

FROM adoptopenjdk/openjdk8:jdk8u302-b08-alpine

WORKDIR /srv

RUN apk --no-cache update && apk upgrade \
    && apk add --no-cache bash openssl ca-certificates gnupg grep sed tini nss s6-dns go libpq git gcc musl-dev tomcat-native curl \
    && update-ca-certificates

RUN apk add libsass --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/

# This is a nasty hack for libjsass, Alpine 3.9 no longer has a deprecated symlink in /lib
RUN [ ! -e /lib/ld-linux-x86-64.so.2 ] &&  ln -s $(readlink /lib64/ld-linux-x86-64.so.2) /lib/ld-linux-x86-64.so.2 || :

RUN curl -Ls https://repo.dotcms.com/artifactory/ext-release-local/com/dotcms/dockerize/dockerize-linux-`uname -m` | install /dev/stdin /usr/local/bin/dockerize 

RUN apk del -r --purge git gcc musl-dev go

ENV JAVA_VERSION 8u302
ENV JAVA_ALPINE_VERSION 8.302.01-r0

COPY --from=build-cms /srv/ /srv/
COPY ROOT/ /

# Make scripts runable
RUN find /srv/ -type f -name "*.sh" -exec chmod a+x {} \;

# Make plugin merging directories writable
RUN find /srv/templates -type d -exec chmod 770 {} \;

RUN mkdir -p /data/shared/assets && mkdir -p /data/local/dotsecure/license && chmod -R 660 /data && find /data/ -type d -exec chmod 770 {} \;

ENV SERVICE_DELAY_DEFAULT_MIN 1
ENV SERVICE_DELAY_DEFAULT_STEP 3
ENV SERVICE_DELAY_DEFAULT_MAX 30

#VOLUME /data/local

## JDK upgrade does not take first run, needs to runs
RUN  apk upgrade

## Ports
# Direct connect
EXPOSE 8080
# Connect from proxy, HTTP/80, non-secure
EXPOSE 8081
# Connect from proxy, HTTPS/443, secure
EXPOSE 8082
# Java Debugging - must be configured via CMS_JAVA_OPTS
EXPOSE 8000
# Glowroot profiler - must be configured via CMS_JAVA_OPTS
EXPOSE 4000

USER 1000000000

ENTRYPOINT ["/sbin/tini", "--", "/srv/entrypoint.sh"]
CMD ["dotcms"]