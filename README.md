Gizur.com web site built with Wordpress and 320 theme
====================================================

Contents:

 * wordpress-3.4.2
 * wordpress-bootstrap-v2.3


Docker
------

Use the repo https://github.com/colmsjo/docker.git to setup a docker server.

This directory contains a Dockerfiles that build a apache server with PHP installed: 

`docker build .`

alternative:

`docker build -rm -no-cache .`

A MySQL database needs to be created before Wordpress can be started. Here we are creating the database
from a temporary container. This can be done from any MySQl client but running it from within a 
container is also a good way the check that the networking works between containers.


```
# Just copy and paste the contents of this script in the mysql client.
cat create-database.sql

# Start a container, just for running this script in
docker run -t -i -dns=172.17.42.1 ubuntu /bin/bash

# Install dig, nano and mysql-client
apt-get install -y dnsutils nano net-tools ping mysql-client

# Check if the DNS finds the MySQL server
dig mysql.local

# Paste the create-database.sql script, change the password if you want
mysql -h mysql.local -u admin -p
```

Now we need to import the wordpress contents. Let's do that from traditional way (you need mysql-client installed):
`mysql -ugizur_com -pXXX -h172.17.0.X gizur_com < [DATE].sql`

The database credentials are fetched from a environment variable like this one:
DATABASE_URL='mysql://gizur_com:XXXX@mysql.local/gizur_com?reconnect=true'

`docker run -d -dns=172.17.42.1 -e=DATABASE_URL='mysql://gizur_com:XXXX@mysql.local/gizur_com?reconnect=true' [ID]`

NOTE: This does not work. Open wp-config.php and edit manually.


Now check that everything is ok:

```
docker inspect [ID]

curl 172.17.0.XX:8080
```


Heroku
------

This wordpress installation has been adapted in order to run on Heroku. See wp-config.php for the details.
There is also a wp-config.php.traditional which can be used on traditional servers (update with MySQL credentials
and rename to wp-config.php).

Heroku is setup in the following way (assuming the heroku command line tools are installed):

```
heroku create --stack cedar --remote production
heroku rename REPO-NAME # Or call it whatever you like for your project

heroku addons:add stillalive:basic
Adding stillalive:basic on mysterious-ravine-7314... done, v3 (free)
Thank you. Please log in to StillAlive via Heroku to setup your monitoring.
Use `heroku addons:docs stillalive:basic` to view documentation.

heroku addons:add cleardb:ignite     # Adds the MySQL option to the Heroku app's config
Adding cleardb:ignite on mysterious-ravine-7314... done, v4 (free)
Use `heroku addons:docs cleardb:ignite` to view documentation.

heroku config                        # See the URLs for your new databases
heroku config:add DATABASE_URL=mysql://... # Replace the "mysql://..." with the URL from CLEARDB_DATABASE_URL

#update cleardb-credentials with the new credentials
```

Update wp-config.php with:

 * random strings from here: https://api.wordpress.org/secret-key/1.1/salt/


Then commit and push to heroku!


Avoid idling
-----------

Heroku will idle the web dyno after a period of inactivity. This can be avoided.

```
heroku ps:scale web=2
```

For develpoment and test environments is 1 web dyno sufficient (and cheaper).


```
heroku ps:scale web=1
```


Watch the number of running processes:

```
watch heroku ps
```


Importing and exporting the MySQL database
------------------------------------------

Saving the cleardb credentials in a text file makes importing and export easier.
Make a copy of cleardb-credentials.template and update with the credemntials for 
the database crated above.


```
heroku config

cp cleardb-credentials.template cleardb-credentials
nano cleardb-credential
```

Import a database dump:

```
git pull

source cleardb-credentials

mysql -u$DBUSER -p$DBPASSWD -h$DBHOST $DBNAM < [DATE].sql
```


Export database when changes has been performed in wordpress:

```
source cleardb-credentials

mysqldump -u$DBUSER -p$DBPASSWD -h$DBHOST $DBNAME > [DATE].sql

git add [DATE].sql
git commit -am "Added new db dump"
git push
```

IMPORTANT: Login to Wordpress and goto the Settings->General

Change the Site Adress (URL) to www.gizur.com for the production instance



