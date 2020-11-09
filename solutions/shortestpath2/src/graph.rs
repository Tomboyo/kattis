use crate::heap::MinHeap;
use crate::graph::Estimate::Unreachable;
use crate::graph::Estimate::Reachable;
use crate::graph::Visit::Enqueued;
use crate::graph::Visit::Dequeued;
use crate::graph::Visit::Never;

pub struct Graph {
    nodes: usize,
    pub edges: Vec<Vec<Edge>>,
}

#[derive(Debug, Eq, PartialEq)]
pub enum Estimate {
    Unreachable,
    Reachable(usize),
}

pub struct Edge {
    pub dest_id: NodeId,
    pub t_zero: u16,
    pub period: u16,
    pub cost: u16,
}

enum Visit {
    // Element has been added to the heap
    Enqueued,
    // Element has been removed from the heap
    Dequeued,
    // Element has never been added to the heap
    Never
}

pub type NodeId = usize;

impl Graph {
    pub fn new(nodes: usize) -> Self {
        let mut edges = Vec::with_capacity(nodes);
        for _ in 0..nodes {
            edges.push(Vec::new());
        }

        Graph { nodes, edges }
    }

    pub fn add_edge(&mut self, source: NodeId, edge: Edge) {
        self.edges[source].push(edge);
    }

    pub fn single_source_shortest_path(&self, origin_id: NodeId) -> Vec<Estimate> {
        let mut estimates = Vec::with_capacity(self.nodes);
        let mut visited = Vec::with_capacity(self.nodes);

        for _ in 0..self.nodes {
            estimates.push(Unreachable);
            visited.push(Never);
        }
        estimates[origin_id] = Reachable(0);
        visited[origin_id] = Enqueued;

        let mut heap = MinHeap::new();
        heap.push(origin_id, 0);

        while let Some(source_id) = heap.pop() {
            visited[source_id] = Dequeued;

            for edge in &self.edges[source_id] {
                if let Some(Reachable(new_estimate))
                        = Self::relax(&mut estimates, source_id, edge) {
                    estimates[edge.dest_id] = Reachable(new_estimate);
                    match visited[edge.dest_id] {
                        Enqueued => {
                            heap.update(edge.dest_id, new_estimate);
                        },
                        Never => {
                            visited[edge.dest_id] = Enqueued;
                            heap.push(edge.dest_id, new_estimate);
                        },
                        Dequeued => { /* no-op */ }
                    }
                }
            }
        }

        estimates
    }

    fn relax(estimates: &mut Vec<Estimate>, source_id: usize, edge: &Edge) -> Option<Estimate> {
        let t_now = match estimates[source_id] {
            Reachable(x) => x,
            Unreachable => panic!("Attempted to relax from an unreachable source")
        };

        if t_now > edge.t_zero as usize && edge.period == 0 {
            return None;
        } else {
            let mut t_next = edge.t_zero as usize;
            while t_next < t_now {
                t_next += edge.period as usize;
            }
            // t_next >= t_now
            let new_estimate = t_next + edge.cost as usize;
            match estimates[edge.dest_id] {
                Unreachable => Some(Reachable(new_estimate)),
                Reachable(estimate) => {
                    if new_estimate < estimate {
                        Some(Reachable(new_estimate))
                    } else {
                        None
                    }
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use rand::thread_rng;
    use rand::Rng;
    use test::Bencher;

    #[test]
    fn source_estimate_is_zero() {
        let graph = Graph::new(1);
        let estimates = graph.single_source_shortest_path(0);
        assert_eq!(Estimate::Reachable(0), estimates[0]);
    }

    #[test]
    fn longer_path_with_shorter_estimate() {
        let mut graph = Graph::new(3);
        graph.add_edge(0, Edge { dest_id: 1, t_zero: 0, period: 1, cost: 1 });
        graph.add_edge(1, Edge { dest_id: 2, t_zero: 1, period: 1, cost: 1 });
        graph.add_edge(0, Edge { dest_id: 2, t_zero: 0, period: 1, cost: 10});
        let estimates = graph.single_source_shortest_path(0);
        assert_eq!(Estimate::Reachable(2), estimates[2]);
    }

    #[test]
    fn unreachable() {
        let graph = Graph::new(2);
        let estimates = graph.single_source_shortest_path(0);
        assert_eq!(Estimate::Unreachable, estimates[1]);
    }

    #[test]
    fn unreachable_due_to_opening() {
        let mut graph = Graph::new(3);
        graph.add_edge(0, Edge { dest_id: 1, t_zero: 0, period: 1, cost: 1 });
        graph.add_edge(1, Edge { dest_id: 2, t_zero: 0, period: 0, cost: 1 });
        let estimates = graph.single_source_shortest_path(0);
        assert_eq!(Estimate::Unreachable, estimates[2]);
    }

    #[test]
    fn account_for_time_to_wait() {
        let mut graph = Graph::new(3);
        graph.add_edge(0, Edge { dest_id: 1, t_zero: 5, period: 1, cost: 1 });
        graph.add_edge(1, Edge { dest_id: 2, t_zero: 10, period: 0, cost: 1 });
        let estimates = graph.single_source_shortest_path(0);
        assert_eq!(Estimate::Reachable(6), estimates[1]);
        assert_eq!(Estimate::Reachable(11), estimates[2]);
    }

    #[test]
    fn ignore_cycles() {
        let mut graph = Graph::new(3);
        graph.add_edge(0, Edge { dest_id: 1, t_zero: 0, period: 0, cost: 0 });
        graph.add_edge(1, Edge { dest_id: 2, t_zero: 0, period: 0, cost: 0 });
        graph.add_edge(2, Edge { dest_id: 0, t_zero: 0, period: 0, cost: 0 });
        let estimates = graph.single_source_shortest_path(0);
        assert_eq!(Estimate::Reachable(0), estimates[2]);
    }

    #[bench]
    fn perf_estimate(bencher: &mut Bencher) {
        let nodes = 10_000;
        let edges = 20_000;
        let mut graph = Graph::new(nodes);

        let mut rng = thread_rng();
        for _ in 0..edges {
            let source_id = rng.gen_range(0, nodes);
            let dest_id = rng.gen_range(0, nodes);
            let t_zero = rng.gen_range(0, 1_000);
            let period = rng.gen_range(0, 1_000);
            let cost = rng.gen_range(0, 1_000);
            graph.add_edge(source_id, Edge { dest_id, t_zero, period, cost });
        }

        bencher.iter(|| graph.single_source_shortest_path(0));
    }
}