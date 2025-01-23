import tensorflow as tf

# Check TensorFlow version
print("TensorFlow version:", tf.__version__)

# Simple computation
a = tf.constant(2)
b = tf.constant(3)
c = a + b
print("Result:", c)