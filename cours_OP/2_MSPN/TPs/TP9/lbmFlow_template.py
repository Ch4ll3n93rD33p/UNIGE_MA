#!/usr/bin/python3
# Copyright (C) 2015 Universite de Geneve, Switzerland
# E-mail contact: jonas.latt@unige.ch

#modifications : Lea Heiniger

from numpy import *
import matplotlib.pyplot as plt
from matplotlib import cm

###### Flow definition #########################################################
maxIter = 2000 # Total number of time iterations.
Re = 10.0 # Reynolds number. 10
nx, ny = 51, 51 # Number of lattice nodes. 51, 51
uLB = 0.05 # Velocity in lattice units. 0.05
nulb = uLB*ny/Re # Viscoscity in lattice units.
omega = 1/(3*nulb+0.5) # Relaxation parameter.
omega_p = 0.2 # frequency pulse 0.2

###### Lattice Constants #######################################################
# TODO complete the lattice velocities here, for a D2Q9 system
v = array([[1, 1], [1, 0], [1, -1], [0, 1], [0, 0], [0, -1], [-1, 1], [-1, 0], [-1, -1]])
t = array([1/36, 1/9, 1/36, 1/9, 4/9, 1/9, 1/36, 1/9, 1/36])

col1 = array([0, 1, 2])
col2 = array([3, 4, 5])
col3 = array([6, 7, 8])
lin1 = array([2, 5, 8])
lin2 = array([1, 4, 7])
lin3 = array([0, 3, 6])

###### Function Definitions ####################################################
def macroscopic(fin):
    # TODO complete computation of macroscopic density, pressure and velocity here
    rho = sum(fin, axis=0)
    cs_sqr = 1/3*1/1
    P = cs_sqr*rho
    u = zeros((2, nx, ny))
    for i in range(9):
        u[0,:,:] += v[i,0] * fin[i,:,:]
        u[1,:,:] += v[i,1] * fin[i,:,:]
    u /= rho

    return rho, P, u

def equilibrium(rho, u):              # Equilibrium distribution function.
    usqr = 3/2 * (u[0]**2 + u[1]**2)
    feq = zeros((9,nx,ny))
    for i in range(9):
        cu = 3 * (v[i,0]*u[0,:,:] + v[i,1]*u[1,:,:])
        feq[i,:,:] = rho*t[i] * (1 + cu + 0.5*cu**2 - usqr)
    return feq

###### Setup: cylindrical obstacle and velocity inlet with perturbation ########

def perturbation(t):
    # TODO implement perturbationexit()
    return [uLB*cos(omega_p*t), uLB*sin(omega_p*t)]

# TODO Initialization of the populations at equilibrium with a null velocity, and density 1
fin = zeros((9, nx, ny))
fin[4,:,:] = 1

###### Main time loop ##########################################################

center = array([int(nx/2), int(ny/2)])
#center = array([int(nx/4),int(ny/4)]) # start diagonal trajectory

for time in range(maxIter):
    # TODO Walls: outflow condition.
    fin[col1,0,:] = fin[col1,1,:]
    fin[col3,-1,:] = fin[col3,-2,:]
    fin[lin1,:,0] = fin[lin1,:,1]
    fin[lin3,:,-1] = fin[lin3,:,-2]

    # Compute macroscopic variables, density and velocity.
    rho, P, u = macroscopic(fin)

    # Apply a rotating perturbation on the center velocity
    u[:,center[0],center[1]] = perturbation(time)

    #if time%80 == 0 : # diagonal trajectory
    #   center += 1

    #c1, c2 = where(P==amin(P)) # center moving due to pressure
    #center = array([c1[0], c2[0]]) 

    # Compute equilibrium.
    feq = equilibrium(rho, u)
    fin[[0,1,2],0,:] = feq[[0,1,2],0,:] + fin[[8,7,6],0,:] - feq[[8,7,6],0,:]

    # Collision step.
    fout = fin - omega * (fin - feq)

    # Streaming step.
    for i in range(9):
        fin[i,:,:] = roll(roll(fout[i,:,:], v[i,0], axis=0), v[i,1], axis=1)
 
    # Visualization of macroscopic quantities.
    if (time%100==0):
        print("Output at time t = "+str(time))
        plt.clf()
        # Output velocity. Give explicitly the colorbar range, to show negative values as well
        plt.imshow(sqrt(u[0]**2+u[1]**2).transpose(), cmap=cm.Reds, vmin=-uLB, vmax=uLB)
        plt.colorbar()
        plt.savefig("img/vel.{0:03d}.png".format(time//100))

        plt.clf()
        # Output pressure
        plt.imshow(P, cmap=cm.viridis)
        plt.colorbar()
        plt.savefig("img/P.{0:03d}.png".format(time//100))

