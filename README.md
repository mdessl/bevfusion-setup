# BEVFusion Setup Scripts

Automated setup scripts for BEVFusion with both mini and full nuScenes dataset support.

## Usage

### For Mini Dataset
```bash
wget https://raw.githubusercontent.com/maress/bevfusion-setup/main/setup_bevfusion_mini.sh
chmod +x setup_bevfusion_mini.sh
./setup_bevfusion_mini.sh
```

### For Full Dataset
```bash
wget https://raw.githubusercontent.com/maress/bevfusion-setup/main/setup_bevfusion_full.sh
chmod +x setup_bevfusion_full.sh
./setup_bevfusion_full.sh
```

## Prerequisites

- CUDA-capable GPU
- Sufficient disk space
- sudo privileges
- Dataset files in the correct location:
  - Mini: `nuscenes.tar.gz` in `/mmdet3d/data/`
  - Full: nuScenes dataset files in `/mmdet3d/data/nuscenes/`

## Note
These scripts will automatically:
1. Set up the BEVFusion repository
2. Install all required dependencies
3. Configure CUDA packages based on your system
4. Download and set up model weights
5. Process and organize the dataset
