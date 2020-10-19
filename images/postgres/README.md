## dotcms/postgres docker image
---
This image is based off the default postgresl 12 image.  To add to your compose:

```
  db:
    image: dotcms/postgres
    command: postgres -c 'max_connections=400' -c 'shared_buffers=128MB'
    environment:
        "POSTGRES_USER": 'dotcmsdbuser'
        "POSTGRES_PASSWORD": 'password'
        "POSTGRES_DB": 'dotcms'
    volumes:
      - dbdata:/var/lib/postgresql/data
    networks:
      - db_net
```


To build:
```
docker build --build-arg pgdata_home=/pgdata -t dotcms/postgres .
```

