# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Set noninteractive installation to avoid some issues when installing in Docker
# ENV DEBIAN_FRONTEND=noninteractive

# Time Consuming Installation >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Update and install core dependencies (installing these package is really time-consuming)
RUN apt-get update && apt-get install -y \
    sudo \
    git \
    wget \
    cmake \
    build-essential \
    gdb \
    libboost-all-dev

# Install Anaconda
RUN apt-get install -y wget && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda.sh && \
    bash /opt/miniconda.sh -b -u -p /opt/conda && \
    rm /opt/miniconda.sh

# Time Consuming Installation <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# Other dependencies >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
RUN apt-get install -y \
    libspdlog-dev \
    libfmt-dev
# Other dependencies <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# Set the time zone >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
ENV TZ=Asia/Singapore
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ >/etc/timezone
# Set the time zone <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

ARG PROJECT_NAME
ARG USER_NAME
ARG UID
ARG GID

# Add sudo User: $USER_NAME >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

RUN groupadd -g $GID $USER_NAME && \
    useradd -u $UID -g $GID -ms /bin/bash $USER_NAME && \
    echo "${USER_NAME}:${USER_NAME}" | chpasswd && \
    usermod -aG sudo $USER_NAME

USER $USER_NAME
WORKDIR /home/$USER_NAME
# Add sudo User: $USER_NAME <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# Create new conda environment and activate it >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Set path to conda
ENV PATH=/opt/conda/bin:$PATH

# Create a new Conda environment from the environment.yaml file if it exists.
# If the environment.yaml file does not exist, create a default Conda environment.
RUN --mount=type=bind,source=.,target=/home/$USER_NAME/$PROJECT_NAME \
    if [ -f "/home/$USER_NAME/$PROJECT_NAME/environment.yaml" ]; then \
    echo "environment.yaml found. Creating Conda environment from it."; \
    conda env create --name $PROJECT_NAME -f /home/$USER_NAME/$PROJECT_NAME/environment.yaml; \
    else \
    echo "environment.yaml not found. Creating default Conda environment."; \
    conda create --name $PROJECT_NAME python=3.10 -y; \
    fi

# Set the default environment activated when the container starts
ENV CONDA_DEFAULT_ENV=$PROJECT_NAME
ENV CONDA_PREFIX=/home/$USER_NAME/.conda/envs/$PROJECT_NAME
ENV PATH=$CONDA_PREFIX/bin:$PATH
# Create new conda environment and activate it <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CMD ["/bin/bash"]
