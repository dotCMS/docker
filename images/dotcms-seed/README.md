# DOTCMS SEED

This image contains a clone of the git repo and the gradle dependices from the time this image was created.  It is intended to act as a build seed when building dotcms images.

## How to update
```
docker build --no-cache -t dotcms-seed .
docker login
docker tag dotcms-seed dotcms/dotcms-seed:latest
docker push dotcms/dotcms-seed

```
