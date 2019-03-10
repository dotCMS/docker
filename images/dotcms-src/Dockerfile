# OpenJDK distributed under GPLv2+Oracle Classpath Exception license (http://openjdk.java.net/legal/gplv2+ce.html)
# Alpine Linux packages distributed under various licenses including GPL-3.0+ (https://pkgs.alpinelinux.org/packages)
FROM openjdk:8-jdk-alpine as dotcms-src

LABEL com.dotcms.contact "info@dotcms.com"
LABEL com.dotcms.vendor "dotCMS LLC"
LABEL com.dotcms.description "dotCMS Content Management System"

#  Value resolved in the context of $COMMIT

WORKDIR /srv

# Build env dependencies
RUN apk update && apk --no-cache add bash grep openssl git nodejs-current nodejs-current-dev sed

# dotCMS core distributed under GPLv3 license (https://github.com/dotCMS/core/blob/master/license.txt)
RUN mkdir -p /build/src
RUN echo "Pulling dotCMS src"
RUN cd /build/src && git clone https://github.com/dotCMS/core.git core
RUN cd /build/src/core/dotCMS && ./gradlew  --no-daemon 
RUN cd /build/src/core/dotCMS && ./gradlew  --no-daemon  -b immutables.gradle clean
RUN cd /build/src/core/dotCMS && ./gradlew  --no-daemon  clonePullTomcatDist

