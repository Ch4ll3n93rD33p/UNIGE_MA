# Lea Heiniger
# Data science
# 30.10.2023

# TP3

from sklearn.datasets import fetch_openml
from sklearn.model_selection import train_test_split
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA

##### functions #####

def select_with_label(images, labels, desired_labels):
    # function provided in the tp instructions
    mask = np.isin(labels, desired_labels)
    return images[mask], labels[mask]

def pca(X) :
    # function computing the PCA of data X
    p = PCA()
    p.fit(X)
    mean = p.mean_
    components = p.components_
    eigenval = p.singular_values_
    var = np.cumsum(np.round(p.explained_variance_ratio_,decimals=10)*100)
    
    return mean, components, eigenval, var

def revers_pca(images, components, mean, m) :
    # function that reconstruct images and computes error
    errors = []
    reconstructed_img = []
    p = (images-mean)@(components.T)

    for i in m :
        # reconstruction
        img = (p[:, :i])@(components[:i])+mean
        reconstructed_img.append(img)

        # error computation
        errors.append(np.mean(np.linalg.norm(images-reconstructed_img, axis=1)**2))

    return reconstructed_img, errors

def plot_img(images, labels, rows, cols):
    # function used to plot images
    axes = []
    fig = plt.figure()
    for i in range(rows * cols):
        axes.append(fig.add_subplot(rows, cols, i + 1))
        if i >= len(images):
            plt.bar(images[i][1], images[i][0])
        else:
            plt.imshow(images[i], cmap='gray')
        plt.title(labels[i])
    fig.tight_layout()
    plt.show()

def plotting(data, labels, rows, cols):
    # function used to plot non-image data
    axes = []
    fig = plt.figure()
    for i in range(rows * cols):
        axes.append(fig.add_subplot(rows, cols, i + 1))
        if i >= len(data):
            plt.bar(data[i][1], data[i][0])
        else:
            plt.plot(data[i])
        plt.title(labels[i])
    fig.tight_layout()
    plt.show()

##### main #####

# We load the images and select the ones labeled 2 using the function select_with_label
images, labels = fetch_openml('mnist_784', return_X_y=True, as_frame=False, parser='auto')
train_images, test_images, train_labels, test_labels = train_test_split(images, labels, random_state=42)
images_of_two, labels_of_two = select_with_label(train_images, train_labels, desired_labels=['2'])

# we sample 5000 images and compute PCA
X = np.asarray(images_of_two[0:5000]) 
mean, components, eigenval, var = pca(X) 
plot_img([mean.reshape(28, 28)], ["mean"], 1, 1)
plotting([eigenval, var], ["eigenvalues", "variance in function of the number of components"], 1, 2)

# we reconstruct the images and compute the error
m = range(785)
reconstructed_img, errors = revers_pca(X, components, mean, m)
print(len(errors))