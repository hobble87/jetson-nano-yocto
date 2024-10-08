#!/bin/bash
cd /workspace
source poky/oe-init-build-env
bitbake core-image-base
/usr/local/bin/copy_deploy.sh