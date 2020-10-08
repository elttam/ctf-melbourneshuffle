# Overview

**Title:** melbourne shuffle  
**Category:** web  
**Flag:** libctf{2f6e86ef-509d-4ace-927d-37432d5dddac}  
**Difficulty:** silliness

# Usage

The following will pull the latest 'elttam/ctf-melbourneshuffle' image from DockerHub, run a new container named 'libctfso-melbourneshuffle', run a mysql container and publish the vulnerable service on port 80:

```sh

docker run --rm \
  --publish 80:80 \
  --env=MYSQL_RANDOM_ROOT_PASSWORD=1 \
  --env=MYSQL_DATABASE=somedb \
  --env=MYSQL_USER=notroot \
  --env=MYSQL_PASSWORD=bBbzmqQ48mm1 \
  -it mysql:latest

docker run --rm \
  --network="container:$(sudo docker ps -aqf ancestor=mysql:latest)" \
  --name libctfso-melbourneshuffle\
  elttam/ctf-melbourneshuffle:latest

```

# Build (Optional)

If you prefer to build the 'elttam/ctf-melbourneshuffle' image yourself you can do so first with:

```sh
docker build ${PWD} \
  --tag elttam/ctf-melbourneshuffle:latest
```
