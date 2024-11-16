import itertools
import math
import random
import networkx as nx
import numpy as np
from matplotlib import pyplot as plt
import sys

class Node:
    """
    A template class for a node.
    """
    nodes: list = []
    label: int = -1

    def __init__(self, label: str):
        self.label = label
        self.nodes = []

    def attach(self, node) -> tuple:
        self.nodes.append(node)
        node.nodes.append(self)

        return self.label, node.label

    def is_attached(self, node) -> bool:
        return node in self.nodes or self in node.nodes


def do_erdos_renyi(n: int, p: float) -> tuple:
    """
    Generates a graph based on the erdos renyi algorithm
    :param n: The number of nodes required for this graph
    :param p: The linking probability
    :return: A list of nodes, a list of edges. This allows for easier
    exploration and also easier usage of the nxgraph package.
    """
    pairs = list(itertools.combinations(range(n), 2))
    shouldPair = [np.random.choice([True, False], p=[p, 1 - p]) for _ in range(len(pairs))]

    nodes = [Node(k) for k in range(n)]
    edges = [pair for i, pair in enumerate(pairs) if shouldPair[i]]

    # Linking different nodes based on the previous filter  
    for pair in edges:
        a, b = nodes[pair[0]], nodes[pair[1]]
        if a not in b.nodes and b not in a.nodes:
            pair = a.attach(b)
            if pair not in edges and (b.label, a.label) not in edges:
                edges.append(pair)

    return nodes, edges


### TODO
def do_barabasi_albert(n0, n, t) -> tuple:
    """
    Generates a graph based on the barabasi albert algorithm
    :param n0: The initial number of nodes for the graph. Note : we can use the erdos renyi to make our life simpler
    :param n: The required degree for each node
    :param t: The number of iterations
    :return: A list of nodes, a list of edges. This allows for easier
    exploration and also easier usage of the nxgraph package.
    """

    ### Initial state
    # You can generate the initial state with the Erdos Renyi method
    nodes, edges = do_erdos_renyi(n0, 0.5)

    ### Iterations of the BA algorithm
    for _ in range(1): #t):
        
        ### Growth
        a = Node(len(nodes))
        nodes.append(a)

        ### Preferential connection
        # You can use the numpy function np.random.choice(nodes_list, p=p_i) to draw a node weighted by the probability p_i
        #while ... : # TODO n times
        p_i = [1/len(nodes) for _ in range(len(nodes))] # TODO change p_i
        b = np.random.choice(nodes, p=p_i)
        pair = a.attach(b)
        edges.append(pair)

    return nodes, edges


def draw_graph(nodes: list, edges: list, add_labels: bool = True) -> None:
    plt.figure()
    graph = nx.Graph()
    graph.add_nodes_from([node.label for node in nodes])
    graph.add_edges_from([edge for edge in edges])

    nx.draw(graph, node_color=[len(node.nodes) for node in nodes], with_labels=add_labels, alpha=.9,
            cmap=plt.cm.Reds)
    plt.show()

# Erdos-rényi
def ER(n, p):
    nodes, edges = do_erdos_renyi(n, p)

    print("Showing Erdos–Renyi graph for n = {} and p = {}".format(n, p))
    draw_graph(nodes, edges)

# Barabasi-Albert
def BA(n0, n, t):
    nodes, edges = do_barabasi_albert(n0, n, t)
    print("Showing Barabasi Albert for n0 = {}, n = {}, t = {}".format(n0, n, t))
    draw_graph(nodes, edges)


if __name__ == '__main__':

    # Example graph with the Erdos Renyi method
    n = 10
    p = 0.5
    ER(n,p)

    # Initial number of nodes
    n0 = 10
    # Number of nodes to connect to, for each new node. Should be <= current number of nodes
    n = 2
    # Final time, dt = 1
    t = 10
    ### TODO implement the do_barabasi_albert function
    BA(n0,n,t)
    