# PROBLEM DESCRIPTION:
See [Where's My Internet](https://open.kattis.com/problems/wheresmyinternet).

# SOLUTION DESCRIPTION:
We solve this problem by aggregating the input into a graph and performing breadth-first search to differentiate which houses are and are not connected to the source (house #1).

The input gives us pairs of connected houses. We enter these into an adjacency-list format in order to perform breadth-first search, which then sets bits in a bit vector corresponding to discovered houses. After the BFS, any unset bits are interpreted as disconnected houses.

We also make some short-circuit checks based on the size of the input to avoid performing BFS, though this unfortunately does not actually work on the kattis tests: When input is sufficiently large, we know every node must be connected to the source, and if the graph is devoid entirely of edges, we know all houses must be disconnected.