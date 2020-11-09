#![feature(test)] // enable bench testing.
extern crate test;

use std::io::{stdin, stdout, Write, BufRead};
use crate::graph::Graph;

mod graph;
mod heap;
mod input;

fn main() {
    let input = stdin();
    let input_lock = input.lock();
    let mut input_iter = input_lock.lines().map(Result::unwrap);

    let output = stdout();
    let mut output_lock = output.lock();

    solve(&mut input_iter, &mut output_lock);
}

fn solve(input: &mut dyn Iterator<Item=String>, output: &mut dyn Write) {
    let mut header = read_header(input);
    let mut first = true;
    while header != (0, 0, 0, 0) {
        if !first {
            writeln!(output).expect("Failed to print blank line");
        }
        first = false;

        let (nodes, edges, queries, origin_id) = header;
        let mut graph = Graph::new(nodes);

        for _ in 0..edges {
            let (source_id, dest_id, t_zero, period, cost) = read_edge(input);
            graph.add_edge(source_id, graph::Edge {dest_id, t_zero, period, cost});
        }

        let estimates = graph.single_source_shortest_path(origin_id);

        for _ in 0..queries {
            let query_id = read_query(input);
            let estimate = &estimates[query_id];
            writeln!(output, "{}", match estimate {
                graph::Estimate::Unreachable => String::from("Impossible"),
                graph::Estimate::Reachable(v) => v.to_string(),
            }).expect("Failed to write answer");
        }

        header = read_header(input);
    }
}

fn read_header(input: &mut dyn Iterator<Item=String>) -> (usize, usize, usize, usize) {
    let line = input.next().unwrap();
    scan!(line, usize, usize, usize, usize)
}

fn read_edge(input: &mut dyn Iterator<Item=String>) -> (usize, usize, u16, u16, u16) {
    let line = input.next().unwrap();
    scan!(line, usize, usize, u16, u16, u16)
}

fn read_query(input: &mut dyn Iterator<Item=String>) -> usize {
    let line = input.next().unwrap();
    scan!(line, usize)
}