FROM       ubuntu:18.04
MAINTAINER Hyungjoon Koo (kevin.koo@skku.edu)

RUN apt-get -y update && apt-get install -y \
    git \
    texinfo \
    byacc \
    flex \
    bison \
    automake \
    autoconf \
    build-essential \
    libtool \
    cmake \
    gawk \
    python3 \
    python3-dev \
    wget \
    elfutils \
    sudo \
    python3-pip \
    gdb \
    vim

RUN useradd -m hw1
RUN echo "hw1:swe3025hw!" | chpasswd
RUN usermod -aG sudo hw1
USER hw1

RUN cd ~
RUN pip3 install pyelftools gdown
RUN git clone https://github.com/longld/peda.git ~/peda
RUN echo "source ~/peda/peda.py" >> ~/.gdbinit
RUN echo "[SWE3025] Your docker image is ready!"

