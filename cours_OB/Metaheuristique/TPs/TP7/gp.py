# Metaheuristics for optimization TP7
# 02.01.2023  
# Lea Heiniger

import random
import math
import numpy as np
import matplotlib.pyplot as plt

# This is the machine on which programs are executed
# The output is the value on top of the pile. 
class CPU:
    def __init__(self):
        self.pile=[]
    def reset(self):
        while len(self.pile)>0:self.pile.pop()

# These are the instructions
def AND(cpu, data) :
    try :
        if len(cpu.pile) >= 2 :
            p1, p2 = cpu.pile.pop(), cpu.pile.pop()

            if p1 == 1 and p2 == 1 :
                cpu.pile.append(1)

            elif p1 in [0, 1] and p2 in [0, 1] :
                cpu.pile.append(0)
                
            else : 
                raise ValueError(p1, p2)  

        else :
            raise IndexError(cpu.pile)
    
    except ValueError :
        print("p1", p1)
        print("p2", p2)
        print("At least one of the elements is not 0 or 1")
        return -1
    
    except IndexError :
        print("the stack contains less than two elements")
        return -1


def OR(cpu, data) :
    try :
        if len(cpu.pile) >= 2 :
            p1, p2 = cpu.pile.pop(), cpu.pile.pop()

            if p1 == 1 or p2 == 1 :
                cpu.pile.append(1)

            elif p1 in [0, 1] and p2 in [0, 1] :
                cpu.pile.append(0)
            

            else : 
                raise ValueError(p1, p2)
            
        else :
            raise IndexError(cpu.pile)
    
    except ValueError :
        print("At least one of the elements is not 0 or 1")
        return -1
    
    except IndexError :
        print("the stack contains less than two elements")
        return -1


def XOR(cpu, data) :
    try :
        if len(cpu.pile) >= 2 :
            p1, p2 = cpu.pile.pop(), cpu.pile.pop()

            if (p1 == 1 and p2 == 0) or (p1 == 0 and p2 == 1) :
                cpu.pile.append(1)

            elif p1 in [0, 1] and p2 in [0, 1] :
                cpu.pile.append(0)
            
            else : 
                raise ValueError(p1, p2)

        else :
            raise IndexError(cpu.pile)
    
    except ValueError :
        print("At least one of the elements is not 0 or 1")
        return -1
    
    except IndexError :
        print("the stack contains less than two elements")
        return -1


def NOT(cpu, data) :
    try :
        if len(cpu.pile) >= 1 :
            p1 = cpu.pile.pop()

            if p1 == 1 :
                cpu.pile.append(0)
            
            elif p1 == 0 :
                cpu.pile.append(1)
            
            else : 
                raise ValueError(p1)
                
        else :
            raise IndexError(cpu.pile)
    
    except ValueError :
        print(p1, "not 0 or 1")
        return -1
    
    except IndexError :
        print("the stack contains less than one element")
        return -1
  
    
# Push values of variables on the stack.      
def X1(cpu, data) :
    x1 = data[0]
    cpu.pile.append(x1)


def X2(cpu, data) :
    x2 = data[1]
    cpu.pile.append(x2)


def X3(cpu, data) :
    x3 = data[2]
    cpu.pile.append(x3)

def X4(cpu, data) :
    x4 = data[3]
    cpu.pile.append(x4)


# Execute a program
def execute(program, cpu, data) : 
    try :
        for inst in program :

            if inst == "AND" : 
                status = AND(cpu, data)
        
            elif inst == "OR" : 
                status = OR(cpu, data)
        
            elif inst == "XOR" : 
                status = XOR(cpu, data)
        
            elif inst == "NOT" : 
                status = NOT(cpu, data)
        
            elif inst == "X1" : 
                status = X1(cpu, data)

            elif inst == "X2" : 
                status = X2(cpu, data)
        
            elif inst == "X3" : 
                status = X3(cpu, data)

            elif inst == "X4" : 
                status = X4(cpu, data)

            else : 
                raise ValueError(inst) 

            if status == -1 :
                return -1


        if len(cpu.pile) > 1 :
            raise Exception(cpu.pile)

        else :
            res = cpu.pile[0]
            return res


    except ValueError :
        print(inst, "is not a valid function")
        return -1
    
    except Exception :
        print("The stack contains more than one element at the end of the program")
        return -1


# Generate a random program
def random_prog(length, functionSet, terminalSet) :

    ############# TO BE IMPROVED
    program = []
    symb = functionSet+terminalSet
    for _ in range(length) :
        i = math.floor(random.random()*len(symb))
        program.append(symb[i])

    if execute(program, cpu, [0, 0, 0, 0]) != -1 :
        print(program)
        return program
    
    else :
        print(program)
        return random_prog(length, functionSet, terminalSet)
    
    


def gen_initial_population(popSize, progLength, functionSet, terminalSet) :

    return [random_prog(progLength, functionSet, terminalSet) for _ in range(popSize)]


# Computes the fitness of a program. 
# The fitness counts how many instances of data in dataSet are correctly computed by the program
def computeFitness(program, cpu, dataSet): 
    count = 0
    for data in dataSet :
        res = execute(program, cpu, dataSet)
        if res == data[-1] : 
            count += 1
    
    return count

    
# Selection using 2-tournament.
def selection(Population, cpu, dataSet) :
    listOfFitness = []
    for i in range(len(Population)) :
        prog = Population[i]
        f = computeFitness(prog, cpu, dataSet)
        listOfFitness.append((i, f))

    newPopulation = []
    n = len(Population)
    for i in range(n) :    
        i1 = random.randint(0, n-1)
        i2 = random.randint(0, n-1)
        if listOfFitness[i1][1] > listOfFitness[i2][1] :
            newPopulation.append(Population[i1])
        else :
            newPopulation.append(Population[i2])
    return newPopulation


def crossover(Population, p_c) :
    newPopulation = []
    n = len(Population)
    i = 0
    while(i < n) :
        p1 = Population[i]
        p2 = Population[(i+1)%n]
        m = len(p1)
        if random.random() < p_c :  # crossover
            k=random.randint(1,m-1)
            newP1 = p1[0:k]+p2[k:m]
            newP2 = p2[0:k]+p1[k:m]
            p1 = newP1
            p2 = newP2
        newPopulation.append(p1)
        newPopulation.append(p2)
        i += 2
    return newPopulation


def mutation(Population, p_m, terminalSet, functionSet) :
    newPopulation = []
    nT = len(terminalSet)-1
    nF = len(functionSet)-1
    for p in Population :
        for i in range(len(p)) :
            if random.random() > p_m : continue
            if random.random() < 0.5 : 
                p[i] = terminalSet[random.randint(0, nT)]
            else :
                p[i] = functionSet[random.randint(0, nF)]
        newPopulation.append(p)
    return newPopulation


def genetic_algorithm(gen, p_m, p_c, init_pop, functionSet, terminalSet, dataSet, K = 2) :
    cpu = CPU()
    population = init_pop
    list_gen = [[], []]

    fitness = [computeFitness(population[i], cpu, dataSet) for i in range(len(population))]
    max = np.max(fitness)
    i = fitness.index(max)
    average = np.average(fitness)

    list_gen[0].append(population[i])
    list_gen[1].append(average)

    generation = 0
    while generation < gen :
        population = selection(population, cpu, dataSet)
        population = crossover(population, p_c)
        population = mutation(population, p_m, terminalSet, functionSet)

        fitness = [computeFitness(population[i], cpu, dataSet) for i in range(len(population))]
        max = np.max(fitness)
        i = fitness.index(max)
        average = np.average(fitness)

        list_gen[0].append(population[i])
        list_gen[1].append(average)

        generation += 1
        
    return population[i], list_gen


#-------------------------------------

# LOOK-UP TABLE YOU HAVE TO REPRODUCE.
nbVar = 4
dataSet = [[0, 0, 0, 0, 0], [0, 0, 0, 1, 1], [0, 0, 1, 0, 0], [0, 0, 1, 1, 0], [0, 1, 0, 0, 0], [0, 1, 0, 1, 0], [0, 1, 1, 0, 0], [0, 1, 1, 1, 1], [1, 0, 0, 0, 0], [1, 0, 0, 1, 1], [1, 0, 1, 0, 0], [1, 0, 1, 1, 0], [1, 1, 0, 0, 0], [1, 1, 0, 1, 0], [1, 1, 1, 0, 0], [1, 1, 1, 1, 0]]
print("dataset", dataSet)

cpu = CPU()

# Function and terminal sets.
functionSet = ["AND", "OR", "NOT", "XOR"]
terminalSet = ["X1", "X2","X3", "X4"]

# Example of program.
prog = ["X1", "X2", "AND", "X3", "OR"]
progLength = 5
#prog=randomProg(progLength,functionSet,terminalSet)
print("Prog", prog)

# Execute a program on one row of the data set.
data = dataSet[0]
output = execute(prog,cpu,data)
print(output)
print("-------------")

# Parameters
popSize = 1000
p_c = 0.5
p_m = 0.25
progLength = 10
#progLength = 5
gen = 100

# Generate the initial population 
init_pop = gen_initial_population(popSize, progLength, functionSet, terminalSet)

print(execute(init_pop, CPU(), data))

# Evolution. Loop on the creation of population at generation i+1 from population at generation i, through selection, crossover and mutation.
solution, list_gen = genetic_algorithm(gen, p_m, p_c, init_pop, functionSet, terminalSet, dataSet)

fig = plt.figure()
ax = fig.add_subplot(111)
x = [i for i in range(len(list_gen[0]))]

ax.plot(x, list_gen[0], label = "Best")
ax.plot(x, list_gen[1], label = "Average")
ax.legend()
ax.set_xlabel("generation")
ax.set_ylabel("fitness")
plt.show()