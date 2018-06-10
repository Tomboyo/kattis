# Problem Description
See [10 Kinds of People](https://open.kattis.com/problems/10kindsofpeople)

# Solution Description
This solution approaches the problem by dividing the input into strongly-connected components (SCCs) using a breadth-first search. Any two points which lie in the same SCC are mutually reachable; if two points do not lie in the same SCC, they are not.
