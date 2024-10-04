#!/bin/bash

PROJECT_NAME="mahrl_ugv"
USER_NAME="dockeruser"

# Navigate to the directory containing this script (docker folder)
cd "$(dirname "$0")"

# Run the Docker container, mounting the parent directory as a volume
docker run \
	--gpus all \
	-dit \
	--name $PROJECT_NAME \
	--cap-add=SYS_PTRACE \
	-v $(pwd)/..:/home/$USER_NAME/$PROJECT_NAME \
	$PROJECT_NAME:0.0.1 \
	/bin/bash
