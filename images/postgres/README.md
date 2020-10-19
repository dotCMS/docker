## dotcms/postgres docker image
---
This image is based off the default postgresl 12 image.  By default, it stores data under `/pgdata` folder, which should be mounted or mapped to a named volume.


To add to your compose:

```
  db:
    image: dotcms/postgres
    command: postgres -c 'max_connections=400' -c 'shared_buffers=512MB' -c 'effective_cache_size=1536MB' -c 'maintenance_work_mem=128MB'
    environment:
        "POSTGRES_USER": 'dotcmsdbuser'
        "POSTGRES_PASSWORD": 'password'
        "POSTGRES_DB": 'dotcms'
    volumes:
      - dbdata:/pgdata
    networks:
      - db_net
```


To build:
```
docker build --build-arg pgdata_home=/pgdata -t dotcms/postgres12 .
```

Multiarch build:
```
docker buildx build --platform linux/amd64,linux/arm64 --pull --push --build-arg pgdata_home=/pgdata -t dotcms/postgres:12 .

```


