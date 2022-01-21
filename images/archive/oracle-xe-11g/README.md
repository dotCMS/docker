# DOTCMS Oracle eXpress Edition 11g

This image contains the necessary files to start a oracle database

## How to update
```
docker build --pull --no-cache -t oracle-xe-11g .
docker login
docker tag oracle-xe-11g dotcms/oracle-xe-11g:latest
docker push dotcms/oracle-xe-11g
```
