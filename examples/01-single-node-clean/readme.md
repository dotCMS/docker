# Clean Reference Implementation

This docker-compose file is the simpliest way to try dotCMS.  It provides 3 services, a Postgres DB server, an Elasticsearch Server and a dotCMS server.  Please note that this is just an example and should not be used in a production environment.

A valid license is NOT required for this configuration to work properly; however, if you want to mount a valid license pack into the dotCMS image, you can do that by replacing this line: 
```#- [serverpath]/license.zip:/data/shared/assets/license.zip```

with a line like:
```
- ./license.zip:/data/shared/assets/license.zip
```
where the path before the colon points to the license pack on the host filesystem.

You should have at least 4GB of RAM dedicated to Docker for the 3 containers to run.
This configuration is not recommended for production use. 

### startup
1. If desired, ensure license pack is mounted properly into the dotCMS image as discussed above.
2. In the same directory as the docker-compose.yml file, run:
```docker-compose up```  
3. Wait for dotCMS to finish starting up.  The inital startup takes an extra amount of time as it has to create the schema and data for the database.  You know that it is finished starting and intializing when you see ```Deployment of web application directory [/srv/dotserver/tomcat-8.5.32/webapps/ROOT] has finished in```...
4. Now you can access dotCMS via http://localhost:8080/ (or by other relevant IP or DNS entry)

### cleanup
1.  In terminal window where docker-compose was run, hit ```<Ctrl-C>```  This will causing the docker services to stop. 
2. To ensure the networks are stopped and all containers have been stopped cleanly, run ```docker-compose down```
3. These commands will stop all containers and docker networks that were started; however, the data has been persisted in named volumes.
4. The command ```docker volume ls``` will list all of the docker volumes.  If you wish to remove volumes, you can use the ```docker volume rm ... ``` syntax.

## Notes:
Running any containerized environment is complex.  Configuration is REQUIRED to secure and maximize the scaleability of dotCMS running in such an environment.  In order to do this, we recommend reading more about the dotCMS docker images here:
https://dotcms.com/docs/latest/docker

