# docker-assessment

Purpose:
-------

The aim of this project is to build an image containing a simple web application hosted on an Apache web server by integrating haproxy as reverse-proxy.

Prerequisites:
-------------

1- Docker and docker compose need to be installed on the test machine
2- Delete the .placeholder files from the apache-logs and haproxy-logs folders

Steps to reproduce:
-------------------

1- Move to the root directory of the project
2- Build the image by running the following command:
   docker-compose build
2- Run the container by executing the next command:
   docker-compose up -d