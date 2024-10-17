# Metaheuristics for optimization TP3
# 31.10.2022  
# Lea Heiniger

import sys
import numpy as np
import math
import random
from copy import copy
import matplotlib.pyplot as plt
from time import time


################ Traveling Salesman Problem ################

def extract_cities(file) :
    '''
    Function that exports the data from a .dat file

    Parameter(s) :
     file -> file name

    Returning :
     cities -> a list containing the various cities (as a list containing name, x coordinate and y coordinate)
    '''
    data = np.genfromtxt(file, dtype=None, encoding=None, comments='#', delimiter=None)
    cities = []
    for d in data :
        c =[d[0], d[1], d[2]]
        cities.append(c)

    return cities

def random_TSP(N) :
    '''
    Function that creates a random TSP problem

    Parameter(s) :
     N -> number of cities

    Returning :
     cities -> a list of n cities randomly placed in a 150 by 150 square
    '''
    cities = [["c"+str(i), math.floor(random.random()*150), math.floor(random.random()*150)] for i in range(N)]

    return cities

################ Greedy Algorithm ################

def distance(city1, city2) :
    '''
    Function that computes the distance between two cities

    Parameter(s) :
     city1 -> a city as a list
     city2 -> a city as a list

    Returning :
     d -> the distance between the two cities
    '''
    d = math.sqrt((city2[1]-city1[1])**2 +(city2[2]-city1[2])**2)

    return d

def closest(city, cities) :
    '''
    Function that finds the closest city from a chosen city

    Parameter(s) :
     city -> a city
     cities -> a list of other cities

    Returning :
     closestCity -> the closest city (in cities) from "city"
     the index of closestCityin the list "cities"
    '''
    distances = [distance(city, c) for c in cities]
    dist = min(distances)
    closestCity = cities[distances.index(dist)]

    return closestCity, distances.index(dist)

def greedy(cities) :
    '''
    Greed algorithm for TSP

    Parameter(s) :
     cities -> a list of cities

    Returning :
     path -> the best path acording to the greedy alogrithm (list of cities)
    '''
    c = copy(cities)
    start = c.pop(0)
    path = [start]

    city = start
    while len(c)>0 :
        closestCity, index = closest(city, c) # at each step we chose the closest city
        city = closestCity
        path.append(c.pop(index))

    path.append(start)

    return path

################ Simulated Annealing ################

def random_path(cities) : 
    '''
    Function that creates a random path form a list of cities

    Parameter(s) :
     cities -> a list of cities

    Returning :
     state -> a random path between the cities
    '''
    state = copy(cities)
    first = state.pop(0)
    random.shuffle(state)
    state.insert(0, first) 
    state.append(first)

    return state

def permutations(state) :
    '''
    Function that computes the possible permutations (keeping first and last cities the same)

    Parameter(s) :
     state -> a path between the cities (as a list of cities)

    Returning :
     permuts -> a list of permutations as tuple of two index
    '''
    permuts = []

    for i in range(len(state)-2) :
        for j in range(i+1, len(state)-2) :
            permuts.append((i+1,j+1))

    return permuts

def transition(state, permut) :
    '''
    Function that computes the neighbor of a path using applying a specific permutation

    Parameter(s) :
     state -> a path between the cities (as a list of cities)

    Returning :
     neighbor -> the new path obtained after applying the permutation
    '''
    neighbor = copy(state)
    neighbor[permut[0]], neighbor[permut[1]] = neighbor[permut[1]], neighbor[permut[0]]

    return neighbor

def energy(state) :
    '''
    Function that computes the energy of a state

    Parameter(s) :
     state -> a path between the cities (as a list of cities)

    Returning :
     E -> the energy of the path
    '''
    E = 0

    for i in range(len(state)-1) :
        E += distance(state[i], state[i+1])

    return E

def init_temperature(initState) :
    '''
    Function that computes the initial temperature 
    
    Parameter(s) :
     initState -> a path between the cities (as a list of cities)

    Returning :
     T0 -> the initial temperature of this state
    '''
    E = energy(initState)
    permuts = permutations(initState)

    while len(permuts)>100 : # we remove randomely permutations to have 100 permuts. or less
        permuts.pop(math.floor(random.random()*len(permuts)))

    neighbors = [transition(initState, p) for p in permuts]
    neighborsE = [energy(s) for s in neighbors]
    avEnergyChange = 0

    for EX in neighborsE :
        avEnergyChange += np.abs(E-EX)

    T0 = -((avEnergyChange / len(neighborsE)) / np.log(0.5))

    return T0

def equilibrium(n, accept, iter) :
    '''
    Function that check if equilibrium is achived

    Parameter(s) :
     n -> the number of cities
     accept -> the number of accepted perturbations
     iter -> the number of atempted perturbations

    Returning :
     eq -> a boolean True if we have equilibrium False otherwize
    '''
    eq = False

    if accept>=12*n or iter>=100*n :
        eq = True

    return eq

def frozen(tempSteps) :
    '''
    Function that check if the system is frozen

    Parameter(s) :
     tempSteps -> a list of the temperature change at each steps

    Returning :
     F -> boolean True if the system is frozen False otherwize
    '''
    F = False

    if len(tempSteps)>2 :
        F = (tempSteps[-3]==tempSteps[-2]==tempSteps[-1])

    return F

def simulate_annealing(cities) :
    '''
    simulate annealing algorithm for TSP

    Parameter(s) :
     cities -> a list of cities

    Returning :
     state -> the best path (list of cities)
    '''
    
    # 1. We start by generating a random path
    state = random_path(cities)
    E = energy(state)
    # 2. We compute the initial temperature
    temperature = init_temperature(state)
    tempSteps = []

    # 7. We check if the system is frozen
    while not frozen(tempSteps) : 
        accept = 0
        iter = 0

        # 5. We check if equilibrium is achieved
        while not equilibrium(len(cities), accept, iter) : 
            
            # 3. We randomly update the state
            permuts = permutations(state)
            permut = permuts[math.floor(random.random()*len(permuts))]
            neighbor = transition(state, permut)
            neighborE = energy(neighbor)
        
            # 4. We keep the update with a probability P
            deltaE = neighborE-E
            P = np.min([np.exp(-deltaE/temperature), 1])
            if math.floor(random.random() +P)==1 : 
                state = neighbor
                E = neighborE
                accept += 1

            # 6. We reduce the temperature
            tempSteps.append(E)
            temperature *= 0.9
            iter += 1

        return state

################ Visualization ################

def display(cities, pathG, pathSA) :
    '''
    Function that display the greedy and SA paths on a plot

    Parameter(s) :
     cities -> a list of cities
     pathG -> a path obtained with the greedy algorithm
     pathSA -> a path obtained with the SA algorith
    '''
    
    fig = plt.figure()
    ax = fig.add_subplot(111)

    for c in cities :
        ax.plot(c[1], c[2], 'ro')
        ax.annotate(c[0], (c[1]+0.005, c[2]+0.005))

    x1 = []
    y1 = []

    for c in pathG :
        x1.append(c[1])
        y1.append(c[2])

    x2 = []
    y2 = []

    for c in pathSA :
       x2.append(c[1])
       y2.append(c[2])

    ax.plot(x1, y1, label="Greedy path")
    ax.plot(x2, y2, label="SA path")
    ax.legend()
    plt.show()

def display_TSP(cities, title) :
    '''
    Function that display the cities of a given TSP

    Parameter(s) :
     cities -> a list of cities
     title -> the title of the plot
    '''
    
    fig = plt.figure()
    ax = fig.add_subplot(111)

    for c in cities :
        ax.plot(c[1], c[2], 'ro')
        ax.annotate(c[0], (c[1]+0.05, c[2]+0.05))

    plt.title(title)
    plt.show()

def box_display(data, colNames, title) :
    '''
    Function that displays a boxplot of given data

    Parameter(s) :
     data -> a list of lists of data per columns
     colNames -> a list with the names of the columns
     title -> the title of the plot
    '''

    fig, ax = plt.subplots()
    ax.boxplot(data)
    plt.xticks([i+1 for i in range(len(data))], colNames, rotation=0)
    plt.title(title)

    plt.show()