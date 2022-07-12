#!/bin/bash
WORKING_DIR=$(pwd)
BASE_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
PROJECT_DIR=$BASE_DIR/../../..
NAME="backend"
PROJECT_BASE="${PROJECT_BASE:="orchestramanager.pw/app"}"
IMAGE_NAME="$PROJECT_BASE/$NAME"

echo "[job.build] Image output will be: $IMAGE_NAME"

cd $PROJECT_DIR

echo "[job.build] Cleaning up files and subdirectories..."
rm -r dist/$NAME/.* &> dist/build.log
rm -r dist/$NAME/* &> dist/build.log

echo "[job.build] Copying folders from 'src/*' and Dockerfile..."

cp -r "$PROJECT_DIR/src/$NAME" "dist/" &> dist/build.log

cp -r "$PROJECT_DIR/templates/docker/images/$NAME" "dist/" &> dist/build.log

docker rmi -f $IMAGE_NAME &> dist/build.log
if [ $? -ne 0 ]; then
    echo " an error ocurred. Check build.log for details!"
    exit 1;
fi
echo "[job.build] Building docker image..."
docker build -t $IMAGE_NAME $PROJECT_DIR/dist/$NAME
if [ $? -ne 0 ]; then
    echo " an error ocurred. Check build.log for details!"
    exit 1;
fi
echo "[job.build] Saving docker image..."
mkdir -p cluster/images/$PROJECT_BASE
docker image save -o cluster/images/$IMAGE_NAME $IMAGE_NAME &> dist/build.log
if [ $? -ne 0 ]; then
    echo " an error ocurred. Check build.log for details!"
    exit 1;
fi
echo "[job.build] Done."

