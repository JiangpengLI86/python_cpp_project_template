#!/bin/bash

PROJECT_NAME="mahrl_ugv"
USER_NAME="dockeruser"

# Navigate to the directory containing this script (docker folder)
cd "$(dirname "$0")"

# Build the Docker image (setting the build context to the parent directory and Dockerfile path)
DOCKER_BUILDKIT=1 docker build \
    --build-arg USER_NAME=$USER_NAME \
    --build-arg PROJECT_NAME=$PROJECT_NAME \
    -t $PROJECT_NAME:0.0.1 \
    -f Dockerfile \
    ..

# Notes about the DOCKER_BUILDKIT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# The DOCKER_BUILDKIT environment variable is set to 1 to enable BuildKit features, which is used in the following line in the Dockerfile:
# RUN --mount=type=bind,source=.,target=/home/$USER_NAME/$PROJECT_NAME \
# This line is needed since the docker does not support condtional copy of files to the container (in this case, the environment.yaml file).
# This line is used to temporarily mount the parent directory as a volume during the build process.

# If the following error occurs:
# ERROR: BuildKit is enabled but the buildx component is missing or broken.
#        Install the buildx component to build images with BuildKit:
#        https://docs.docker.com/go/buildx/
# You can install the buildx component by running the following command:
# sudo apt update && sudo apt install -y docker-buildx-plugin

# Notes about the DOCKER_BUILDKIT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<