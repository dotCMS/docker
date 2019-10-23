FROM amazon/opendistro-for-elasticsearch:1.2.0
WORKDIR /usr/share/elasticsearch/

ARG ES_ADMIN_PASSWORD

#Copying ES certificates 
COPY ./certs/root-ca.pem /usr/share/elasticsearch/config/root-ca.pem
COPY ./certs/root-ca.key /usr/share/elasticsearch/config/root-ca.key
COPY ./certs/kirk.pem /usr/share/elasticsearch/config/kirk.pem
COPY ./certs/kirk.key /usr/share/elasticsearch/config/kirk.key
COPY ./certs/elasticsearch.pem /usr/share/elasticsearch/config/elasticsearch.pem
COPY ./certs/elasticsearch.key /usr/share/elasticsearch/config/elasticsearch.key

#Copying ES configuration
COPY ./yml/custom-elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
COPY ./yml/custom-config.yml /usr/share/elasticsearch/plugins/opendistro_security/securityconfig/config.yml
COPY ./yml/internal_users.yml /usr/share/elasticsearch/plugins/opendistro_security/securityconfig/internal_users.yml
COPY ./init.sh /usr/share/elasticsearch/init.sh

RUN chmod 500 /usr/share/elasticsearch/init.sh
ENV ES_ADMIN_PASSWORD=$ES_ADMIN_PASSWORD
RUN /bin/bash -c "/usr/share/elasticsearch/init.sh"