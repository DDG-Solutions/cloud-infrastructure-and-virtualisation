#!/bin/bash
# # This script does the work from [Docker Workshop Part 2](https://docs.docker.com/get-started/workshop/03_updating_app/)

FILE="getting-started-app/src/static/js/app.js"

if [ -f $FILE ]; then
echo "file is present"
else
echo "file is not present"
fi

SEARCH='<p className="text-center">No items yet! Add one above!</p>'
REPLACE='<p className="text-center">You have no todo items yet! Add one above!</p>'

grep "$SEARCH" "$FILE" && 
{
    sed -i "s|$SEARCH|$REPLACE|g" "$FILE"
    printf "File updated!\n\n"
} || printf "File not updated\n\n"

cd getting-started-app
docker build -t getting-started .

# docker run -dp 127.0.0.1:3000:3000 getting-started