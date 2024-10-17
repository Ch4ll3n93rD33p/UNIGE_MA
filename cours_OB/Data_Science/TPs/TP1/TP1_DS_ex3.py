# Lea Heiniger
# Data science
#09.10.2023

# TP1
import numpy as np
import matplotlib.pyplot as plt


def largest_values(a, n):
    '''Function that gets the n largest values of an array''' 
    L = a.size
    sortedArray = np.argsort(a)
    values = sortedArray[L-n:]
    reversedVal = values[::-1]

    return reversedVal


# we start by loading the data
artificialdata1 = np.load("data_tp1/tp1_artificialdata1/data.npy")
artificialdata2 = np.load("data_tp1/tp1_artificialdata1/data.npy")
artificialdata3 = np.load("data_tp1/tp1_artificialdata1/data.npy")
artificialdata4 = np.load("data_tp1/tp1_artificialdata1/data.npy")
digit_data2 = np.load("data_tp1/tp1_digit2/data.npy")
frey_faces_data = np.load("data_tp1/tp1_freyfaces/data.npy")

''' Covariance matrix'''
covMatrixAD1 = np.cov(artificialdata1)
covMatrixAD2 = np.cov(artificialdata2)
covMatrixAD3 = np.cov(artificialdata3)
covMatrixAD4 = np.cov(artificialdata4)
covMatrixDD2 = np.cov(digit_data2)
covMatrixFFD = np.cov(frey_faces_data)

''' Eigenvlues of covariance matrix'''
eigValuesCovAD1 = np.linalg.eig(covMatrixAD1)[0]
eigValuesCovAD2 = np.linalg.eig(covMatrixAD2)[0]
eigValuesCovAD3 = np.linalg.eig(covMatrixAD3)[0]
eigValuesCovAD4 = np.linalg.eig(covMatrixAD4)[0]
eigValuesCovDD2 = np.linalg.eig(covMatrixDD2)[0]
eigValuesCovFFD = np.linalg.eig(covMatrixFFD)[0]

''' Determinant of covariance matrix'''
detCovAD1 = np.linalg.det(covMatrixAD1)
detCovAD2 = np.linalg.det(covMatrixAD2)
detCovAD3 = np.linalg.det(covMatrixAD3)
detCovAD4 = np.linalg.det(covMatrixAD4)
detCovDD2 = np.linalg.det(covMatrixDD2)
detCovFFD = np.linalg.det(covMatrixFFD)

''' Product of the eigenvlues'''
productEigValuesCovAD1 = np.prod(eigValuesCovAD1)
productEigValuesCovAD2 = np.prod(eigValuesCovAD2)
productEigValuesCovAD3 = np.prod(eigValuesCovAD3)
productEigValuesCovAD4 = np.prod(eigValuesCovAD4)
productEigValuesCovDD2 = np.prod(eigValuesCovDD2)
productEigValuesCovFFD = np.prod(eigValuesCovFFD)

'''Plot of the the eigenspectrums'''
#we start by