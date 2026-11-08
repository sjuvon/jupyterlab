########################################################################
# Version 2
# Container for JupyterLab
#
# 1. Install system libraries
# 2. Create user & group
# 3. Install Python packages (including JupyterLab)
# 4. Switch user
########################################################################

# Host: Ubuntu 24.04.4

FROM python:3.11.11-slim
LABEL maintainer="sj"

# Parsed using env file at docker compose:
ARG APP_HOME
ARG APP_PORT
ARG APP_USER

USER root

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    sudo \
    vim \
    htop \
    btop \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE $APP_PORT

RUN addgroup jupyter \
    && adduser --uid 1001 --ingroup jupyter $APP_USER

WORKDIR $APP_HOME

COPY --chown=$APP_USER:jupyter requirements.txt ./requirements.txt

RUN python -m pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && rm -rf /root/.cache/pip

COPY --chown=$APP_USER:jupyter . .

USER $APP_USER

