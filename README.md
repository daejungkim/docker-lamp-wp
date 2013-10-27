MySQL, apache and phpMyAdmin container
====================================

Build the container: `docker build .`

Start a container: `docker run -d [ID]`

Do `docker ps` and check which port that is mapped towards 8080

Open http://localhost:PORT/phpMyAdmin-4.0.8-all-languages in a web browser and login with

 * username: admin
 * password: mysql-server
