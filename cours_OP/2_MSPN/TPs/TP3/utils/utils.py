import os
import sys

import numpy as np
from PIL import Image
from random import *


# Class handling IO operation on binary images
class BinaryImage:
    dimensions = None
    values = None
    
    # Read the binary image and store its content in a numpy matrix
    def read(self, fileName):
        pil_image = Image.open(fileName)
        pixels = pil_image.load()

        self.dimensions = pil_image.size
        self.values = np.zeros(self.dimensions, dtype=int) 

        # Set the values of black pixels to -1 and white pixels to 1 
        for i in range(self.dimensions[0]):
            for j in range(self.dimensions[1]):
                if pixels[(i,j)] == 0:
                    self.values[i,j] = -1
                else:
                    self.values[i,j] = int(pixels[(i,j)])

    # Write the numpy matrix into a binary image
    def write(self, fileName):
        pil_image = Image.new("1", self.dimensions)
        pixels = pil_image.load()

        for i in range(self.dimensions[0]):
            for j in range(self.dimensions[1]):
                if self.values[i,j] == -1:
                    pixels[(i,j)] = 0
                else:
                    pixels[(i,j)] = int(self.values[i,j])
                    
        pil_image.save(fileName)
        
    # Add noise to the numpy matrix
    def addNoise(self, noise):
        for i in range(self.dimensions[0]):
            for j in range(self.dimensions[1]):
                if random() <= noise:
                    self.values[(i,j)] *= -1
