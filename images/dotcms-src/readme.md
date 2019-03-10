# DOTCMS SRC

This image contains a clone of the git repo and the gradle dependices from the time this image was created.  It is intended to act as a build seed when building dotcms images.

## How to update
```
docker build --no-cache -t dotcms-src .
docker login
docker tag dotcms-src dotcms/dotcms-src:latest
docker push dotcms/dotcms-src

```
