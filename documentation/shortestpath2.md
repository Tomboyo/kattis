# Shortestpath2
See [Single source shortest path, time table](https://open.kattis.com/problems/shortestpath2)

We use Dijkstra's algorithm and a weight function that accounts for edge "openings." When we relax each edge, we determine its weight as follows:

* If the edge is open and will never close again, then the weight is infinity;
* Otherwise, the weight is the time until the edge next becomes closed plus its cost to traverse.

In either case the weight is cheap to calculate.

Rust's standard library does not come with an implementation of a heap which supports removals or updates, so we had to implement one ourselves. Rather than go to the trouble of making something efficient, we slapped out an array-backed implementation that uses linear-probing and element-shifting. It accounts for approximately 86% of our solution's runtime (that is, 86% of 0.5s), but given that we are allowed 4s to run, this is perfectly fine.