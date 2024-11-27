#!/bin/bash
# setup_bevfusion_mini.sh - Script for mini dataset setup

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
    sudo apt-get install -y ffmpeg libsm6 libxext6
    
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

setup_mini() {
    # Setup for mini dataset
    cd /mmdet3d/data
    
    # Extract mini dataset
    tar -xvf nuscenes.tar.gz
    
    # Download and setup info files
    cd /mmdet3d/data/nuscenes
    rm -f nuscenes_infos_train.pkl nuscenes_infos_val.pkl
    wget https://download.openmmlab.com/mmdetection3d/data/nuscenes/nuscenes_mini_infos_train.pkl -O nuscenes_infos_train.pkl
    wget https://download.openmmlab.com/mmdetection3d/data/nuscenes/nuscenes_mini_infos_val.pkl -O nuscenes_infos_val.pkl
}

# Run setup
setup_common
setup_mini

echo "Mini dataset setup completed!"
