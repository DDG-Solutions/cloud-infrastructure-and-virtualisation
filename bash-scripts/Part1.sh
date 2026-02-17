#!/bin/bash
# This script does the work from [Docker Workshop Part 1](https://docs.docker.com/get-started/workshop/02_our_app/)

DIRECTORY="getting-started-app"

find -type d -name $DIRECTORY

if [ -d $DIRECTORY ]; then
    echo "$DIRECTORY exists."
else
    git clone https://github.com/docker/getting-started-app.git
fi

if [ -f $DIRECTORY/Dockerfile ]; then
    echo "Dockerfile exists."
else
    cat << EOF > $DIRECTORY\/Dockerfile
FROM node:24-alpine
WORKDIR /app
COPY . .
RUN npm install --omit=dev
CMD ["node", "src/index.js"]
EXPOSE 3000
EOF
    echo "Dockerfile Created"
fi

cd $DIRECTORY

docker build -t getting-started .

# docker run -d -p 127.0.0.1:3000:3000 getting-started