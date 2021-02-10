#!/bin/bash

set -e

build_source=$1
build_id=$2
tomcat_version=$3
echo "Build source: $build_source"
echo "Build id: $build_id"

build_target_dir=/build/cms
mkdir -p "${build_target_dir}"

get_by_url() {
  build_download_dir=/build/download
  mkdir -p ${build_download_dir}

  echo "Fetching build: $1"
  wget --quiet -O "${build_download_dir}/dotcms.tgz" "$1"
  tar xzf "${build_download_dir}/dotcms.tgz" -C "${build_target_dir}"
  # We should have some verification here, but we have no source of truth yet
}

build_by_commit() {
  mkdir -p /build/src && cd /build/src

  cd /build/src/core
  git clean -f -d
  git pull

  echo "Checking out commit/tag/branch: $1"
  git checkout $1

  cd dotCMS && ./gradlew clonePullTomcatDist createDistPrep -PuseGradleNode=false
  find ../dist/  -name "*.sh" -exec chmod 500 {} \;
  mv ../dist/* "${build_target_dir}"
}

set_tomcat_dir() {
  tomcat_versions=$(find /srv/dotserver/ -type d -name tomcat-* | grep -oP "(?<=tomcat-)[0-9]{1}\.[0-9]{1}\.[0-9]+$ | sort -k1.2n")
  echo "Found tomcat installations:
  ${tomcat_versions}"

  if [[ -n "${tomcat_version}" ]]; then
    echo "Provided Tomcat version: ${tomcat_version}"
    if [[ -n $(echo "${tomcat_versions}" | grep -oP "${tomcat_version}") ]]; then
      echo "Matched tomcat_version: ${tomcat_version} with installed"
    else
      echo "Provided tomcat_version: ${tomcat_version} does not matched installed, aborting"
      exit 1
    fi
  else
    tomcat_version=$(find /srv/dotserver/ -type d -name tomcat-* | grep -oP "(?<=tomcat-)[0-9]{1}\.[0-9]{1}\.[0-9]+$" | sort -k1.2n | tail -n 1)
    [[ -z "${tomcat_version}" ]] && echo "ERROR: Unable to determine Tomcat version" && exit 1
  fi

  echo "Using tomcat_version=${tomcat_version}"
  echo ${tomcat_version} >/srv/TOMCAT_VERSION
}

case "${build_source}" in

  "TARBALL_URL" )

    get_by_url "${build_id}"
    ;;

  "RELEASE" )

    get_by_url "http://static.dotcms.com/versions/dotcms_${build_id}.tar.gz"
    ;;

  "NIGHTLY" )

    echo "ERROR: Not implemented"
    exit 1
    ;;

  "COMMIT" | "TAG" )

    build_by_commit "${build_id}"
    ;;

  *)
    echo "Invalid option"
    exit 1
    ;;
esac

mv ${build_target_dir}/* /srv/

set_tomcat_dir