# build the image required for setting up the repository
# Example run: 
# $ docker build -t wadhwaniai/cough-against-covid:py3-1.0 .
# Creates a docker image with desired dependencies

# base image
FROM nvcr.io/nvidia/pytorch:20.01-py3

RUN apt-get update && apt-get install -y \
    tmux \
    p7zip-full p7zip-rar \
    aufs-tools \
    automake \
    build-essential \
    curl \
    dpkg-sig \
    libcap-dev \
    libsqlite3-dev \
    mercurial \
    virtualenv \
    reprepro \
    ruby1.9.1 && rm -rf /var/lib/apt/lists/*

# change working directory to /
WORKDIR /

# set the PYTHONPATH required for using the repository
ENV PYTHONPATH /workspace/cough-against-covid

# set actual working directory
WORKDIR /workspace/cough-against-covid

# copy the requirements file to the working directory
COPY requirements.txt .

# Install the required packages
RUN pip --no-cache-dir install -U pip
RUN pip install torch==1.6.0+cpu torchvision==0.7.0+cpu torchaudio==0.6.0 torchsummary==1.5.1 \
    -f https://download.pytorch.org/whl torch_stable.html
RUN pip install kornia==0.4.0 wandb==0.9.1 siren-torch==1.1 xgboost==1.1.1
RUN pip install termcolor natsort matplotlib seaborn
RUN pip install noisereduce==1.1.0
RUN pip install git+https://github.com/detly/gammatone.git