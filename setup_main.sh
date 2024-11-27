#!/bin/bash
# setup_main.sh - Main setup script without extraction

echo "BEVFusion Main Setup Script"
echo "=========================="

# Initial setup and dependencies
cd /
git clone https://github.com/mdessl/mmdet3d.git -b dev-1.x

# Create data directories
mkdir -p /mmdet3d/data
mkdir -p /mmdet3d/data/nuscenes

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
pip install cumm-cu120 # eg cumm-cu120 if cuda is 12.0
pip install spconv-cu120
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

# Download extraction scripts and make them executable
cd /mmdet3d
wget -q https://raw.githubusercontent.com/mdessl/bevfusion-setup/main/extract_mini.sh
wget -q https://raw.githubusercontent.com/mdessl/bevfusion-setup/main/extract_full.sh
chmod +x extract_mini.sh extract_full.sh

echo "Main setup completed!"
echo "To extract datasets later:"
echo "- For mini dataset: cd /mmdet3d && ./extract_mini.sh"
echo "- For full dataset: cd /mmdet3d && ./extract_full.sh"
