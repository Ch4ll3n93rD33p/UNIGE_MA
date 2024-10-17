# Lea Heiniger
# Data science
# TP1

import numpy as np

# P1 and P2 are two distincts points of the line 3x-2y=-6
P1 = np.array([0,3])
P2 = np.array([2,6])

A = np.array([5,4])


distP1P2 = np.sum((P1-P2)**2)


t = np.sum((A - P1) * (P2 - P1)) / distP1P2

projA = P1 + t * (P2 - P1) # projection of A on the line

# distance between A and the line
distFromLine = np.linalg.norm(np.cross(P2-P1, P1-A))/np.linalg.norm(P2-P1) 


