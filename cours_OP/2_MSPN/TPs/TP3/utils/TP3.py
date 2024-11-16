# Modelisation et simulation de phenomenes naturels
# TP3
# Lea Heiniger

from utils import *
from matplotlib import pyplot as plt
from matplotlib import image as mpimg

# Learn 4 patterns

img1 = BinaryImage()
img2 = BinaryImage()
img3 = BinaryImage()
img4 = BinaryImage()

img1.read("images/bird.gif")
img2.read("images/crab.gif")
img3.read("images/fish.gif")
img4.read("images/myth.gif")

m, n = img1.dimensions

N = m*n #dimentions of images

W = np.zeros((N,N))

val1 = img1.values.flatten()
val2 = img2.values.flatten()
val3 = img3.values.flatten()
val4 = img4.values.flatten()

for i in range(N) :
    for j in range(N) :
        
        W[i][j] = (1/N)*(val1[i]*val1[j]+val2[i]*val2[j]+val3[i]*val3[j]+val4[i]*val4[j])
    
# Roughen images

imName = "crab"

img = BinaryImage()

img.read("images/"+imName+".gif")


img.addNoise(0.1)
img.write("noise.gif")

# display the image
plt.title("Roughen "+imName+" image")
image = mpimg.imread("noise.gif")
plt.imshow(image)
plt.show()


# Reconstruct the image

img.read("noise.gif")
iterations = 1000
val = img.values.flatten()

for it in range(iterations) :
    for i in range(N) :
        sumS = 0
        for j in range(N) : 
            sumS = W[i][j]*val[j]
        
        if (1/N)*sumS<0 :
            val[i] = -1
        else :
            val[i] = 1

img.values = np.reshape(val,(m,n))

img.write("restored.gif")

plt.title("image restored")
image = mpimg.imread("restored.gif")
plt.imshow(image)
plt.show()