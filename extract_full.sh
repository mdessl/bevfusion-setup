#!/bin/bash
# extract_full.sh - Full dataset extraction script

echo "BEVFusion Full Dataset Extraction"
echo "================================"

cd /mmdet3d/data/nuscenes

# Extract all zip and tar files
echo "Extracting zip files..."
for file in *.zip; do
    if [ -f "$file" ]; then
        echo "Extracting $file..."
        unzip "$file" && rm "$file"
    fi
done

echo "Extracting tar files..."
for file in *.tar; do
    if [ -f "$file" ]; then
        echo "Extracting $file..."
        tar --use-compress-program=pigz --blocking-factor=512 -xvf "$file" && rm "$file"
    fi
done

# Move map files
mv expansion basemap prediction maps/ 2>/dev/null || true

# Download and setup info files
rm -f nuscenes_infos_train.pkl nuscenes_infos_val.pkl
wget https://download.openmmlab.com/mmdetection3d/data/nuscenes/nuscenes_infos_train.pkl
wget https://download.openmmlab.com/mmdetection3d/data/nuscenes/nuscenes_infos_val.pkl

echo "Full dataset extraction completed!"