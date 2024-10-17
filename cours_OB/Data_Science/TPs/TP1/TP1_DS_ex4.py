# Lea Heiniger
# Data science
#09.10.2023

# TP1


import numpy as np

# P1 and P2 are two distinct points of the line 3x-4y=-6
P1 = np.array([2,3])
P2 = np.array([-2,0])

A = np.array([-1,3])


distP1P2 = np.sum((P1-P2)**2)


t = np.sum((A - P1) * (P2 - P1)) / distP1P2

projA = P1 + t * (P2 - P1) # projection of A on the line

# distance between A and the line
distFromLine = np.linalg.norm(np.cross(P2-P1, P1-A))/np.linalg.norm(P2-P1) 

print("projection of A on the line :", projA)
print("distance between A and the line :", distFromLine)
