#!/bin/bash
if [ $1 == '-b' ]; then
    echo "[job.build] Creating backend docker image!"
    PROJECT_BASE="registry.digitalocean.com/orchestramanager" ./docker/build/build-backend.sh 
elif [ $1 == '-f' ]; then
    echo "[job.build] Creating frontend docker image!"
    PROJECT_BASE="registry.digitalocean.com/orchestramanager" REACT_APP_API_URI="https://back.tfg.orchestramanager.pw" ./docker/build/build-frontend.sh
else
    echo "Usage: [-f] to build frontend and [-b] to build backend"
fi
exit 1