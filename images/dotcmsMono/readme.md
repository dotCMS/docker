# BUILD dotCMS Docker image from arguments 

This image is an ALPHA version of the dockerfile and requisite build files that are provided with the primary purpose of illustrating dotCMS-distributed image functionality. It is NOT intended for building images for production use.  We encourage you to use the image provided at  https://hub.docker.com/r/dotcms/dotcms/ rather than building your own image.  

Building custom images may create more complexity and challenges as it relates to the ongoing support of your installation.  Please contact support@dotcms.com to inquire about add-on product services available for extended support around Docker.  

Please note that the dotCMS image can be extended via static and dynamic plugins, as well as numerous extension points to the init and configuration functionality.  If you need customized functionality please check documentation on using plugins with docker images before assuming you need to build a custom docker image. 

dotCMS has architected this image to handle many different use cases, providing the best dotCMS product experience while still enabling use of custom functionality with the genuine dotCMS image.

Please send any thoughts or suggestions to improve our docker image to support@dotcms.com.  At the ALPHA release stage, this product is not feature-complete and additional functionality is still being added (and existing functionality may be changed although efforts will be made to minimize breaking changes). Once more comprehensive testing has been completed and input from our users has been incorporated, dotCMS will release official images recommended for use in production. 

If you feel you must create your own custom docker image(s), please contact dotCMS Support to discuss product compatibility and scope-of-support concerns prior to implementation.


# Arguments for building dotCMS docker image: 

|  BUILD_FROM  | BUILD_ID                     |
| ------------ | ---------------              |
| TARBALL_URL  | URL to tar file              |
| RELEASE      | Release number               |
| COMMIT       | Commit hash or branch name to use for build |
| TAG          | Tag to use for build         |


## Examples 

### TARBALL_URL Example 
```
docker build --pull --no-cache --build-arg BUILD_FROM=TARBALL_URL --build-arg BUILD_ID=https://dotcms.com/contentAsset/raw-data/523ef132-4a0b-4f17-9d82-eb2cfec779c6/targz/dotcms-2018-03-09_22-10.tar.gz -t test .

docker run -it -p 8080:8080 test
```

### RELEASE Example 
```
docker build --pull --no-cache --build-arg BUILD_FROM=RELEASE --build-arg BUILD_ID=5.0.2 -t test .

docker run -it -p 8080:8080 test
```

### BRANCH Example 
Where your branch name is `pre-release-5.0.3`.  In this case, becuase a branch is a movable pointer, you need to prune your
images before building in order to purge your image cache and get a clean build.
```
docker build --pull --no-cache --build-arg BUILD_FROM=COMMIT --build-arg BUILD_ID=origin/pre-release-5.0.3 -t test .

docker run -it -p 8080:8080 test
```


### COMMIT Example 
```
docker build --pull --no-cache --build-arg BUILD_FROM=COMMIT --build-arg BUILD_ID=c4e97b3 -t test .

docker run -it -p 8080:8080 test
```

### TAG Example 
```
docker build --pull --no-cache --build-arg BUILD_FROM=TAG --build-arg BUILD_ID=4.2.3-beta -t test .

docker run -it -p 8080:8080 test
```
