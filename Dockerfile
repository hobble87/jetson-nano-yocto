# Use the official Ubuntu 20.04 image
FROM ubuntu:20.04

# Set the maintainer label
LABEL maintainer="Chris Hovell"

# Set environment variable to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    diffstat \
    unzip \
    texinfo \
    gawk \
    chrpath \
    wget \
    nano \
    cpio \
    zstd \
    python3 \
    python3-pip \
    python3-pexpect \
    xz-utils \
    debianutils \
    iputils-ping \
    lz4 \
    sudo \
    locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a non-root user to run Yocto builds
RUN useradd -ms /bin/bash yoctouser

# Create the workspace directory
RUN mkdir -p /workspace/build

# Copy your local configuration files into the container
COPY local.conf /workspace/build/conf/local.conf
COPY bblayers.conf /workspace/build/conf/bblayers.conf

# Add a script to copy the deploy directory after build
COPY copy_deploy.sh /usr/local/bin/copy_deploy.sh
RUN chmod +x /usr/local/bin/copy_deploy.sh

# Copy the shell script that will run the bitbake and handle the deploy
COPY run_bitbake.sh /usr/local/bin/run_bitbake.sh
RUN chmod +x /usr/local/bin/run_bitbake.sh

# Change ownership of the workspace directory
RUN chown -R yoctouser:yoctouser /workspace

# Set working directory
WORKDIR /workspace

# Clone the necessary repositories
RUN git clone -b kirkstone git://git.yoctoproject.org/poky.git && \
    git clone -b kirkstone-l4t-r32.7.x https://github.com/OE4T/meta-tegra.git && \
    git clone -b kirkstone https://git.openembedded.org/openembedded-core 


# Switch to the non-root user
USER yoctouser

# Set the working directory
WORKDIR /workspace/build

# Set CMD to run the shell script
CMD ["/usr/local/bin/run_bitbake.sh"]
