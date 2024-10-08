#!/bin/bash

# Define the source and destination directories
DEPLOY_DIR="/workspace/build/tmp/deploy/images"
DEST_DIR="/output"

# Check if the destination directory exists and copy the deploy folder
if [ -d "$DEPLOY_DIR" ]; then
    echo "Copying deploy directory to $DEST_DIR"
    cp -r $DEPLOY_DIR $DEST_DIR
    echo "Deploy directory successfully copied."
else
    echo "Deploy directory not found. Build might have failed."
fi