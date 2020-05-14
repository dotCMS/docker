FROM gcr.io/cicd-246518/build-cms-image

#  One of ["TARBALL_URL", "RELEASE", "NIGHTLY", "COMMIT", "TAG" ]
ARG BUILD_FROM=COMMIT
#  Value resolved in the context of $BUILD_FROM
ARG BUILD_ID=HEAD

USER 0

WORKDIR /srv

COPY ROOT/ /
# Make scripts runable
RUN find /srv/ -type f -name "*.sh" -exec chmod a+x {} \;

USER 1000000000

ENTRYPOINT ["/sbin/tini", "--", "/srv/entrypoint.sh"]
CMD ["dotcms"]
