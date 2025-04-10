FROM jlesage/baseimage-gui:ubuntu-22.04-v4.5.2 AS build

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Berlin
ENV LANG en_US.UTF-8 \
    LC_ALL en_US.UTF-8 \
    LANGUAGE en_US:en  \
    NUMBA_CACHE_DIR /tmp

ENV QT_DEBUG_PLUGINS=1
ENV QT_XCB_NO_MITSHM=2
ENV QT_PLUGIN_PATH="/opt/conda/envs/anylabeling/lib/python3.12/site-packages/PyQt5/Qt5/plugins/platforms"

ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libstdc++.so.6"
ENV LD_LIBRARY_PATH "/usr/local/nvidia/lib:/usr/local/nvidia/lib64"
ENV CONDA_BIN_PATH="/opt/conda/bin"
ENV PATH $CONDA_BIN_PATH:$PATH
ENV NVIDIA_DRIVER_CAPABILITIES "all"


RUN apt-get update -y && apt-get install -qqy build-essential 

RUN apt-get install -y -q --no-install-recommends \
            gcc \
            tar \
            wget \
            qtcreator \
            python3-dev \
            python3-pip \
            python3-wheel \
            libblas-dev \
            liblapack-dev \
            libgl1 \
            mesa-utils \
            libgl1-mesa-glx \
            libxcb-xinerama0 \
            libatlas-base-dev \
            gfortran \
            apt-utils \
            bzip2 \
            ca-certificates \
            curl \
            locales \
            libarchive-dev \
            libxkb* \
            cmake \
            libxcb-cursor0 \
            python-is-python3 \
            unzip &&  apt-get clean


RUN rm -rf /var/lib/apt/lists/* 

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

WORKDIR /tmp
RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh \
    && bash Miniforge3-Linux-x86_64.sh -b -p /opt/conda \
    && rm -f Miniforge3-Linux-x86_64.sh 

RUN conda install mamba -n base -c conda-forge && \
    mamba create -y --name anylabeling python=3.12 && \
    /opt/conda/envs/anylabeling/bin/pip install anylabeling-gpu && \
    /opt/conda/envs/anylabeling/bin/pip install PyQt5 


EXPOSE 5800

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

ENV APP_NAME="Anylabeling"

ENV KEEP_APP_RUNNING=0
ENV TAKE_CONFIG_OWNERSHIP=1
ENV HOME /config
WORKDIR /config
