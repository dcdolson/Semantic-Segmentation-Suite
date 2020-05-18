#!/usr/bin/env python3

# inspiration from train.py

import os
#import tensorflow.python.util.deprecation as deprecation
#deprecation._PRINT_DEPRECATION_WARNINGS = False
import tensorflow as tf
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
from models.RefineNet import build_refinenet
from utils import helpers

NUM_CLASSES=32

## writes to 'models' dir
subprocess.run(['python3', 'utils/get_pretrained_checkpoints.py', '--model', 'ResNet50'], check=True)
pretrained_dir = 'models'

# Save dir
checkpoint_dir = "checkpoints"
if os.path.exists(checkpoint_dir):
    print("Requested output folder '%s' exists." % checkpoint_dir, file=sys.stderr)
    sys.exit(1)
os.makedirs(checkpoint_dir)

net_input = tf.placeholder(tf.float32,shape=[None,None,None,3], name='ph_input')
labels = tf.placeholder(tf.float32,shape=[None,None,None,NUM_CLASSES], name='ph_label')
print("Image input tensor name:", net_input.name)
print("Label input tensor name:", labels.name)

net_out, init = build_refinenet(net_input, NUM_CLASSES, frontend="ResNet50", pretrained_dir=pretrained_dir)

print("Network output tensor is:", net_out.name)

loss = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits=net_out, labels=labels))
print("Network loss tensor is:", loss.name)

checkpoint_file = "RefineNet-%d-classes.ckpt" % NUM_CLASSES
model_checkpoint_name = os.path.join(checkpoint_dir, checkpoint_file)

# Create session
with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())

    if init is not None:
        init(sess)

    # save it all
    saver=tf.train.Saver(max_to_keep=1)
    saver.save(sess,model_checkpoint_name)

print("Checkpoint directory:", checkpoint_dir)
print("meta-file name:", os.path.join(checkpoint_dir, checkpoint_file+".meta"))
