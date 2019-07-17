# DOTCMS SRC SEED

This image contains the source files of dotCMS.  It consists of a clone of the dotcms git repo and includes the pre-downloaded gradle dependencies from the time this image was created.  
It is intended to act as the build seed when running dotcms integration tests images, so these dependencies do not need to be downloaded with every build.

## How to update
```
docker build --pull --no-cache -t tests-seed .
docker login
docker tag tests-seed dotcms/tests-seed:latest
docker push dotcms/tests-seed:latest
```