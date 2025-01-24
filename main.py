import tensorflow as tf
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.preprocessing import image
from tensorflow.keras.applications.mobilenet_v2 import preprocess_input, decode_predictions
import numpy as np
from PIL import Image

model = MobileNetV2(weights='imagenet')

def preprocess_image(img_path):
    img = Image.open(img_path).resize((224, 224)) 
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0) 
    return preprocess_input(img_array) 

uploaded_image_path = "path_to_your_image.jpg"
img_array = preprocess_image(uploaded_image_path)


predictions = model.predict(img_array)
decoded_predictions = decode_predictions(predictions, top=5)[0]


color, material, fit = None, None, None
for label, name, prob in decoded_predictions:
    print(f"{name}: {prob:.2f}")
    if "red" in name or "blue" in name or "yellow" in name:  
        color = name
    if "denim" in name or "silk" in name:  
        material = name
    if "tight" in name or "loose" in name: 
        fit = name

print(f"Color: {color}, Material: {material}, Fit: {fit}")
