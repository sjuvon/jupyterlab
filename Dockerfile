########################################################################
# Version 2
# Container for JupyterLab
#
# 1. Install system libraries
# 2. Create user and group
# 3. Install Python packages (including JupyterLab)
# 4. Switch to user before finishing
########################################################################

# Host: Ubuntu 24.04.4

FROM python:3.11.11-slim
LABEL maintainer="sj"

# Parsed using env file at docker compose:
ARG DOCKERFILE_PORT
ARG DOCKERFILE_USER
ARG DOCKERFILE_WORKDIR

USER root

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    sudo \
    vim \
    htop \
    btop \
    curl
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

EXPOSE $DOCKERFILE_PORT

RUN addgroup jupyter
RUN adduser --uid 1001 --ingroup jupyter $DOCKERFILE_USER

WORKDIR $DOCKERFILE_WORKDIR
COPY --chown=$DOCKERFILE_USER:jupyter requirements.txt ./requirements.txt

RUN python -m pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=$DOCKERFILE_USER:jupyter . .

USER $DOCKERFILE_USER

