FROM dotcms/haproxy-seed

LABEL com.dotcms.contact "support@dotcms.com"
LABEL com.dotcms.vendor "dotCMS LLC"
LABEL com.dotcms.description "dotCMS HAProxy 1.8"

RUN rm /docker-entrypoint.sh

WORKDIR /

RUN apk --no-cache upgrade \
    && apk add --no-cache bash openssl ca-certificates gnupg grep tini s6-dns go git gcc musl-dev libc6-compat \
    && update-ca-certificates

# Download and build dockerize distributed under MIT license (https://github.com/jwilder/dockerize)
RUN wget --quiet https://github.com/jwilder/dockerize/archive/v0.6.1.tar.gz \
    && tar -C / -xzf v0.6.1.tar.gz  \
    && cd /dockerize-0.6.1 \
    && go get github.com/hpcloud/tail \
    && go get github.com/jwilder/gojq \
    && go get golang.org/x/net/context \
    && go build \
    && cp dockerize-0.6.1 /usr/local/bin/dockerize \
    && chmod a+x /usr/local/bin/dockerize

RUN rm v0.6.1.tar.gz
RUN apk del  git gcc musl-dev

COPY ROOT/ /
RUN mkdir -p /srv/config

RUN find /srv/ -type f -name "*.sh" -exec chmod 500 {} \; 

RUN chmod -R g=u /srv

ENV SERVICE_DELAY_DEFAULT_MIN 1
ENV SERVICE_DELAY_DEFAULT_STEP 3
ENV SERVICE_DELAY_DEFAULT_MAX 30


EXPOSE 8080
EXPOSE 8443

USER 10001

ENTRYPOINT ["/sbin/tini", "--", "/srv/entrypoint.sh"]
CMD ["haproxy"]
