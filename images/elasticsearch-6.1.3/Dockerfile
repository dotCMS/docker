FROM openjdk:8-jdk-alpine as build-plugins

RUN apk --no-cache upgrade
RUN apk add --no-cache openssl gnupg bash curl grep git

RUN mkdir -p /build/plugins/output
WORKDIR /build

COPY plugins/ /build/plugins/src

RUN set -e && \
	for plugin in $( find /build/plugins/src -mindepth 1 -maxdepth 1 -type d -exec basename {} \; ) ; do \
	    cd "/build/plugins/src/${plugin}" && \
		echo "Building plugin \"${plugin}\"..." && \
		./gradlew jar && \
		echo "Plugin classes:" && \
		jar tf build/libs/*.jar && \
		mkdir -p "/build/plugins/output/${plugin}" && \
		cp build/libs/*.jar plugin-descriptor.properties "/build/plugins/output/${plugin}" && \
		cd /build ; \
	done


FROM openjdk:8-jre-alpine


RUN apk --no-cache upgrade \
	&& apk add --no-cache bash openssl ca-certificates gnupg grep s6-dns \
	&& update-ca-certificates

ENV S6_OVERLAY_VERSION v1.21.4.0

# RUN curl https://keybase.io/justcontainers/key.asc | gpg --import \
#    && gpg --verify s6-overlay-amd64.tar.gz.sig s6-overlay-amd64.tar.gz
# https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-amd64.tar.gz.sig

RUN wget --quiet https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz \
    && tar -xzf s6-overlay-amd64.tar.gz -C / \
    && rm s6-overlay-amd64.tar.gz

ENV DOCKERIZE_VERSION v0.6.0
RUN wget --quiet https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz


# Grab gosu for easy step-down from root
ENV GOSU_VERSION 1.10
ENV GOSU_KEY B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN set -x \
	&& wget --quiet -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
	&& wget --quiet -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc"
RUN export GNUPGHOME="$(mktemp -d)" \
	&& set -x \
	&& for key in \
	  "$GOSU_KEY" \
	  ; do \
	    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
        gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
      done \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& sleep 1 && rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true


# ensure elasticsearch user exists
RUN addgroup -S -g 1000 elasticsearch && adduser -u 1000 -SH -G elasticsearch -h /srv elasticsearch

ENV ELASTICSEARCH_VERSION 6.1.3
ENV ELASTICSEARCH_TARBALL="https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz" 
ENV	ELASTICSEARCH_TARBALL_SHA512="af10cc571ab55f52ab73a86373fa8359214a7866fbb6d2910669e6be897bae30c41c007c3be5803a7f07736041f32cf36425c182a18fab39499321ed9eb4b349"

ENV PATH /srv/bin:$PATH

WORKDIR /srv

RUN set -ex; \
	\
	wget --quiet -O elasticsearch.tar.gz "$ELASTICSEARCH_TARBALL"; \
	\
	if [ "${ELASTICSEARCH_TARBALL_SHA512}" ]; then \
		echo "${ELASTICSEARCH_TARBALL_SHA512}  elasticsearch.tar.gz" | sha512sum -c -; \
	fi; \
	\
	tar -xf elasticsearch.tar.gz --strip-components=1; \
	rm elasticsearch.tar.gz; \
	\
	# we shouldn't need much RAM to test --version (default is 2gb, which gets Jenkins in trouble sometimes)
	export ES_JAVA_OPTS='-Xms32m -Xmx32m'; \
	elasticsearch --version;

# Install File-Based Discovery Plugin
RUN bin/elasticsearch-plugin install discovery-file

# Install dotCMS Eleasticsearch plugin
COPY --from=build-plugins /build/plugins/output/ plugins/

COPY ROOT/ /
RUN find /etc/cont-init.d/ /etc/fix-attrs.d/ /srv/ -type f -name "*.sh" -exec chmod 500 {} \; 

ENV SERVICE_DELAY_DEFAULT_MIN 1
ENV SERVICE_DELAY_DEFAULT_STEP 3
ENV SERVICE_DELAY_DEFAULT_MAX 30

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS 2
ENV S6_CMD_ARG0 "/srv/init.sh"

VOLUME /data
VOLUME /logs

EXPOSE 9200 9300

ENTRYPOINT ["/init"]

