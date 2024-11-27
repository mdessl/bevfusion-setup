#!/bin/bash
# setup_bevfusion_full.sh - Script for full dataset setup

setup_common() {
    # Initial setup and dependencies
    cd /
    git clone https://github.com/mdessl/mmdet3d.git -b dev-1.x
    
    # Install Python dependencies
    pip install -U openmim
    mim install mmengine
    mim install 'mmcv>=2.0.0rc4'
    mim install 'mmdet>=3.0.0'
    
    # Install mmdet3d
    cd mmdet3d
    pip install -v -e .
    python projects/BEVFusion/setup.py develop
    
    # System dependencies
    sudo apt-get update
    sudo apt-get install -y ffmpeg libsm6 libxext6 pigz zip unzip
    
    # Detect CUDA version and install appropriate packages
    CUDA_VERSION=$(nvcc --version | grep "release" | awk '{print $6}' | cut -c1-4 | sed 's/\.//')
    pip install cumm-cu${CUDA_VERSION}
    pip install spconv-cu${CUDA_VERSION}
    
    # Configure tmux scroll
    echo "set -g mouse on" > ~/.tmux.conf
    tmux source-file ~/.tmux.conf
    
    # Git configuration
    git config --global user.email "markus.essl1@gmail.com"
    git config --global user.name "maress"
    
    # Download model weights
    cd /mmdet3d
    wget https://download.openmmlab.com/mmdetection3d/v1.1.0_models/bevfusion/swint-nuimages-pretrained.pth
    wget https://download.openmmlab.com/mmdetection3d/v1.1.0_models/bevfusion/bevfusion_lidar_voxel0075_second_secfpn_8xb4-cyclic-20e_nus-3d-2628f933.pth
    wget https://download.openmmlab.com/mmdetection3d/v1.1.0_models/bevfusion/bevfusion_lidar-cam_voxel0075_second_secfpn_8xb4-cyclic-20e_nus-3d-5239b1af.pth
}

setup_full() {
    # Setup for full dataset
    cd /mmdet3d/data/nuscenes
    
    # Extract all zip and tar files
    echo "Extracting zip files..."
    for file in *.zip; do
        unzip "$file" && rm "$file"
    done
    
    echo "Extracting tar files..."
    for file in *.tar; do
        tar --use-compress-program=pigz --blocking-factor=512 -xvf "$file" && rm "$file"
    done
    
    # Move map files
    mv expansion basemap prediction maps/ 2>/dev/null || true
    
    # Download and setup info files
    rm -f nuscenes_infos_train.pkl nuscenes_infos_val.pkl
    wget https://download.openmmlab.com/mmdetection3d/data/nuscenes/nuscenes_infos_train.pkl
    wget https://download.openmmlab.com/mmdetection3d/data/nuscenes/nuscenes_infos_val.pkl
}

# Run setup
setup_common
setup_full

echo "Full dataset setup completed!"
