# Import the library
from utils import *

# Create a new image instance
img = BinaryImage()

# Read the binary image bird.gif
img.read("images/bird.gif")

# Print the image dimensions
print('Dimensions:')
print(img.dimensions)

# Print the image values
print('Values:')
for i in range(img.dimensions[0]):
    row = ''
    for j in range(img.dimensions[1]):
        if img.values[(j,i)] == 1:
            row += ' '
        
        row += str(img.values[(j,i)])
    print(row)

# Add 10% noise to the image
img.addNoise(0.1)

# Write the image into noise.gif
img.write("noise.gif")
