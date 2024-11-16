#Multimedia Security and Privacy  
#Lea Heiniger  
#25.03.2022  
  
# TP1: Basic Image Processing 

import numpy as np
import cv2
import skimage
import matplotlib.pyplot as plt
from skimage.measure import block_reduce


def displayImg(images, labels, rows, cols, cmap = None) :
    ''' function that allows us to display one or more images '''

    axes = []
    fig = plt.figure()

    for i in range(rows * cols) :
        axes.append(fig.add_subplot(rows, cols, i + 1))
        plt.imshow(images[i], cmap)
        plt.title(labels[i])
    fig.tight_layout()
    plt.show()

def displayHisto(histograms, tabs, labels, rows, cols) :
    ''' function that allows us to display one or more histogram '''

    _, axs = plt.subplots(rows, cols, figsize=(20,5))

    for i in range(rows * cols) :
        axs[i].plot(histograms[i], tabs[i])
        axs[i].set_title(labels[i])
    plt.show()

def gaussianNoise(N, M , mu, sigma) :
    ''' function that generate a N by M array of Gaussian noise with parameters mu and sigma '''

    return np.asarray([[np.random.normal(mu, sigma) for i in range(M)] for j in range(N)])

def saltPepperNoise(X, p, q) :
    ''' function that generate salt and pepper noise with parameters p and q on an image X '''     

    if (p+q >= 1) :
        raise ValueError("p+q must be smaller than 1")
    
    s_min = np.min(X)
    s_max = np.max(X)
    N, M = X.shape

    Y = np.copy(X)

    for i in range(N) :
        for j in range(M) :
            
            r = np.random.rand()

            if r <= p :
                Y[i][j] = s_min

            elif r <= p+q :
                Y[i][j] = s_max   

    return Y

def MSE(X, Y) :
    ''' function that computes the Mean Squared Error between X and Y '''
    if X.shape != Y.shape :
        return 0 
    else:
        return np.sum([np.sum([(X[i, j]- Y[i, j])**2 for j in range(X.shape[1])]) for i in range(X.shape[0])]) / (X.shape[0]*X.shape[1])

def PSNR(X, Y) :
    ''' function that computes the Peak Signal to Noise Ratio between X and Y '''

    mse = MSE(X,Y)
    if mse == 0:
        return 0
    else:
        return 10 * np.log10(255**2/mse)