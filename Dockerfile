FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update

RUN apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    git \
    rsync \
    wget \
    ffmpeg \
    htop \
    nano \
    libatlas-base-dev \
    libboost-all-dev \
    libeigen3-dev \
    libhdf5-serial-dev \
    libleveldb-dev \
    liblmdb-dev \
    libopenblas-dev \
    libopenblas-base \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libffi7

RUN apt-get autoremove -y && \
    apt-get autoclean -y && \
    apt-get clean -y  && \
    rm -rf /var/lib/apt/lists/*

ENV WRKSPCE="/workspace"

RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-py37_23.1.0-1-Linux-x86_64.sh \
    && bash Miniconda3-py37_23.1.0-1-Linux-x86_64.sh -b -p $WRKSPCE/miniconda3 \
    && rm -f Miniconda3-py37_23.1.0-1-Linux-x86_64.sh

    
ENV PATH="$WRKSPCE/miniconda3/bin:${PATH}"


RUN conda install -n base -c defaults conda python=3.7

COPY requirements.txt .

RUN conda install --yes -c pytorch pytorch=1.7.1 torchvision cudatoolkit=11.0
RUN pip install ftfy regex tqdm wandb
RUN pip install opencv-python boto3 requests pandas
RUN pip install -r requirements.txt

RUN conda clean -y --all

RUN mkdir /.cache /.config && \
    chmod 777 /.cache /.config && \
    chmod -R 777 /.cache /.config

RUN chmod -R 777 /workspace