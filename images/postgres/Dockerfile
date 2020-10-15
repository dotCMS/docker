FROM bitnami/postgresql:12

COPY ./sub/postgresql.conf /opt/bitnami/postgresql/conf/postgresql.conf

#RUN chmod a+r /opt/bitnami/postgresql/conf/postgresql.conf

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/postgresql/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/postgresql/run.sh" ]


