# Docker assessment

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for testing purposes.

## Prerequisites

Docker and docker compose need to be installed on the test machine

Delete the .placeholder files from the apache-logs and haproxy-logs folders

## Installing

Move to the root directory of the project

Build the image by running the following command:
``` 	
docker-compose build
```
Run the container by executing the next command:
```
docker-compose up -d
```
## Testing

Test the application by launching the follwoing URL:
```
http://<machine_IPaddress>/Breakout/
```
You will perceive a redirection to the https protocol managed by the HAProxy on port 443

Test the HAProxy Statistics Report by launching the URL:
```
http://<machine_IPaddress>:1936
```
