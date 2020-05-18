# Single Node with HA Proxy

This reference implementation demonstrates how the dotCMS can be configured for HA/Load balancing.  It provides an pre-tuned HA proxy instance that will load balance incoming traffic to the configured dotCMS nodes.


If you are looking to scale this configuration beyond 1 node, you will need to have a valid license pack mounted into the dotCMS image.   If you need a trial license, you can request one here:


 To add this license to your instances, you can upload the license pack into dotCMS in the System > Configuration > Licensing screen to script this at startup, you can replace this line: 
```#- [serverpath]/license.zip:/data/shared/assets/license.zip```

with a line like:
```
- ./license.zip:/data/shared/assets/license.zip
```
where the path before the colon points to the license pack on the host filesystem.

You should have at least 5GB of RAM dedicated to Docker for all of the containers to run.
If you are running this stack for a production system, normal capacity planning is needed to determine the amount of resources needed to effeciently handle system load.

## docker-compose
### startup
1. Ensure license pack is mounted properly into the dotCMS image as discussed above.
2. In the same directory as the docker-compose.yml file, run:
```docker-compose up```  
3. Wait for dotCMS to finish starting up.  The inital startup takes an extra amount of time as it has to create the schema and data for the database.  You know that it is finished starting and intializing when you see ```Deployment of web application directory [/srv/dotserver/tomcat-8.5.32/webapps/ROOT] has finished in```...
4. Now you can access dotCMS via http://localhost/ (or by other relevant IP or DNS entry)

### cleanup
1.  In terminal window where docker-compose was run, hit ```<Ctrl-C>```  This will causing the docker services to stop. 
2. To ensure the networks are stopped and all containers have been stopped cleanly, run ```docker-compose down```
3. These commands will stop all containers and docker networks that were started; however, the data has been persisted in named volumes.
4. The command ```docker volume ls``` will list all of the docker volumes.  If you wish to remove volumes, you can use the ```docker volume rm ... ``` syntax.
