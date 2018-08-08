#!/bin/sh

if [ $# -ne 1 ]
then
    echo "Usage: $(basename $0) <VOCdevkit-folder>" >&2
    exit 2
fi
VOC_DEV=$1

set -e

# Construct layout:
#  ├── "dataset_name"                   
#  |   ├── train
#  |   ├── train_labels
#  |   ├── val
#  |   ├── val_labels
#  |   ├── test
#  |   ├── test_labels

mkdir VOC2012
mkdir VOC2012/train
mkdir VOC2012/train_labels
mkdir VOC2012/val
mkdir VOC2012/val_labels
mkdir VOC2012/test
mkdir VOC2012/test_labels

SEGMENTATION_SET=$VOC_DEV/VOC2012/ImageSets/Segmentation
JPEGS=$VOC_DEV/VOC2012/JPEGImages
SEGCLASS=$VOC_DEV/VOC2012/SegmentationClass

# The map of classes to colour
cat > VOC2012/class_dict.csv << EOF
name,r,g,b
Aeroplane,64,128,64
Bicycle,192,0,128
Bird,0,128, 192
Boat,0, 128, 64
Bottle,128, 0, 0
Bus,64, 0, 128
Car,64, 0, 192
Cat,192, 128, 64
Chair,192, 192, 128
Cow,64, 64, 128
Diningtable,128, 0, 192
Dog,192, 0, 64
Horse,128, 128, 64
Motorbike,192, 0, 192
Person,128, 64, 64
Pottedplant,64, 192, 128
Sheep,64, 64, 0
Sofa,128, 64, 128
Train,128, 128, 192
Tvmonitor,0, 0, 192
Void,0, 0, 0
EOF

# Copy training files
for f in $(cat $SEGMENTATION_SET/train.txt)
do
    cp $JPEGS/${f}.jpg VOC2012/train
    cp $SEGCLASS/${f}.png VOC2012/train_labels
done

# Copy validation files
for f in $(cat $SEGMENTATION_SET/trainval.txt)
do
    cp $JPEGS/${f}.jpg VOC2012/val
    cp $SEGCLASS/${f}.png VOC2012/val_labels
done

# Copy training files
for f in $(cat $SEGMENTATION_SET/val.txt)
do
    cp $JPEGS/${f}.jpg VOC2012/test
    cp $SEGCLASS/${f}.png VOC2012/test_labels
done

