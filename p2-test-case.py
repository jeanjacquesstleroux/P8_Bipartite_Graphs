"""
@author: stleroux
"""
import numpy as np
import networkx as nx
import matplotlib.pyplot as plt

def is_p2_free(adj_matrix):
    rows, cols = adj_matrix.shape # Get dimensions of adj matrix

    for i in range(rows):
        for j in range(cols):
            if adj_matrix[i, j] == 1:
                # Check if there's a non-zero entry in rows and/or columns
                row_sum = np.sum(adj_matrix[i, :])
                col_sum = np.sum(adj_matrix[:, j])
                if row_sum >= 1 and col_sum >= 1:
                    return False

    return True

def display_bipartite_graph(adj_matrix):
    G = nx.Graph() # Initialize empty graph object
    rows, cols = adj_matrix.shape # Get dimensions of adjacency matrix
    G.add_nodes_from(range(rows), bipartite=0)  # First set of nodes (0)
    G.add_nodes_from(range(rows, rows + cols), bipartite=1)  # Second set of nodes (1)

    # Add edges to the graph based on the adjacency matrix.
    for i in range(rows):
        for j in range(cols):
            if adj_matrix[i, j] == 1:
                G.add_edge(i, j + rows)

    # Identify the left nodes, and assign them to be blue. 
    # Else, the nodes are red.
    left_nodes = [node for node, attr in G.nodes(data=True) if attr['bipartite'] == 0]
    node_colors = ['blue' if node in left_nodes else 'red' for node in G.nodes]
    
    # Compute layout of graph to display with matplotlib
    pos = nx.bipartite_layout(G, [i for i in range(rows)])

    # Initializing plot dimensions and colors
    plt.figure(figsize=(8, 6))
    nx.draw(G, pos, with_labels=True, node_color=node_colors, font_size=12, node_size=500)
    plt.show()

# Define adjacency matrix (UxV)
# Can replace this with any adjacency matrix.

# adjacency_matrix = np.array([[0, 0, 0, 0],
#                              [0, 0, 0, 0],
#                              [0, 0, 0, 0],
#                              [0, 0, 0, 0]])

if is_p2_free(adjacency_matrix):
    print("The graph is P2 Free.")
else:
    print("The graph is not P2 Free.")

display_bipartite_graph(adjacency_matrix)
