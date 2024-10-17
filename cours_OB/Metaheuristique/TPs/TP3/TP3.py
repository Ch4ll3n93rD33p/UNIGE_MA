# Metaheuristics for optimization TP3
# 31.10.2022  
# Lea Heiniger

import fuctions as func

if len(func.sys.argv) > 1 : 
    
    # We run 10 times Greedy and SA algorithms on the TSP from the given file
    
    file = func.sys.argv[1]
    cities = func.extract_cities(file)
    
    energyG = []
    energySA = []

    for _ in range(10) :

        pathG = func.greedy(cities)
        pathSA = func.simulate_annealing(cities)

        energyG.append(func.energy(pathG))
        energySA.append(func.energy(pathSA))

    #print()
    #print("Best energy for Greedy algorithm : ", func.np.min(energyG))
    ##print("Best energy for SA : ", func.np.min(energySA))
    #print("Mean of the energies for SA : ", func.np.mean(energySA))
    #print("Worst energy for the SA : ", func.np.max(energySA))
    #print()

    func.display(cities, pathG, pathSA)
    func.box_display([energyG, energySA], ["Greedy Algorithm", "Simulated Annealing"], "Energy of the solutions for file "+file)

else :
    
    # We run 10 times both algorithms on a random TSP of size N
    
    EG = []
    TG = []
    ESA = []
    TSA = []

    N = 50
    cities = func.random_TSP(N)


    #for N in [50, 60, 80, 100] :

    for i in [10,50,100,150] :
    
        
        energyG = []
        energySA = []
        timeG = []
        timeSA = []

        #cities = func.random_TSP(N)

        #for _ in range(10) :  

        for _ in range(i) :

            startG = func.time()
            pathG = func.greedy(cities)
            stopG = func.time()

            startSA = func.time()
            pathSA = func.simulate_annealing(cities)
            stopSA = func.time()

            energyG.append(func.energy(pathG))
            energySA.append(func.energy(pathSA))
            timeG.append(stopG-startG)
            timeSA.append(stopSA-startSA)
        
        #func.display_TSP(cities, "randomly generated TSP with "+str(N)+" cities")
        
        print()
        print("Best energy for Greedy algorithm for N="+str(N)+" : ", func.np.min(energyG))
        print("Best energy for SA for N="+str(N)+" : ", func.np.min(energySA))
        print("Mean of the energies for SA : ", func.np.mean(energySA))
        print("Worst energy for the SA : ", func.np.max(energySA))
        print()

        #func.box_display([energyG, energySA], ["Greedy Algorithm", "Simulated Annealing"], "Energy of the solutions for random TSP after "+str(i)+" run")


        #func.box_display([energyG, energySA], ["Greedy Algorithm", "Simulated Annealing"], "Energy of the solutions for random TSP with "+str(N)+" cities")
        #func.box_display([timeG, timeSA], ["Greedy Algorithm", "Simulated Annealing"], "Computation time for random TSP with "+str(N)+" cities")

        EG.append(energyG)
        TG.append(timeG)
        ESA.append(energySA)
        TSA.append(timeSA)
    
    colNames = ["N=50", "N=60", "N=80", "N=100"]
    #func.box_display(EG, colNames, "Energy of solutions with the Greedy Algorithm")
    #func.box_display(ESA, colNames, "Energy of solutions with the Simulated Annealing")
    #func.box_display(TG, colNames, "Computation time of the Greedy Algorithm")
    #func.box_display(TSA, colNames, "Computation time of the Simulated Annealing")


