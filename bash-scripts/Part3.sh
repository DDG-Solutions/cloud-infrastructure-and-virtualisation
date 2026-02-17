#!/bin/bash
# This script does the work from [Docker Workshop Part 3](https://docs.docker.com/get-started/workshop/04_sharing_app/)

REPO=getting-started
USERNAME=

docker login
docker tag $REPO $USERNAME/$REPO
docker push $USERNAME/$REPO
