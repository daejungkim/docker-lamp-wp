MySQL, apache and phpMyAdmin container
====================================

It is assumed that docker has been setup according to the instructions in this
repo: https://github.com/colmsjo/docker


Installation
-----------

Build the container: `docker build .`

Save the ID of the new image in `/etc/environment` for easy access.

```
cat /etc/environment
...
REDIS_DNS="172.17.42.1"
DOCKER_GIZUR_COM="a57ef736765c"
```

Setup the container as a service:

 * `sudo cp docker/etc/init/docker-TEMPLATE.conf  /etc/init/docker-gizur_com.conf`
 * Update the service with the correct container ID - `sudo nano /etc/init/docker-gizur_com.conf` 
 * Remove this part from the last line (the DNS isn't needed) `-dns=$REDIS_DNS $IMAGE_ID`
 * `sudo service docker-gizur_com start`


Start the container
------------------

Start a container: `docker run -d $DOCKER_GIZUR_COM`

Do `docker ps` and check which port that is mapped towards 8080

Open http://localhost:PORT/phpMyAdmin-4.0.8-all-languages in a web browser and login 
with the credentials below.

Check the IP-adress of the container: `docker inspect [CONTAINER ID]`

Setup hipache entries in redis:

 * `redis-cli rpush frontend:www.gizur.com gizur_com`
 * `redis-cli rpush frontend:www.gizur.com http://[IP ADDRESS]:8080`

Make sure hipache is running: `sudo service hipache status`


Credentials
-----------

MySQL:

 * admin / mysql-server
 * gizur_com / 48796e76

Worpress:

 * admin / 4911287a


Development environemnet
-----------------------

Start phpMyAdmin and login with the gizur_com user.

Update the siteurl field: http://localhost:PORT

Then open Wordpress and login with the admin user: http://localhost:PORT/wp-admin

This makes testing easier:

```
cat /etc/hosts
...
127.0.0.1	gizur.com.local
```

Setup hipache like this:

 * `redis-cli rpush frontend:gizur.com.local gizur_com`
 * `redis-cli rpush frontend:gizur.com.local http://[IP ADDRESS]:8080`

Chck things from outside the virtual machine: `curl http://gizur.com.local:8080`

